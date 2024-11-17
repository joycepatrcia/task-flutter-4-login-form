import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/post_list_cubit.dart';
import '../model/post.dart';
import 'post_detail_page.dart';

class PostListView extends StatelessWidget {
  const PostListView({super.key});

  // Fungsi untuk menampilkan konfirmasi sebelum menghapus post
  void confirmAndDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(
              onPressed: () {
                // Hapus post dari tampilan setelah konfirmasi
                context.read<PostListCubit>().removeData(index);
                Navigator.pop(dialogContext); // Tutup dialog setelah konfirmasi
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Tutup dialog tanpa menghapus
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Posts List")),
      body: BlocBuilder<PostListCubit, PostListState>(
        builder: (context, state) {
          if (state is PostListSuccess) {
            // Menampilkan daftar post dengan spasi antar post
            return ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.posts.length,
              separatorBuilder: (context, index) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      post.body.length > 55 ? "${post.body.substring(0, 55)}..." : post.body,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => confirmAndDelete(context, index), // Panggil fungsi konfirmasi penghapusan
                    ),
                    onTap: () {
                      // Navigasi ke halaman detail post
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailPage(
                            post: post,
                            posts: state.posts,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is PostListError) {
            // Menampilkan error jika gagal memuat data
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage),
                  ElevatedButton(
                    onPressed: () => context.read<PostListCubit>().fetchPosts(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (state is PostListLoading) {
            // Menampilkan loading spinner saat data sedang dimuat
            return const Center(child: CircularProgressIndicator());
          } else {
            // Menampilkan tombol untuk memuat data jika belum ada data
            return Center(
              child: ElevatedButton(
                onPressed: () => context.read<PostListCubit>().fetchPosts(),
                child: const Text("Load Posts"),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<PostListCubit>().fetchPosts(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}