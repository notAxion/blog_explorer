import 'package:blog_explorer/args/detail_args.dart';
import 'package:blog_explorer/blog_detail.dart';
import 'package:blog_explorer/blogs_page.dart';
import 'package:blog_explorer/models/blogs_model.dart';
import 'package:blog_explorer/res/blogs_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog Explorer',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      onGenerateRoute: routes,
    );
  }
}

Route routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) {
        return FutureProvider<BlogsListModel>(
          create: (context) async {
            final blogs = await fetchBlogs();
            return BlogsListModel(blogs: blogs);
          },
          catchError: (context, error) {
            return BlogsListModel(blogs: [], errorStr: error.toString());
          },
          initialData: BlogsListModel(blogs: []),
          child: Blogs(),
        );
      });
    case '/detail':
      return MaterialPageRoute(builder: (context) {
        final args = settings.arguments as DetailArgs;
        return ChangeNotifierProvider.value(
          value: args.blog,
          builder: (context, _) {
            return BlogDetail();
          },
        );
      });
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text(
              "looks like you wondered off to somewhere unknown",
              textScaleFactor: 3,
            ),
          ),
        ),
      );
  }
}
