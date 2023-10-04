import 'package:flutter/material.dart';

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
    return ListView.builder(
      itemCount: 60,
      itemBuilder: (context, index) {
        return Text("$index blog");
      },
    );
  }
}
