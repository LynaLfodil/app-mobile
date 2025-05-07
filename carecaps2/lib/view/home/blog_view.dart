import 'package:flutter/material.dart';

class BlogView extends StatelessWidget {
  const BlogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('blog'),
      ),
      body: const Center(
        child: Text('blog Page'),
      ),
    );
  }
}