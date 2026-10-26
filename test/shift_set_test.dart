import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:suprsync/models/shift_set.dart';
import 'package:suprsync/presentation/dashboard_screen/shift_set/shift_set_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/shift_set/shift_set_day_list.dart';
import 'package:suprsync/presentation/dashboard_screen/shift_set/shift_set_period_modal.dart';
import 'package:suprsync/services/shift_set_service.dart';

void main() {
  final monday = DateTime(2026, 10, 26);

  group('shift set periods', () {
    test('a week, two weeks, and four weeks have fixed lengths', () {
      expect(ShiftSetPeriod.oneWeek.lengthOn(monday), 7);
      expect(ShiftSetPeriod.twoWeeks.lengthOn(monday), 14);
      expect(ShiftSetPeriod.fourWeeks.lengthOn(monday), 28);
    });

    test('a month runs until the same day next month', () {
      expect(ShiftSetPeriod.oneMonth.lengthOn(monday), 31);
      expect(
        ShiftSetPeriod.oneMonth.lengthOn(DateTime(2026, 1, 31)),
        28,
      );
      expect(
        ShiftSetPeriod.oneMonth.lengthOn(DateTime(2024, 1, 31)),
        29,
      );
    });

    test('one week lists every day from the anchor', () {
      final days = ShiftSetDay.generate(anchor: monday, lengthDays: 7);
      expect(days, hasLength(7));
      expect(days.first.patternLabel, 'First Monday');
      expect(days[1].patternLabel, 'First Tuesday');
      expect(days.last.date, DateTime(2026, 11, 1));
      expect(days.last.patternLabel, 'First Sunday');
    });
  });

  group('repeating availability', () {
    test('a weekly set matches the same weekdays next week', () {
      final set = ShiftSet.compose(
        userId: 'user-1',
        period: ShiftSetPeriod.oneWeek,
        anchor: monday,
        selectedOffsets: {0, 3, 4, 6},
        utcOffsetMinutes: 60,
      );

      expect(set.covers(DateTime(2026, 10, 26)), isTrue);
      expect(set.covers(DateTime(2026, 10, 29)), isTrue);
      expect(set.covers(DateTime(2026, 10, 30)), isTrue);
      expect(set.covers(DateTime(2026, 11, 1)), isTrue);
      expect(set.covers(DateTime(2026, 10, 27)), isFalse);
      expect(set.covers(DateTime(2026, 11, 2)), isTrue);
      expect(set.covers(DateTime(2026, 11, 5)), isTrue);
    });

    test('a two-week set keeps first and second weeks apart', () {
      // First Tuesday, Wednesday, Saturday.
      // Second Monday, Wednesday, Thursday.
      final set = ShiftSet.compose(
        period: ShiftSetPeriod.twoWeeks,
        anchor: monday,
        selectedOffsets: {1, 2, 5, 7, 9, 10},
        utcOffsetMinutes: 60,
      );

      expect(set.availableDays.map((day) => day.patternLabel), [
        'First Tuesday',
        'First Wednesday',
        'First Saturday',
        'Second Monday',
        'Second Wednesday',
        'Second Thursday',
      ]);

      expect(set.covers(DateTime(2026, 10, 27)), isTrue);
      expect(set.covers(DateTime(2026, 11, 2)), isTrue);
      expect(set.covers(DateTime(2026, 11, 5)), isTrue);
      expect(set.covers(DateTime(2026, 10, 26)), isFalse);
      expect(set.covers(DateTime(2026, 11, 3)), isFalse);

      expect(set.covers(DateTime(2026, 11, 10)), isTrue);
      expect(set.covers(DateTime(2026, 11, 16)), isTrue);
    });

    test('a month repeats by calendar date', () {
      final set = ShiftSet.compose(
        period: ShiftSetPeriod.oneMonth,
        anchor: monday,
        selectedOffsets: {1, 6},
        utcOffsetMinutes: 60,
      );

      expect(set.repeat, ShiftSetRepeat.dayOfMonth);
      expect(set.covers(DateTime(2026, 10, 27)), isTrue);
      expect(set.covers(DateTime(2026, 11, 1)), isTrue);
      expect(set.covers(DateTime(2026, 12, 27)), isTrue);
      expect(set.covers(DateTime(2027, 1, 1)), isTrue);
      expect(set.covers(DateTime(2026, 11, 2)), isFalse);
    });
  });

  group('json document', () {
    test('round trips the stored document', () {
      final set = ShiftSet.compose(
        id: 'set-1',
        userId: 'user-1',
        companyId: 'company-1',
        period: ShiftSetPeriod.twoWeeks,
        anchor: monday,
        selectedOffsets: {1, 7},
        utcOffsetMinutes: 60,
      );

      final restored = ShiftSet.fromJson(set.toJson());

      expect(restored.version, 1);
      expect(restored.id, 'set-1');
      expect(restored.userId, 'user-1');
      expect(restored.companyId, 'company-1');
      expect(restored.period, ShiftSetPeriod.twoWeeks);
      expect(restored.repeat, ShiftSetRepeat.cycleOffset);
      expect(restored.anchorDate, monday);
      expect(restored.lengthDays, 14);
      expect(restored.utcOffsetMinutes, 60);
      expect(restored.availableDays.map((day) => day.toJson()).toList(), [
        {
          'offset': 1,
          'date': '2026-10-27',
          'weekday': 'tuesday',
          'weekIndex': 1,
          'dayOfMonth': 27,
        },
        {
          'offset': 7,
          'date': '2026-11-02',
          'weekday': 'monday',
          'weekIndex': 2,
          'dayOfMonth': 2,
        },
      ]);
      expect(restored.covers(DateTime(2026, 11, 10)), isTrue);
    });

    test('accepts a wrapped or listed payload and ignores unknown periods', () {
      final document = ShiftSet.compose(
        userId: 'user-1',
        period: ShiftSetPeriod.oneWeek,
        anchor: monday,
        selectedOffsets: {0},
        utcOffsetMinutes: 60,
      ).toJson();

      expect(
        ShiftSet.tryParse({'shiftSet': document})?.period,
        ShiftSetPeriod.oneWeek,
      );
      expect(
        ShiftSet.tryParse({'data': document}, userId: 'user-1')?.userId,
        'user-1',
      );
      expect(ShiftSet.tryParse([document], userId: 'someone-else'), isNull);
      expect(ShiftSet.tryParse({'period': 'forever'}), isNull);
      expect(ShiftSet.tryParse(null), isNull);
    });
  });

  group('editing an existing set', () {
    test('aligns the visible window to the current cycle', () {
      final existing = ShiftSet.compose(
        period: ShiftSetPeriod.twoWeeks,
        anchor: DateTime(2026, 10, 5),
        selectedOffsets: {1, 8},
        utcOffsetMinutes: 60,
      );

      final anchor = displayAnchor(
        existing: existing,
        period: ShiftSetPeriod.twoWeeks,
        today: DateTime(2026, 10, 26),
      );
      final days = ShiftSetDay.generate(anchor: anchor, lengthDays: 14);
      final selected = initialSelection(
        existing: existing,
        period: ShiftSetPeriod.twoWeeks,
        days: days,
      );

      expect(anchor, DateTime(2026, 10, 19));
      expect(selected, {1, 8});
      expect(
        initialSelection(
          existing: existing,
          period: ShiftSetPeriod.oneWeek,
          days: days,
        ),
        isEmpty,
      );
    });
  });

  test('saving a week keeps the selected weekdays', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final service = _MemoryShiftSetService();
    final controller = ShiftSetController(service: service);
    controller.rememberSession(
      token: 'token',
      userId: 'user-1',
      companyId: 'company-1',
    );
    controller.prepare(ShiftSetPeriod.oneWeek, today: monday);
    controller.toggle(0);
    controller.toggle(3);

    expect(await controller.save(), isTrue);

    final saved = controller.shiftSet.value!;
    expect(saved.userId, 'user-1');
    expect(saved.companyId, 'company-1');
    expect(saved.covers(DateTime(2026, 11, 2)), isTrue);
    expect(saved.covers(DateTime(2026, 10, 29)), isTrue);
    expect(saved.covers(DateTime(2026, 10, 27)), isFalse);
    expect(service.stored, same(saved));
  });

  testWidgets('day list shows the whole week and toggles a day',
      (tester) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final days = ShiftSetDay.generate(anchor: monday, lengthDays: 7);
    final selected = <int>{};
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ShiftSetDayList(
            days: days,
            selectedOffsets: selected,
            repeat: ShiftSetRepeat.cycleOffset,
            onToggle: (offset) => selected.add(offset),
          ),
        ),
      ),
    );

    expect(find.text('First week'), findsOneWidget);
    expect(find.text('First Monday'), findsOneWidget);
    expect(find.text('First Sunday'), findsOneWidget);
    expect(find.text('26 Oct 2026'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('shift-day-1')));
    await tester.pump();

    expect(selected, {1});
  });

  testWidgets('next returns the period chosen in the modal', (tester) async {
    ShiftSetPeriod? chosen;
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
    Get.dialog(ShiftSetPeriodDialog(onNext: (period) => chosen = period));
    await tester.pumpAndSettle();

    expect(find.text('1 week'), findsOneWidget);
    expect(find.text('2 weeks'), findsOneWidget);
    expect(find.text('4 weeks'), findsOneWidget);
    expect(find.text('1 month'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('shift-period-two_weeks')));
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(chosen, ShiftSetPeriod.twoWeeks);
    Get.reset();
  });
}

class _MemoryShiftSetService extends ShiftSetService {
  ShiftSet? stored;

  @override
  Future<ShiftSet?> fetch({
    required String token,
    required String userId,
  }) async {
    return stored;
  }

  @override
  Future<ShiftSet> save({
    required String token,
    required String userId,
    required ShiftSet shiftSet,
  }) async {
    stored = shiftSet;
    return shiftSet;
  }
}
