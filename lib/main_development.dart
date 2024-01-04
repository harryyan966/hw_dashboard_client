import 'package:hw_dashboard_client/bootstrap.dart';

import 'package:hw_dashboard_client/presentation/app.dart';

import 'package:hw_dashboard_client/requester/cachers/in_memory.dart';

import 'package:hw_dashboard_client/requester/requester.dart';

import 'package:hw_dashboard_client/usecases/account_usecases.dart';

import 'package:hw_dashboard_client/usecases/blog_usecases.dart';

void main() {
  final requester = Requester(useHTTPS: false, baseURL: 'localhost:8080', cacher: InMemoryCacher());

  final account = Account(
    requester: requester,
    cacher: InMemoryCacher(),
  );

  final blogs = Blogs(requester: requester);

  bootstrap(
    () => App(
      account: account,
      blogs: blogs,
    ),
  );
}
