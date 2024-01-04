// ignore_for_file: require_trailing_commas

// STANDARD: ignore trailing commmas for every bloc page (but don't do that for regular pages!)

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hw_dashboard_client/usecases/account_usecases.dart';
import 'package:hw_dashboard_client/usecases/blog_usecases.dart';
import 'package:hw_dashboard_domain/hw_dashboard_domain.dart';
import 'package:meta/meta.dart';
part 'blogs_event.dart';
part 'blogs_state.dart';

class BlogsBloc extends Bloc<BlogsEvent, BlogsState> {
  BlogsBloc({
    // inject repositories here
    required this.account,
    required this.blogs,
  }) : super(
          // provide initial state here
          const BlogsState(),
        ) {
    // declare on clause here

    on<LoadBlogs>(_loadBlogs);
    on<SearchBlogs>(_searchBlogs);
    on<DeleteBlog>(_deleteBlog);
    on<CreateBlog>(_createBlog);
  }

  // declare repository variables here
  final Account account;
  final Blogs blogs;

  // declare function implementations here

  FutureOr<void> _loadBlogs(LoadBlogs event, Emitter<BlogsState> emit) async {
    final blogsNeeded = (state.loadedBlogs.length ~/ 10 + 1) * 10;

    if (state.searchedKeyword.trim().isEmpty) {
      emit(state.copyWith(
        loadedBlogs: await blogs.getBlogs(count: blogsNeeded),
      ));
    } else {
      emit(state.copyWith(
        loadedBlogs: await blogs.searchBlogs(keyword: state.searchedKeyword, count: blogsNeeded),
      ));
    }
  }

  FutureOr<void> _searchBlogs(SearchBlogs event, Emitter<BlogsState> emit) async {
    emit(state.copyWith(
      searchedKeyword: event.keyword,
      loadedBlogs: await blogs.searchBlogs(keyword: event.keyword, count: 10),
    ));
  }

  FutureOr<void> _deleteBlog(DeleteBlog event, Emitter<BlogsState> emit) async {
    await blogs.deleteBlog(id: event.id);
  }

  FutureOr<void> _createBlog(CreateBlog event, Emitter<BlogsState> emit) async {
    final user = await account.current();

    final errors = await blogs.createBlog(
      blog: Blog(
        title: event.title,
        content: event.content,
        author: user.id!,
      ),
    );

    emit(state.copyWith(createBlogErrors: errors));
  }
}
