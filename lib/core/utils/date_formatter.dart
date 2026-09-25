class DateFormatter {
  static String format(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'غير متوفر';
    try {
      // Handle potential date-only strings like "2026-09-19"
      if (isoString.length == 10 && isoString.contains('-')) {
        final parts = isoString.split('-');
        if (parts.length == 3) {
          return '${parts[0]}/${parts[1]}/${parts[2]}';
        }
      }
      final dateTime = DateTime.parse(isoString);
      return formatDateTime(dateTime);
    } catch (_) {
      return isoString;
    }
  }

  static String formatDateTime(DateTime dateTime) {
    try {
      final hour = dateTime.hour;
      final minute = dateTime.minute;
      final isPm = hour >= 12;
      final formattedHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      final hourStr = formattedHour.toString().padLeft(2, '0');
      final minuteStr = minute.toString().padLeft(2, '0');
      final period = isPm ? 'PM' : 'AM';

      final year = dateTime.year;
      final month = dateTime.month.toString().padLeft(2, '0');
      final day = dateTime.day.toString().padLeft(2, '0');

      return '$hourStr:$minuteStr $period  •  $year/$month/$day';
    } catch (_) {
      return dateTime.toString();
    }
  }
}

extension DateStringExt on String {
  String toReadableDateTime() {
    return DateFormatter.format(this);
  }
}

extension DateTimeExt on DateTime {
  String toReadableDateTime() {
    return DateFormatter.formatDateTime(this);
  }
}
