class PrayerTiming {
  final String label;
  final String icon;
  final String time;
  final bool isAlarm;
  final bool isReminder;

  PrayerTiming({
    required this.label,
    required this.icon,
    required this.time,
    this.isAlarm = false,
    this.isReminder = false,
  });

  PrayerTiming copyWith({
    String? label,
    String? icon,
    String? time,
    bool? isAlarm,
    bool? isReminder,
  }) {
    return PrayerTiming(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      time: time ?? this.time,
      isAlarm: isAlarm ?? this.isAlarm,
      isReminder: isReminder ?? this.isReminder,
    );
  }
}
