/// Application-wide constants
class AppConstants {
  // Routes
  static const String splashRoute = '/';
  static const String welcomeRoute = '/welcome';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String eventDetailsRoute = '/event-details';
  static const String createEventRoute = '/create-event';
  static const String profileRoute = '/profile';
  static const String searchRoute = '/search';
  
  // Storage Keys
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String userPhotoKey = 'user_photo';
  static const String isLoggedInKey = 'is_logged_in';
  
  // Validation
  static const int minEventTitleLength = 3;
  static const int maxEventTitleLength = 100;
  static const int minEventDescriptionLength = 10;
  static const int maxEventDescriptionLength = 1000;
  
  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection';
  static const String serverErrorMessage = 'Something went wrong. Please try again';
  static const String unauthorizedErrorMessage = 'Please login to continue';
}
