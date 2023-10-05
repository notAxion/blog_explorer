import 'package:blog_explorer/args/detail_args.dart';
import 'package:blog_explorer/models/blogs_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Blogs extends StatelessWidget {
  const Blogs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogs and Articles"),
      ),
      body: _blogsHomePage(context),
    );
  }

  Widget _blogsHomePage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _searchBar(context),
        Expanded(
          child: _showBlogsList(context),
        ),
      ],
    );
  }

  Widget _searchBar(BuildContext context) {
    return TextField(
      onChanged: (query) {
        context.read<BlogsListModel>().filter(query: query);
      },
      decoration: InputDecoration(
        hintText: "Search",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }

  Widget _showBlogsList(BuildContext context) {
    final blogs = context.watch<BlogsListModel>();
    return ChangeNotifierProvider.value(
      value: blogs,
      child: Selector<BlogsListModel, List<BlogModel>>(
        selector: (context, blogs) => blogs.filteredBlogs,
        builder: (context, filteredBlogs, _) => ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: filteredBlogs.length,
          itemBuilder: (context, index) {
            return ChangeNotifierProvider.value(
              value: filteredBlogs[index],
              builder: (context, child) => blogCard(context),
            );
          },
        ),
      ),
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
                child: _showBlogImage(context, blog),
              ),
              cardFooter(context, blog),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showBlogImage(BuildContext context, BlogModel blog) {
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

  Widget cardFooter(BuildContext context, BlogModel blog) {
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
