/// A staff shift set: the days someone can work, repeated over a fixed period.
///
/// One document per user is enough. Week-based sets repeat by [offset] inside
/// [lengthDays]. A month repeats by calendar day. Callers do not need a row
/// for every future date.

const weekdayKeys = <String>[
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];

const weekdayTitles = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const weekNames = <String>[
  'First',
  'Second',
  'Third',
  'Fourth',
  'Fifth',
  'Sixth',
];

enum ShiftSetRepeat {
  cycleOffset('cycle_offset'),
  dayOfMonth('day_of_month');

  const ShiftSetRepeat(this.key);
  final String key;

  static ShiftSetRepeat fromKey(String? key) {
    for (final repeat in ShiftSetRepeat.values) {
      if (repeat.key == key) return repeat;
    }
    return ShiftSetRepeat.cycleOffset;
  }
}

enum ShiftSetPeriod {
  oneWeek(
    'one_week',
    '1 week',
    'The days you pick come back every week.',
    'These days repeat every week.',
  ),
  twoWeeks(
    'two_weeks',
    '2 weeks',
    'A first week and a second week, then it starts over.',
    'These days repeat every 2 weeks.',
  ),
  fourWeeks(
    'four_weeks',
    '4 weeks',
    'Four weeks of availability, then it repeats.',
    'These days repeat every 4 weeks.',
  ),
  oneMonth(
    'one_month',
    '1 month',
    'Dates you pick, repeated on those same days each month.',
    'These dates repeat every month.',
  );

  const ShiftSetPeriod(
    this.key,
    this.label,
    this.description,
    this.cadence,
  );

  final String key;
  final String label;
  final String description;
  final String cadence;

  ShiftSetRepeat get repeat => this == ShiftSetPeriod.oneMonth
      ? ShiftSetRepeat.dayOfMonth
      : ShiftSetRepeat.cycleOffset;

  int lengthOn(DateTime anchor) {
    final start = dateOnly(anchor);
    switch (this) {
      case ShiftSetPeriod.oneWeek:
        return 7;
      case ShiftSetPeriod.twoWeeks:
        return 14;
      case ShiftSetPeriod.fourWeeks:
        return 28;
      case ShiftSetPeriod.oneMonth:
        return addMonths(start, 1).difference(start).inDays;
    }
  }

  static ShiftSetPeriod? fromKey(String? key) {
    for (final period in ShiftSetPeriod.values) {
      if (period.key == key) return period;
    }
    return null;
  }
}

DateTime dateOnly(DateTime value) => DateTime(value.year, value.month, value.day);

DateTime addMonths(DateTime date, int months) {
  final start = dateOnly(date);
  final monthIndex = start.month - 1 + months;
  final year = start.year + (monthIndex ~/ 12);
  final month = monthIndex % 12 + 1;
  final lastDay = DateTime(year, month + 1, 0).day;
  final day = start.day > lastDay ? lastDay : start.day;
  return DateTime(year, month, day);
}

String formatDateOnly(DateTime date) {
  final local = dateOnly(date);
  final year = local.year.toString().padLeft(4, '0');
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

DateTime parseDateOnly(String value) {
  final parts = value.split('-');
  if (parts.length != 3) {
    throw FormatException('Expected a YYYY-MM-DD date, got $value');
  }
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

String weekNameFor(int weekIndex) {
  if (weekIndex >= 1 && weekIndex <= weekNames.length) {
    return weekNames[weekIndex - 1];
  }
  return 'Week $weekIndex';
}

class ShiftSetDay {
  const ShiftSetDay({
    required this.date,
    required this.offset,
    required this.weekIndex,
    required this.dayOfMonth,
    required this.weekday,
  });

  final DateTime date;
  final int offset;
  final int weekIndex;
  final int dayOfMonth;
  final int weekday;

  String get weekdayKey => weekdayKeys[weekday - 1];
  String get weekdayTitle => weekdayTitles[weekday - 1];
  String get weekName => weekNameFor(weekIndex);

  /// "First Tuesday" — the weekday inside this week of the cycle.
  String get patternLabel => '$weekName $weekdayTitle';

  static List<ShiftSetDay> generate({
    required DateTime anchor,
    required int lengthDays,
  }) {
    final start = dateOnly(anchor);
    return List<ShiftSetDay>.generate(lengthDays, (offset) {
      final date = start.add(Duration(days: offset));
      return ShiftSetDay(
        date: date,
        offset: offset,
        weekIndex: offset ~/ 7 + 1,
        dayOfMonth: date.day,
        weekday: date.weekday,
      );
    });
  }

  factory ShiftSetDay.fromJson(
    Map<String, dynamic> json, {
    DateTime? anchor,
  }) {
    final offset = _asInt(json['offset']);
    final date = json['date'] == null
        ? dateOnly(anchor!).add(Duration(days: offset))
        : parseDateOnly(json['date'].toString());
    return ShiftSetDay(
      date: date,
      offset: offset,
      weekIndex: json['weekIndex'] == null
          ? offset ~/ 7 + 1
          : _asInt(json['weekIndex']),
      dayOfMonth:
          json['dayOfMonth'] == null ? date.day : _asInt(json['dayOfMonth']),
      weekday: date.weekday,
    );
  }

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'date': formatDateOnly(date),
        'weekday': weekdayKey,
        'weekIndex': weekIndex,
        'dayOfMonth': dayOfMonth,
      };
}

class ShiftSet {
  const ShiftSet({
    required this.version,
    required this.period,
    required this.repeat,
    required this.anchorDate,
    required this.lengthDays,
    required this.utcOffsetMinutes,
    required this.availableDays,
    this.id,
    this.userId,
    this.companyId,
    this.createdOn,
  });

  final int version;
  final String? id;
  final String? userId;
  final String? companyId;
  final String? createdOn;
  final ShiftSetPeriod period;
  final ShiftSetRepeat repeat;
  final DateTime anchorDate;
  final int lengthDays;
  final int utcOffsetMinutes;
  final List<ShiftSetDay> availableDays;

  factory ShiftSet.compose({
    String? id,
    String? userId,
    String? companyId,
    String? createdOn,
    required ShiftSetPeriod period,
    required DateTime anchor,
    required Set<int> selectedOffsets,
    int? utcOffsetMinutes,
  }) {
    final start = dateOnly(anchor);
    final lengthDays = period.lengthOn(start);
    final availableDays = ShiftSetDay.generate(
      anchor: start,
      lengthDays: lengthDays,
    ).where((day) => selectedOffsets.contains(day.offset)).toList()
      ..sort((a, b) => a.offset.compareTo(b.offset));

    return ShiftSet(
      version: 1,
      id: id,
      userId: userId,
      companyId: companyId,
      createdOn: createdOn,
      period: period,
      repeat: period.repeat,
      anchorDate: start,
      lengthDays: lengthDays,
      utcOffsetMinutes:
          utcOffsetMinutes ?? DateTime.now().timeZoneOffset.inMinutes,
      availableDays: availableDays,
    );
  }

  factory ShiftSet.fromJson(Map<String, dynamic> json) {
    final period = ShiftSetPeriod.fromKey(json['period']?.toString());
    if (period == null) {
      throw FormatException('Unknown shift set period: ${json['period']}');
    }
    final anchor = parseDateOnly(json['anchorDate'].toString());
    final daysJson = json['availableDays'];
    if (daysJson is! List) {
      throw const FormatException('Shift set is missing availableDays');
    }
    return ShiftSet(
      version: json['version'] == null ? 1 : _asInt(json['version']),
      id: json['id']?.toString(),
      userId: json['userId']?.toString(),
      companyId: json['companyId']?.toString(),
      createdOn: json['createdOn']?.toString(),
      period: period,
      repeat: ShiftSetRepeat.fromKey(json['repeat']?.toString()),
      anchorDate: anchor,
      lengthDays: json['lengthDays'] == null
          ? period.lengthOn(anchor)
          : _asInt(json['lengthDays']),
      utcOffsetMinutes: json['utcOffsetMinutes'] == null
          ? 0
          : _asInt(json['utcOffsetMinutes']),
      availableDays: daysJson
          .map((day) => ShiftSetDay.fromJson(
                Map<String, dynamic>.from(day as Map),
                anchor: anchor,
              ))
          .toList(),
    );
  }

  static ShiftSet? tryParse(dynamic value, {String? userId}) {
    try {
      if (value == null) return null;
      if (value is List) {
        for (final item in value) {
          final parsed = tryParse(item, userId: userId);
          if (parsed == null) continue;
          if (userId == null ||
              parsed.userId == null ||
              parsed.userId == userId) {
            return parsed;
          }
        }
        return null;
      }
      if (value is Map) {
        final map = Map<String, dynamic>.from(value);
        if (map['shiftSet'] != null) {
          return tryParse(map['shiftSet'], userId: userId);
        }
        final hasDocument =
            map['period'] != null && map['availableDays'] != null;
        if (!hasDocument && map['data'] != null) {
          return tryParse(map['data'], userId: userId);
        }
        if (!hasDocument) return null;
        return ShiftSet.fromJson(map);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'version': version,
      'period': period.key,
      'repeat': repeat.key,
      'anchorDate': formatDateOnly(anchorDate),
      'lengthDays': lengthDays,
      'utcOffsetMinutes': utcOffsetMinutes,
      'availableDays': availableDays.map((day) => day.toJson()).toList(),
    };
    if (id != null && id!.isNotEmpty) json['id'] = id;
    if (userId != null && userId!.isNotEmpty) json['userId'] = userId;
    if (companyId != null && companyId!.isNotEmpty) {
      json['companyId'] = companyId;
    }
    if (createdOn != null && createdOn!.isNotEmpty) {
      json['createdOn'] = createdOn;
    }
    return json;
  }

  /// Whether [date] falls on an available day of this repeating set.
  bool covers(DateTime date) {
    final day = dateOnly(date);
    if (repeat == ShiftSetRepeat.dayOfMonth) {
      return availableDays.any((slot) => slot.dayOfMonth == day.day);
    }
    if (lengthDays <= 0 || availableDays.isEmpty) return false;
    final difference = day.difference(dateOnly(anchorDate)).inDays;
    final remainder = difference % lengthDays;
    final offset = remainder < 0 ? remainder + lengthDays : remainder;
    return availableDays.any((slot) => slot.offset == offset);
  }
}

/// Start of the cycle that contains [today], so an edit shows the current
/// window without shifting which offsets are selected.
DateTime displayAnchor({
  ShiftSet? existing,
  required ShiftSetPeriod period,
  required DateTime today,
}) {
  final now = dateOnly(today);
  if (existing == null || existing.period != period) return now;
  if (period.repeat == ShiftSetRepeat.dayOfMonth) return now;
  final length = existing.lengthDays;
  if (length <= 0) return now;
  final difference = now.difference(dateOnly(existing.anchorDate)).inDays;
  final remainder = difference % length;
  final offset = remainder < 0 ? remainder + length : remainder;
  return now.subtract(Duration(days: offset));
}

Set<int> initialSelection({
  ShiftSet? existing,
  required ShiftSetPeriod period,
  required List<ShiftSetDay> days,
}) {
  if (existing == null || existing.period != period) return <int>{};
  if (existing.repeat == ShiftSetRepeat.dayOfMonth) {
    final daysOfMonth =
        existing.availableDays.map((day) => day.dayOfMonth).toSet();
    return days
        .where((day) => daysOfMonth.contains(day.dayOfMonth))
        .map((day) => day.offset)
        .toSet();
  }
  final offsets = existing.availableDays.map((day) => day.offset).toSet();
  return days
      .where((day) => offsets.contains(day.offset))
      .map((day) => day.offset)
      .toSet();
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.parse(value.toString());
}
