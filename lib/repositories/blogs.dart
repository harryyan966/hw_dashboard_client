import 'package:hw_dashboard_client/requester/requester.dart';
import 'package:hw_dashboard_domain/hw_dashboard_domain.dart';

class Blogs {
  Blogs({
    required Requester requester,
  }) : _requester = requester;

  final Requester _requester;

  Future<List<Blog>> getBlogs({required int count}) async {
    final blogs = await _requester.requestList(
      path: 'blog/search',
      args: {
        'limit': count,
      },
    );
    return blogs.map(Blog.fromJson).toList();
  }

  Future<List<Blog>> searchBlogs({required String keyword, required int count}) async {
    final blogs = await _requester.requestList(
      path: 'blog/search',
      args: {
        'keyword': keyword,
        'limit': count,
      },
    );
    return blogs.map(Blog.fromJson).toList();
  }

  Future<Blog> getBlogDetail({required String id}) async {
    final blog = await _requester.request(
      path: 'blog/get',
      args: {
        'id': id,
      },
    );
    return Blog.fromJson(blog);
  }

  Future<ValidationErrors> createBlog({required Blog blog}) async {
    try {
      await _requester.request(path: 'blog/create', args: blog.toJson());
      return ValidationErrors.empty();
    } on ValidationException catch (e) {
      return e.errors;
    }
  }

  Future<void> deleteBlog({required String id}) async {
    await _requester.request(path: 'blog/delete', args: {'id': id});
  }
}
