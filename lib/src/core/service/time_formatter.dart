import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormatter {
  DateTimeFormatter._();

  static String time(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('h:mm a').format(dateTime.toLocal());
  }
 /// Formats a how may time and days ago
  static String timeAgo(DateTime? dateTime) {
    if (dateTime == null) return '';

    final difference = DateTime.now().difference(dateTime.toLocal());

    if (difference.inSeconds < 60) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m";
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return DateFormat('MMM d').format(dateTime.toLocal());
    }
  }

  /// Formats a TimeOfDay to "HH:mm am/pm" for display.
  static String formatTime(TimeOfDay time) {
    final hour = (time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod)
        .toString()
        .padLeft(2, '0');

    final minute = time.minute.toString().padLeft(2, '0');
    final amPm = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $amPm';
  }

}