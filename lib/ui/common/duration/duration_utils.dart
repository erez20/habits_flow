extension DurationFormatter on int {
  String toFormattedDuration() {
    if (this <= 0) return "0S";

    // Constants for time conversions
    const int secondsInWeek = 604800;
    const int secondsInDay = 86400;
    const int secondsInHour = 3600;
    const int secondsInMinute = 60;

    int remaining = this;

    int weeks = remaining ~/ secondsInWeek;
    remaining %= secondsInWeek;

    int days = remaining ~/ secondsInDay;
    remaining %= secondsInDay;

    int hours = remaining ~/ secondsInHour;
    remaining %= secondsInHour;

    int minutes = remaining ~/ secondsInMinute;
    int seconds = remaining % secondsInMinute;

    List<String> parts = [];

    if (weeks > 0) parts.add("${weeks}W");
    if (days > 0) parts.add("${days}D");
    if (hours > 0) parts.add("${hours}H");


    if (minutes > 0) parts.add("${minutes}Min");


    if (seconds > 0) parts.add("${seconds}S");


    return parts.isEmpty ? "0S" : parts.join(" ");
  }
}