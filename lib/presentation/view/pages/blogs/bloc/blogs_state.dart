part of 'blogs_bloc.dart';

@immutable
final class BlogsState {
  const BlogsState({
    this.loadedBlogs = const [],
    this.searchedKeyword = '',
    this.lastViewedBlogDetail,
    this.createBlogErrors,
  });

  final List<Blog> loadedBlogs;
  final String searchedKeyword;
  final Blog? lastViewedBlogDetail;
  final ValidationErrors? createBlogErrors;

  BlogsState copyWith({
    List<Blog>? loadedBlogs,
    String? searchedKeyword,
    Blog? lastViewedBlogDetail,
    ValidationErrors? createBlogErrors,
  }) {
    return BlogsState(
      loadedBlogs: loadedBlogs ?? this.loadedBlogs,
      searchedKeyword: searchedKeyword ?? this.searchedKeyword,
      lastViewedBlogDetail: lastViewedBlogDetail ?? this.lastViewedBlogDetail,
      createBlogErrors: createBlogErrors ?? this.createBlogErrors,
    );
  }
}
