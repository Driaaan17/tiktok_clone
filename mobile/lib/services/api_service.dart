// lib/services/api_service.dart - FIXED VERSION
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model.dart' as category_model;
import '../models/video_model.dart';
import '../models/user_model.dart' as user_model;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  static String? _token;

  static Future<String?> getToken() async {
    if (_token != null) return _token;
    
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> removeToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  // Test connection
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: _getHeaders(includeAuth: false),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Connection error: $e');
      return false;
    }
  }

  // Get Categories
  static Future<List<category_model.Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: _getHeaders(includeAuth: false),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((x) => category_model.Category.fromJson(x)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  // Get Videos
  static Future<List<Video>> getVideos({String? category}) async {
    try {
      String url = '$baseUrl/videos';
      if (category != null && category.isNotEmpty) {
        url += '?category=$category';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: _getHeaders(includeAuth: false),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? responseData;
        return data.map((x) => Video.fromJson(x)).toList();
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      print('Error getting videos: $e');
      return [];
    }
  }

  // Upload Video
  static Future<bool> uploadVideo({
    required File videoFile,
    File? thumbnailFile,
    required String title,
    required String description,
    required String hashtags,
    required int categoryId,
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/videos'));
      
      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Add form fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['category_id'] = categoryId.toString();
      
      if (hashtags.isNotEmpty) {
        request.fields['hashtags'] = hashtags;
      }

      // Add video file
      request.files.add(
        await http.MultipartFile.fromPath(
          'video',
          videoFile.path,
        ),
      );

      // Add thumbnail file if provided
      if (thumbnailFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'thumbnail',
            thumbnailFile.path,
          ),
        );
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print('Upload failed: ${response.statusCode}');
        print('Response: $responseData');
        return false;
      }
    } catch (e) {
      print('Error uploading video: $e');
      return false;
    }
  }

  // Like Video
  static Future<Map<String, dynamic>> likeVideo(int videoId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/videos/$videoId/like'),
        headers: _getHeaders(),
      );

      final result = _handleResponse(response);
      return result;
    } catch (e) {
      print('Error liking video: $e');
      rethrow;
    }
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _getHeaders(includeAuth: false),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final result = _handleResponse(response);
    if (result['token'] != null) {
      await setToken(result['token']);
    }
    
    return result;
  }

  // Register
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: _getHeaders(includeAuth: false),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    final result = _handleResponse(response);
    if (result['token'] != null) {
      await setToken(result['token']);
    }
    
    return result;
  }

  // Get Current User
  static Future<user_model.User> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: _getHeaders(),
    );

    final result = _handleResponse(response);
    return user_model.User.fromJson(result['user']);
  }

  // Logout
  static Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: _getHeaders(),
      );
    } finally {
      await removeToken();
    }
  }

  // Helper method
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw Exception('API Error: ${body['message'] ?? 'Unknown error'}');
    }
  }
}