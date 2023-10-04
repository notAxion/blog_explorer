import 'package:blog_explorer/models/blogs_model.dart';
import 'package:blog_explorer/res/blogs_api.dart';
import 'package:flutter/material.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key});

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  var blogs = <BlogModel>[];

  @override
  void initState() {
    fetchBlogs().then((blogsList) {
      setState(() {
        blogs = blogsList;
      });
    }).onError((error, stacktrace) {
      // TODO handle error gracefully
      debugPrint(error.toString());
    });
    super.initState();
  }

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
    return ListView.builder(
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        return blogCard(blogs[index]);
      },
    );
  }

  Widget blogCard(BlogModel blog) {
    return Card(
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
            SizedBox(
              height: 250,
              child: Image.network(blog.imageUrl),
            ),
            cardFooter(blog),
          ],
        ),
      ),
    );
  }

  Widget cardFooter(BlogModel blog) {
    return Row(
      children: [
        Flexible(
          child: Text(
            blog.title,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: () {},
          // TODO add animated icon to animate it to fill version
          icon: Icon(Icons.favorite_outline_rounded),
        ),
      ],
    );
  }
}
