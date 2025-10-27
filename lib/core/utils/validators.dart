import 'package:enevtly/core/constants/app_constants.dart';

/// Validation utilities
class Validators {
  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }
  
  /// Validate event title
  static String? validateEventTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    
    if (value.length < AppConstants.minEventTitleLength) {
      return 'Title must be at least ${AppConstants.minEventTitleLength} characters';
    }
    
    if (value.length > AppConstants.maxEventTitleLength) {
      return 'Title must not exceed ${AppConstants.maxEventTitleLength} characters';
    }
    
    return null;
  }
  
  /// Validate event description
  static String? validateEventDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    
    if (value.length < AppConstants.minEventDescriptionLength) {
      return 'Description must be at least ${AppConstants.minEventDescriptionLength} characters';
    }
    
    if (value.length > AppConstants.maxEventDescriptionLength) {
      return 'Description must not exceed ${AppConstants.maxEventDescriptionLength} characters';
    }
    
    return null;
  }
  
  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  /// Validate event date (must be in future)
  static String? validateEventDate(DateTime? date) {
    if (date == null) {
      return 'Date is required';
    }
    
    if (date.isBefore(DateTime.now())) {
      return 'Event date must be in the future';
    }
    
    return null;
  }
}
