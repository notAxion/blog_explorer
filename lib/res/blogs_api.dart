import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<List<BlogList>> fetchBlogs() async {
  final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
  final String adminSecret = dotenv.env['ADMIN_SECRET'] ?? "";

  try {
    final response = await http.get(Uri.parse(url), headers: {
      'x-hasura-admin-secret': adminSecret,
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final blogsObject = BlogsListModel.fromJson(jsonData);

      return blogsObject.blogs;
    } else {
      // Request failed
      print('Response data: ${response.body}');
      return Future.error('Request failed with status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors that occurred during the request
    print('Error: $e');
  }
}
