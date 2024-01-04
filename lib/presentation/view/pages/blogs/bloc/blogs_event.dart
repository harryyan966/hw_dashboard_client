part of 'blogs_bloc.dart';

@immutable
sealed class BlogsEvent {}

final class LoadBlogs extends BlogsEvent {
  LoadBlogs();
}

final class SearchBlogs extends BlogsEvent {
  SearchBlogs({required this.keyword});

  final String keyword;
}

final class CreateBlog extends BlogsEvent {
  CreateBlog({required this.title, required this.content});

  final String title;
  final String content;
}

final class DeleteBlog extends BlogsEvent {
  DeleteBlog({required this.id});

  final String id;
}
