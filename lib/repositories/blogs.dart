// ignore_for_file: require_trailing_commas

// IN THE REPOSITORY FILES, LOYALLY OBEY TO THE SERVER ROUTE REQUIREMENTS TO MAKE THINGS EASIER
// YOU CAN DO THINGS THAT ARE REQUIRED EVERY TIME LIKE CATCHING VALIDATION ERRORS HERE

import 'package:hw_dashboard_client/requester/requester.dart';
import 'package:hw_dashboard_domain/hw_dashboard_domain.dart';

class Blogs {
  Blogs({required Requester requester}) : _requester = requester;

  final Requester _requester;

  Future<ValidationErrors> create({required String title, required String content}) async {
    try {
      await _requester.request(path: 'blog/create', args: {
        'title': title,
        'content': content,
      });
      return ValidationErrors.empty();
    } on ValidationException catch (e) {
      return e.errors;
    }
  }

  Future<void> delete({required String id}) async {
    await _requester.request(path: 'blog/delete', args: {'id': id});
  }

  Future<Blog?> get({required String id}) async {
    final blog = await _requester.request(path: 'blog/get', args: {'id': id});
    return blog.isEmpty ? null : Blog.fromJson(blog);
  }

  Future<List<Blog>> search({String? keyword, String? title, String? content, int? limit, int? skip}) async {
    final blogs = await _requester.requestList(path: 'blog/search', args: {
      'keyword': keyword,
      'title': title,
      'content': content,
      'limit': limit,
      'skip': skip,
    });
    return blogs.map(Blog.fromJson).toList();
  }
}
