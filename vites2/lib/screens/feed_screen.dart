import 'package:flutter/material.dart';
import 'package:vites2/models/post.dart';
import 'package:vites2/screens/create_post_screen.dart';
import 'package:vites2/services/post_service.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akış'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePostScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Post>>(
        stream: _postService.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Bir hata oluştu.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Henüz hiç gönderi yok.'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return _PostCard(post: post);
            },
          );
        },
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Post post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Header
          Padding(
            padding: const EdgeInsets.all(8.0),
            // In the future, we can use the userId to fetch and display user info
            child: Text(
              'User: ${post.userId}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Post Image
          Image.network(
            post.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 300,
                color: Colors.grey[800],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          // Caption
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(post.caption),
          ),
        ],
      ),
    );
  }
}
