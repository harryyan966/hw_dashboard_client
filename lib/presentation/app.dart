import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hw_dashboard_client/presentation/view/app_view.dart';

import 'package:hw_dashboard_client/usecases/account_usecases.dart';

import 'package:hw_dashboard_client/usecases/blog_usecases.dart';

class App extends StatelessWidget {
  const App({
    required this.account,
    required this.blogs,
    super.key,
  });

  final Account account;
  final Blogs blogs;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => account),
        RepositoryProvider(create: (_) => blogs),
      ],
      child: const AppView(),
    );
  }
}
