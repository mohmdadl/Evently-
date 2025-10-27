/// Base exception class
class ServerException implements Exception {
  final String message;
  
  ServerException(this.message);
  
  @override
  String toString() => message;
}

/// Cache exception
class CacheException implements Exception {
  final String message;
  
  CacheException(this.message);
  
  @override
  String toString() => message;
}

/// Network exception
class NetworkException implements Exception {
  final String message;
  
  NetworkException(this.message);
  
  @override
  String toString() => message;
}

/// Authentication exception
class AuthException implements Exception {
  final String message;
  
  AuthException(this.message);
  
  @override
  String toString() => message;
}

/// Image upload exception
class ImageUploadException implements Exception {
  final String message;
  
  ImageUploadException(this.message);
  
  @override
  String toString() => message;
}
