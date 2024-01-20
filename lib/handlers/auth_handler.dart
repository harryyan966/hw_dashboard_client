// ignore_for_file: require_trailing_commas

import 'package:hw_dashboard_client/services/requester/requester.dart';
import 'package:hw_dashboard_core/hw_dashboard_core.dart';

class ClientAuthHandler implements IAuthHandler {
  ClientAuthHandler({
    required this.requester,
  });

  final Requester requester;

  @override
  Future<Account> logIn({required String username, required String password}) async {
    final account = await requester.request<Account>('/account/login', {
      'username': username,
      'password': password,
    });

    return account;
  }

  @override
  Future<void> logOut() async {
    await requester.request<void>('/account/logout');
  }
}
