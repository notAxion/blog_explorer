import 'package:blog_explorer/models/blogs_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogDetail extends StatelessWidget {
  BlogDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final blog = context.read<BlogModel>();
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text(
            blog.title,
            overflow: TextOverflow.fade,
          ),
        ),
        actions: [
          _popUpMenu(context),
        ],
      ),
      body: _detailBody(context, blog),
    );
  }

  Widget _popUpMenu(BuildContext context) {
    final blog = context.watch<BlogModel>();
    return PopupMenuButton<String>(
      tooltip: "options",
      itemBuilder: (_) {
        return [
          PopupMenuItem(
            onTap: () => blog.isFavorite = !blog.isFavorite,
            child: (blog.isFavorite)
                ? const Text("Remove from Favorite")
                : const Text("Add to Favorite"),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
        ];
      },
    );
  }

  Widget _detailBody(BuildContext context, BlogModel blog) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Hero(
            tag: "${blog.id}-image",
            child: SizedBox(
              height: 250,
              child: CachedNetworkImage(imageUrl: blog.imageUrl),
            ),
          ),
          Hero(
            tag: "${blog.id}-title",
            child: Text(
              blog.title,
              textScaleFactor: 2.0,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
