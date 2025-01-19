import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class OllamaService {
  // For Android Emulator use 10.0.2.2
  // For iOS Simulator use localhost
  // For physical device use your computer's IP address
  static const String _baseUrl = 'http://10.0.2.2:8000';

  static Future<String> getChatResponse(String message) async {
    try {
      // First check if server is available
      final healthCheck = await http.get(Uri.parse('$_baseUrl/health')).timeout(
          const Duration(seconds: 10)); // Increased from 5 to 10 seconds

      if (healthCheck.statusCode != 200) {
        throw Exception(
            'Server is not healthy. Please check if Ollama is running.');
      }

      // Send the chat request
      final response = await http
          .post(
        Uri.parse('$_baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'content': message}),
      )
          .timeout(
        const Duration(seconds: 120), // Increased from 30 to 120 seconds
        onTimeout: () {
          throw Exception('Request timed out. Please try again.');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['response'] != null) {
          return data['response'];
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Unknown server error');
      }
    } on SocketException catch (e) {
      throw Exception(
          'Cannot connect to server. Please check your network and server URL.');
    } on FormatException catch (e) {
      throw Exception('Invalid response format from server');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
