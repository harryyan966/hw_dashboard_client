// ignore_for_file: require_trailing_commas

import 'package:hw_dashboard_client/bootstrap.dart';
import 'package:hw_dashboard_client/presentation/app.dart';
import 'package:hw_dashboard_client/repositories/account.dart';
import 'package:hw_dashboard_client/repositories/blogs.dart';
import 'package:hw_dashboard_client/requester/cachers/in_memory.dart';
import 'package:hw_dashboard_client/requester/requester.dart';

void main() {
  final requester = Requester(useHTTPS: false, baseURL: 'localhost:8080', cacher: InMemoryCacher());

  final account = Account(requester: requester, cacher: InMemoryCacher());

  final blogs = Blogs(requester: requester);

  bootstrap(() => App(
        account: account,
        blogs: blogs,
      ));
}
