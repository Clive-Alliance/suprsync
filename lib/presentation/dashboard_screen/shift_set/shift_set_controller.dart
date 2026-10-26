import 'package:get/get.dart';
import 'package:suprsync/models/shift_set.dart';
import 'package:suprsync/services/shift_set_service.dart';

class ShiftSetController extends GetxController {
  ShiftSetController({ShiftSetService? service})
      : _service = service ?? ShiftSetService();

  final ShiftSetService _service;

  final shiftSet = Rxn<ShiftSet>();
  final period = Rxn<ShiftSetPeriod>();
  final selectedOffsets = <int>{}.obs;
  final isSaving = false.obs;

  DateTime anchor = dateOnly(DateTime.now());
  String _token = '';
  String _userId = '';
  String? _companyId;

  String get userId => _userId;

  List<ShiftSetDay> get days {
    final current = period.value;
    if (current == null) return const [];
    return ShiftSetDay.generate(
      anchor: anchor,
      lengthDays: current.lengthOn(anchor),
    );
  }

  void rememberSession({
    required String token,
    required String userId,
    String? companyId,
  }) {
    _token = token;
    _userId = userId;
    _companyId = companyId;
  }

  Future<bool> loadCurrent({
    required String token,
    required String userId,
    String? companyId,
  }) async {
    rememberSession(token: token, userId: userId, companyId: companyId);
    if (token.isEmpty || userId.isEmpty) return shiftSet.value != null;
    final loaded = await _service.fetch(token: token, userId: userId);
    shiftSet.value = loaded;
    return loaded != null;
  }

  void prepare(
    ShiftSetPeriod next, {
    DateTime? today,
    bool keepCurrentSelection = false,
  }) {
    if (keepCurrentSelection && period.value == next) return;
    final now = dateOnly(today ?? DateTime.now());
    anchor = displayAnchor(
      existing: shiftSet.value,
      period: next,
      today: now,
    );
    period.value = next;
    final generated = ShiftSetDay.generate(
      anchor: anchor,
      lengthDays: next.lengthOn(anchor),
    );
    selectedOffsets
      ..clear()
      ..addAll(
        initialSelection(
          existing: shiftSet.value,
          period: next,
          days: generated,
        ),
      );
  }

  void toggle(int offset) {
    if (selectedOffsets.contains(offset)) {
      selectedOffsets.remove(offset);
    } else {
      selectedOffsets.add(offset);
    }
  }

  Future<bool> save() async {
    final current = period.value;
    if (current == null || selectedOffsets.isEmpty || _userId.isEmpty) {
      return false;
    }
    final existing = shiftSet.value;
    final samePeriod = existing != null && existing.period == current;
    isSaving.value = true;
    try {
      final draft = ShiftSet.compose(
        id: samePeriod ? existing.id : null,
        userId: _userId,
        companyId: _companyId,
        createdOn: samePeriod ? existing.createdOn : null,
        period: current,
        anchor: anchor,
        selectedOffsets: Set<int>.from(selectedOffsets),
      );
      final saved = await _service.save(
        token: _token,
        userId: _userId,
        shiftSet: draft,
      );
      shiftSet.value = saved;
      return true;
    } finally {
      isSaving.value = false;
    }
  }
}
