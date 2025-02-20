class Prayer {
  final String label;
  final String icon;
  final String time;
  bool isAlarm;
  bool isReminder;

  Prayer({
    required this.label,
    required this.icon,
    required this.time,
    this.isAlarm = false,
    this.isReminder = false,
  });

  // Convert from JSON (API Response)
  factory Prayer.fromJson(
      Map<String, dynamic> json, String label, String icon) {
    return Prayer(
      label: label,
      icon: icon,
      time: json['time'],
    );
  }

  DateTime getDateTime() {
    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}
