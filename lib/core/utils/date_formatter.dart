import 'package:intl/intl.dart';

/// Date formatting utilities
class DateFormatter {
  /// Format date to 'MMM dd, yyyy' (e.g., Jan 01, 2024)
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  /// Format time to 'hh:mm a' (e.g., 02:30 PM)
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
  
  /// Format date and time (e.g., Jan 01, 2024 at 02:30 PM)
  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} at ${formatTime(date)}';
  }
  
  /// Format date for display in event card (e.g., Jan 01)
  static String formatEventCardDate(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }
  
  /// Check if date is in the past
  static bool isPastDate(DateTime date) {
    return date.isBefore(DateTime.now());
  }
  
  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  /// Get relative time (e.g., "2 hours ago", "in 3 days")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.isNegative) {
      // Past
      final absDifference = difference.abs();
      if (absDifference.inDays > 0) {
        return '${absDifference.inDays} day${absDifference.inDays > 1 ? 's' : ''} ago';
      } else if (absDifference.inHours > 0) {
        return '${absDifference.inHours} hour${absDifference.inHours > 1 ? 's' : ''} ago';
      } else if (absDifference.inMinutes > 0) {
        return '${absDifference.inMinutes} minute${absDifference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } else {
      // Future
      if (difference.inDays > 0) {
        return 'in ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
      } else if (difference.inHours > 0) {
        return 'in ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
      } else if (difference.inMinutes > 0) {
        return 'in ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
      } else {
        return 'Now';
      }
    }
  }
}
