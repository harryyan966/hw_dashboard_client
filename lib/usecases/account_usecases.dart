import 'dart:convert';

import 'package:hw_dashboard_client/requester/cachers/cacher.dart';
import 'package:hw_dashboard_client/requester/requester.dart';
import 'package:hw_dashboard_domain/hw_dashboard_domain.dart';
import 'package:syntax_sugar/syntax_sugar.dart';

class Account {
  Account({
    required Requester requester,
    required Cacher cacher,
  })  : _cacher = cacher,
        _requester = requester;

  final Requester _requester;
  final Cacher _cacher;

  static const _currentUserKey = '__currentUser__';

  Future<Map<String, String>?> login({required String username, required String password}) async {
    try {
      await _requester.request(
        path: 'account/login',
        args: {
          'username': username,
          'password': password,
        },
      );
      return null;
    } on ValidationException catch (e) {
      print('CAUGHT !!!!!!!!!');
      return e.errors.asMap;
    }
  }

  Future<User?> currentOrNull() async {
    final currentUserRaw = await _cacher.getCache(_currentUserKey);

    final currentUser = currentUserRaw == null
        ? User.fromJson(await _requester.request(path: 'account/current'))
        : User.fromJson(jsonDecode(currentUserRaw) as Json);

    if (currentUserRaw == null) {
      await _cacher.setCache(_currentUserKey, jsonEncode(currentUser));
    }

    return currentUser;
  }

  Future<User> current() async {
    final user = await currentOrNull();
    if (user == null) {
      throw const AppException.authorization('You are not logged in.');
    }
    return user;
  }

  Future<void> logout() async {
    await _requester.request(path: 'account/logout');
    await _cacher.removeCache(_currentUserKey);
  }
}
