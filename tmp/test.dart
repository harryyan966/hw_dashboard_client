// ignore_for_file: require_trailing_commas

import 'package:hw_dashboard_client/services/cacher/token_cacher.dart';
import 'package:hw_dashboard_client/services/requester/requester.dart';
import 'package:hw_dashboard_core/services/id_generator/id.dart';

Future<void> main() async {
  final req = Requester('http://localhost:8080', tokenCacher: TokenCacher());
  await req.request<void>('/account/login', {'username': 'Harry', 'password': '1234567890'});
  final id =
      await req.request<Id>('/user/create', {'name': 'HarryYanX', 'role': 'student', 'password': 'password'});
  print(id);
  // await req.req<void>('/account/logout');
}
