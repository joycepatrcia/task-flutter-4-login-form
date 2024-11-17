part of "post_list_cubit.dart";

abstract class PostListState extends Equatable {
  const PostListState();

  const factory PostListState.initial() = PostListInitial;
  const factory PostListState.loading() = PostListLoading;
  const factory PostListState.success(List<Post> posts) = PostListSuccess;
  const factory PostListState.error(String errorMessage) = PostListError;

  @override
  List<Object?> get props => [];
}

class PostListInitial extends PostListState {
  const PostListInitial();
}

class PostListLoading extends PostListState {
  const PostListLoading();
}

class PostListSuccess extends PostListState {
  final List<Post> posts;

  const PostListSuccess(this.posts);
}

class PostListError extends PostListState {
  final String errorMessage;

  const PostListError(this.errorMessage);
}