/// App Configuration
/// Contains all configuration constants for the app
class AppConfig {
  // ImgBB Configuration
  static const String imgbbApiKey = '5708d1b89a823acd41e8913fa44f24cc';
  static const String imgbbUploadUrl = 'https://api.imgbb.com/1/upload';
  
  // App Configuration
  static const String appName = 'Evently';
  static const String appVersion = '1.0.0';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String eventsCollection = 'events';
  
  // Pagination
  static const int eventsPerPage = 10;
  
  // Image Settings
  static const int maxImageSizeInBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
}
