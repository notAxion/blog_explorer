import 'dart:convert';

import 'package:blog_explorer/models/blogs_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<List<BlogModel>> fetchBlogs() async {
  try {
    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    final String adminSecret = dotenv.env['ADMIN_SECRET'] ?? "";

    final response = await http.get(Uri.parse(url), headers: {
      'x-hasura-admin-secret': adminSecret,
    });

    if (response.statusCode != 200) {
      // Request failed
      return Future.error(
          'Request failed with status code: ${response.statusCode} with Response data: ${response.body}');
    }
    final jsonData = json.decode(response.body);
    final blogsObject = BlogsListModel.fromJson(jsonData);

    return blogsObject.blogs;
  } catch (e) {
    // Handle any errors that occurred during the request
    return Future.error(e);
  }
}
