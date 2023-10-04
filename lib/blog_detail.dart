import 'package:blog_explorer/models/blogs_model.dart';
import 'package:flutter/material.dart';

class BlogDetail extends StatefulWidget {
  final BlogModel blog;
  BlogDetail({super.key, required this.blog});

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  BlogModel get blog => widget.blog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text(
            blog.title,
            overflow: TextOverflow.fade,
          ),
        ),
      ),
      body: _detailBody(),
    );
  }

  Widget _detailBody() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: Image.network(blog.imageUrl),
          ),
          Text(
            blog.title,
            textScaleFactor: 2.0,
          ),
        ],
      ),
    );
  }
}
