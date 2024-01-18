// ignore_for_file: require_trailing_commas

import 'package:hw_dashboard_client/requester/requester.dart';
import 'package:hw_dashboard_domain/hw_dashboard_domain.dart';

class Users {
  Users({required Requester requester}) : _requester = requester;

  final Requester _requester;

  // TODO(xiru): check if appfile can be converted into bytes
  Future<void> create({required String name, required Role role, AppFile? profileImage}) async {
    await _requester.request(path: 'user/create', args: {
      'name': name,
      'role': role,
      // 'profileImage': profileImage,
    });
  }

  Future<void> delete({required String id}) async {
    await _requester.request(path: 'user/delete', args: {'id': id});
  }

  Future<User?> get({required String id}) async {
    final user = await _requester.request(path: 'user/get', args: {'id': id});
    return user.isEmpty ? null : User.fromJson(user);
  }

  Future<List<User>> search({String? name, Role? role, int? limit, int? skip}) async {
    final users = await _requester.requestList(path: 'user/search', args: {
      'name': name,
      'role': role,
      'limit': limit,
      'skip': skip,
    });

    return users.map(User.fromJson).toList();
  }

  Future<void> updateName({required String id, required String name}) async {
    await _requester.request(path: 'user/update/name', args: {
      'id': id,
      'name': name,
    });
  }

  // TODO(xiru): hash passwords
  Future<void> updatePassword({required String id, required String password}) async {
    await _requester.request(path: 'user/update/password', args: {
      'id': id,
      'password': password,
    });
  }
}
