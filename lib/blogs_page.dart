import 'package:blog_explorer/args/detail_args.dart';
import 'package:blog_explorer/models/blogs_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key});

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogs and Articles"),
      ),
      body: _blogsHomePage(),
    );
  }

  Widget _blogsHomePage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _searchBar(),
        Expanded(
          child: _showBlogsList(),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return TextField(
      onChanged: (value) {},
      decoration: InputDecoration(
        hintText: "Search",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }

  Widget _showBlogsList() {
    final blogs = context.watch<List<BlogModel>>();
    return ListView.builder(
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: blogs[index],
          builder: (context, child) => blogCard(context),
        );
      },
    );
  }

  Widget blogCard(BuildContext context) {
    final blog = context.read<BlogModel>();
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/detail', arguments: DetailArgs(blog));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: "${blog.id}-image",
                child: _showBlogImage(blog),
              ),
              cardFooter(blog),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showBlogImage(BlogModel blog) {
    try {
      return SizedBox(
        height: 250,
        child: CachedNetworkImage(
          imageUrl: blog.imageUrl,
          progressIndicatorBuilder: (context, url, progress) {
            return Center(
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            );
          },
          errorWidget: (context, _, __) => Center(
            child: Text(
              "error loading the image",
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ),
      );
    } catch (e) {
      return SizedBox(
        height: 250,
        child: Text(
          "can't load the image",
          style: Theme.of(context).textTheme.labelSmall,
        ),
      );
    }
  }

  Widget cardFooter(BlogModel blog) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Hero(
            tag: "${blog.id}-title",
            child: Text(
              blog.title,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        Selector<BlogModel, bool>(
          selector: (_, blog) => blog.isFavorite,
          builder: (context, isFavorite, child) => IconButton(
            onPressed: () {
              blog.isFavorite = !blog.isFavorite;
            },
            // TODO add animated icon to animate it to fill version
            icon: (isFavorite)
                ? Icon(
                    Icons.favorite_rounded,
                    color: Colors.red,
                  )
                : Icon(Icons.favorite_outline_rounded),
          ),
        ),
      ],
    );
  }
}
