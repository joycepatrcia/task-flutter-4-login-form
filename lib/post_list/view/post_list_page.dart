import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/post_list_cubit.dart';
import 'post_list_view.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostListCubit()..fetchPosts(),
      child: const PostListView(),
    );
  }
}