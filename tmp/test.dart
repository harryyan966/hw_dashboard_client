// ignore_for_file: require_trailing_commas

import 'package:hw_dashboard_client/services/cacher/token_cacher.dart';
import 'package:hw_dashboard_client/services/requester/requester.dart';

Future<void> main() async {
  final req = Requester('http://localhost:8080', tokenCacher: TokenCacher());
  final res = await req.req<dynamic>('/account/lgin', args: {'username': 'Harry', 'password': '1234567890'});
  print(res);
}
