import 'package:blog_explorer/args/detail_args.dart';
import 'package:blog_explorer/models/blogs_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Blogs extends StatelessWidget {
  const Blogs({super.key});

  @override
  Widget build(BuildContext context) {
    final blogs = context.watch<BlogsListModel>();
    if (blogs.errorStr != null) {
      return Scaffold(body: onErrorWidget(context, blogs));
    }
    if (blogs.filteredBlogs.isEmpty) {
      return const Center(
        child: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return ChangeNotifierProvider.value(
      value: blogs,
      child: _blogsHomePage(context),
    );
  }

  Widget _blogsHomePage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogs and Articles"),
        actions: [
          _showPopUpMenu(context),
        ],
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: _searchBar(context),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          constraints: BoxConstraints.loose(const Size.fromWidth(480)),
          child: _showBlogsList(context),
        ),
      ),
    );
  }

  Widget _showPopUpMenu(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: "options",
      itemBuilder: (_) {
        final onlyshowFavs = context.read<BlogsListModel>().onlyShowFavs;
        return [
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            onTap: () => context
                .read<BlogsListModel>()
                .filter(query: "", showFavorites: !onlyshowFavs),
            child: (!onlyshowFavs)
                ? Text("Favorite Blogs")
                : Text("Show All Blogs"),
          ),
        ];
      },
    );
  }

  Widget _searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: TextField(
        onChanged: (query) {
          context.read<BlogsListModel>().filter(query: query);
        },
        decoration: InputDecoration(
          isDense: true,
          hintText: "Search",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }

  Widget _showBlogsList(BuildContext context) {
    return Selector<BlogsListModel, List<BlogModel>>(
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
          borderRadius: BorderRadius.circular(25),
        ),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(top: 10.0),
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
        height: 220,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.0),
          child: CachedNetworkImage(
            imageUrl: blog.imageUrl,
            fit: BoxFit.cover,
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Hero(
              tag: "${blog.id}-title",
              child: Text(
                blog.title,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
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
                    // size: 30,
                  )
                : Icon(
                    Icons.favorite_outline_rounded,
                    size: 30,
                  ),
          ),
        ),
      ],
    );
  }

  Widget onErrorWidget(BuildContext context, BlogsListModel blogs) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 36,
          ),
          Text(
            blogs.errorStr!,
            maxLines: 7,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
