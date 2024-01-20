// ignore_for_file: require_trailing_commas

import 'dart:convert';

import 'package:hw_dashboard_domain/hw_dashboard_domain.dart';
import 'package:syntax_sugar/syntax_sugar.dart';

class Account {
  Account({
    
  })  : _cacher = cacher,
        _requester = requester;

  final Requester _requester;
  final Cacher _cacher;

  static const _currentUserKey = '__currentUser__';

  Future<ValidationErrors> login({required String username, required String password}) async {
    try {
      await _requester.request(path: 'account/login', args: {
        'username': username,
        'password': password,
      });
      return ValidationErrors.empty();
    } on ValidationException catch (e) {
      print('CAUGHT !!!!!!!!!');
      return e.errors;
    }
  }

  Future<User?> currentOrNull() async {
    final currentUserRaw = await _cacher.getCache(_currentUserKey);

    final currentUser = currentUserRaw == null
        ? User.fromJson(await _requester.request(path: 'account/current'))
        : User.fromJson(jsonDecode(currentUserRaw) as Json);

    // the user didn't exist
    // TODO(xiru): set time limit of cache?
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
