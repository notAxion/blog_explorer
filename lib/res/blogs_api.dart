import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void fetchBlogs() async {
  final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
  final String adminSecret = dotenv.env['ADMIN_SECRET'] ?? "";

  try {
    final response = await http.get(Uri.parse(url), headers: {
      'x-hasura-admin-secret': adminSecret,
    });

    if (response.statusCode == 200) {
      // Request successful, handle the response data here
      print('Response data: ${response.body}');
    } else {
      // Request failed
      print('Request failed with status code: ${response.statusCode}');
      print('Response data: ${response.body}');
    }
  } catch (e) {
    // Handle any errors that occurred during the request
    print('Error: $e');
  }
}
