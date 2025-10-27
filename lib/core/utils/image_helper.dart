import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:enevtly/core/config/app_config.dart';

/// Image helper utilities
class ImageHelper {
  static final ImagePicker _picker = ImagePicker();
  
  /// Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image == null) return null;
      
      final File file = File(image.path);
      
      // Validate file size
      if (await file.length() > AppConfig.maxImageSizeInBytes) {
        throw Exception('Image size must not exceed 5MB');
      }
      
      return file;
    } catch (e) {
      throw Exception('Failed to pick image: ${e.toString()}');
    }
  }
  
  /// Pick image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image == null) return null;
      
      final File file = File(image.path);
      
      // Validate file size
      if (await file.length() > AppConfig.maxImageSizeInBytes) {
        throw Exception('Image size must not exceed 5MB');
      }
      
      return file;
    } catch (e) {
      throw Exception('Failed to capture image: ${e.toString()}');
    }
  }
  
  /// Validate image extension
  static bool isValidImageExtension(String filename) {
    final extension = filename.split('.').last.toLowerCase();
    return AppConfig.allowedImageExtensions.contains(extension);
  }
  
  /// Get image size in MB
  static Future<double> getImageSizeInMB(File file) async {
    final bytes = await file.length();
    return bytes / (1024 * 1024);
  }
}
