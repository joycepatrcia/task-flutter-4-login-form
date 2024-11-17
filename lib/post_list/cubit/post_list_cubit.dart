import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../model/post.dart';
import 'package:equatable/equatable.dart';

part 'post_list_state.dart';

class PostListCubit extends Cubit<PostListState> {
  PostListCubit() : super(const PostListInitial());

  // Fetch posts from the API
  Future<void> fetchPosts() async {
    emit(const PostListLoading()); // Emit loading state
    try {
      final response = await Dio().get('https://jsonplaceholder.typicode.com/posts');
      if (response.statusCode == 200) {
        final List<Post> posts = (response.data as List)
            .map((data) => Post.fromJson(data)) // Convert each post into a Post object
            .toList();
        emit(PostListSuccess(posts)); // Emit success state with the list of posts
      } else {
        emit(PostListError("Failed to load posts")); // Emit error if response is not 200
      }
    } catch (e) {
      emit(PostListError("Error: $e")); // Emit error if there's an exception
    }
  }

  // Remove data: Simply remove the item from the list
  void removeData(int index) {
    if (state is PostListSuccess) {
      final currentState = state as PostListSuccess; // Get current state
      final updatedPosts = List<Post>.from(currentState.posts); // Make a copy of the list
      updatedPosts.removeAt(index); // Remove the post from the list
      emit(PostListSuccess(updatedPosts)); // Emit new state with updated list
    }
  }
}