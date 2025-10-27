import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:enevtly/core/config/app_config.dart';
import 'package:enevtly/core/error/exceptions.dart';

/// Service for uploading images to ImgBB
class ImageUploadService {
  final http.Client client;
  
  ImageUploadService({required this.client});
  
  /// Upload image to ImgBB and return the image URL
  Future<String> uploadImage(File imageFile) async {
    try {
      // Read image as bytes
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // Create multipart request
      final uri = Uri.parse(
        '${AppConfig.imgbbUploadUrl}?key=${AppConfig.imgbbApiKey}'
      );
      
      final response = await client.post(
        uri,
        body: {
          'image': base64Image,
        },
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true) {
          // Return the display URL
          return jsonResponse['data']['display_url'] as String;
        } else {
          throw ImageUploadException('Image upload failed');
        }
      } else {
        throw ImageUploadException(
          'Failed to upload image. Status: ${response.statusCode}'
        );
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is ImageUploadException || e is NetworkException) {
        rethrow;
      }
      throw ImageUploadException('Failed to upload image: ${e.toString()}');
    }
  }
  
  /// Upload multiple images
  Future<List<String>> uploadMultipleImages(List<File> imageFiles) async {
    final List<String> imageUrls = [];
    
    for (final imageFile in imageFiles) {
      final url = await uploadImage(imageFile);
      imageUrls.add(url);
    }
    
    return imageUrls;
  }
}
