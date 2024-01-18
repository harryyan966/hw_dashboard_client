// ignore_for_file: require_trailing_commas

// STANDARD: ignore trailing commmas for every bloc page (but don't do that for regular pages!)

import 'package:bloc/bloc.dart';
import 'package:hw_dashboard_client/repositories/blogs.dart';
import 'package:hw_dashboard_domain/hw_dashboard_domain.dart';
import 'package:meta/meta.dart';
part 'blogs_event.dart';
part 'blogs_state.dart';

class BlogsBloc extends Bloc<BlogsEvent, BlogsState> {
  BlogsBloc({
    // inject repositories here
    required this.blogs,
  }) : super(
          // provide initial state here
          const BlogsState(),
        ) {
    // declare on clause here

    on<LoadBlogs>(_loadBlogs);
    on<SearchBlogs>(_searchBlogs);
    on<LoadBlogDetail>(_loadBlogDetail);
    on<DeleteBlog>(_deleteBlog);
    on<CreateBlog>(_createBlog);
  }

  // declare repository variables here

  final Blogs blogs;

  // declare function implementations here

  Future<void> _loadBlogs(LoadBlogs event, Emitter<BlogsState> emit) async {
    final blogsNeeded = (state.loadedBlogs.length ~/ 10 + 1) * 10;

    if (state.searchedKeyword.trim().isEmpty) {
      emit(state.copyWith(
        loadedBlogs: await blogs.search(limit: blogsNeeded),
      ));
    } else {
      emit(state.copyWith(
        loadedBlogs: await blogs.search(keyword: state.searchedKeyword, limit: blogsNeeded),
      ));
    }
  }

  Future<void> _searchBlogs(SearchBlogs event, Emitter<BlogsState> emit) async {
    emit(state.copyWith(
      searchedKeyword: event.keyword,
      loadedBlogs: await blogs.search(keyword: event.keyword, limit: 10),
    ));
  }

  Future<void> _loadBlogDetail(LoadBlogDetail event, Emitter<BlogsState> emit) async {
    emit(state.copyWith(
      lastViewedBlogDetail: await blogs.get(id: event.id),
    ));
  }

  Future<void> _deleteBlog(DeleteBlog event, Emitter<BlogsState> emit) async {
    await blogs.delete(id: event.id);
  }

  Future<void> _createBlog(CreateBlog event, Emitter<BlogsState> emit) async {
    final errors = await blogs.create(
      title: event.title,
        content: event.content,
    );

    emit(state.copyWith(createBlogErrors: errors));
  }
}
