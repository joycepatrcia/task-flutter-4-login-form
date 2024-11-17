import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../model/post.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;
  final List<Post> posts;
  final int initialIndex;

  const PostDetailPage({
    super.key,
    required this.post,
    required this.posts,
    required this.initialIndex,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late int currentIndex;
  Post? additionalPostData;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _fetchAdditionalData(widget.post.id);
  }

  Future<void> _fetchAdditionalData(int postId) async {
    try {
      final response = await Dio().get("https://jsonplaceholder.typicode.com/posts/$postId");
      if (response.statusCode == 200) {
        setState(() {
          additionalPostData = Post.fromJson(response.data);
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  void _showDeleteConfirmation() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Are you sure you want to delete this post?"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        widget.posts.removeAt(currentIndex);
                      });
                      Navigator.pop(context);
                      Navigator.pop(context); // Close detail page
                    },
                    child: const Text("Remove", style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _nextPost() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.posts.length;
      additionalPostData = null;
      _fetchAdditionalData(widget.posts[currentIndex].id);
    });
  }

  void _previousPost() {
    setState(() {
      currentIndex = (currentIndex - 1 + widget.posts.length) % widget.posts.length;
      additionalPostData = null;
      _fetchAdditionalData(widget.posts[currentIndex].id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPost = widget.posts[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Post Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentPost.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(additionalPostData?.body ?? currentPost.body),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousPost,
                  child: const Text("Prev"),
                ),
                ElevatedButton(
                  onPressed: _nextPost,
                  child: const Text("Next"),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text("Remove Post"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: _showDeleteConfirmation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}