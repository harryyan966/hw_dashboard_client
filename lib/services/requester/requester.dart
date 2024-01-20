// ignore_for_file: require_trailing_commas, avoid_catching_errors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hw_dashboard_client/services/cacher/token_cacher.dart';
import 'package:hw_dashboard_client/services/requester/session_expired_exception.dart';
import 'package:hw_dashboard_core/hw_dashboard_core.dart';
import 'package:syntax_sugar/syntax_sugar.dart';

// TODO(xiru): address cases where conventions are not followed
class Requester {
  Requester(
    String serverAddress, {
    required this.tokenCacher,
    this.printDebugInfo = true,
  }) : _client = Dio(BaseOptions(
          method: 'POST',
          baseUrl: serverAddress,
          // prevent the library from throwing errors before we process it
          validateStatus: (status) => true,
        ));

  final Dio _client;
  final TokenCacher tokenCacher;
  final bool printDebugInfo;

  Future<T> request<T>(String path, [Json args = const {}]) async {
    final token = await tokenCacher.getToken();
    final formData = await _processArguments(args);
    final response = await _postRequest(path, formData, token);
    await _processPotentialErrorsIn(response);
    final responseData = await _extractDataFrom<T>(response);
    return responseData;
  }

  Future<FormData> _processArguments(Json data) async {
    // process app files
    return FormData.fromMap(await _serializeAppFiles(data) as Json);
  }

  Future<Json> _postRequest(
    String path,
    FormData formData,
    String? token,
  ) async {
    final rawResponse = await _client.post<dynamic>(path,
        data: formData, options: Options(headers: {if (token != null) 'Authorization': 'Bearer $token'}));

    if (printDebugInfo) {
      print('---------');
      print('requestpath: $path');
    }

    // normal response
    if (rawResponse.statusCode == HttpStatus.ok) {
      if (printDebugInfo) print((rawResponse.data as Json).pretty());
      return rawResponse.data as Json;
    }

    // session expired
    if (rawResponse.statusCode == HttpStatus.unauthorized) {
      if (printDebugInfo) print('data: session expired...');
      throw SessionExpiredException();
    }

    // app excepion
    if (rawResponse.statusCode == HttpStatus.badRequest) {
      final error = rawResponse.data as Json;
      if (printDebugInfo) print(error.pretty());
      throw AppException('${error["errorType"]}: ${error["error"]}');
    }

    throw AppException('Unexpected Server Error: ${rawResponse.data}');
  }

  Future<void> _processPotentialErrorsIn(Json response) async {}

  Future<T> _extractDataFrom<T>(Json response) async {
    final type = response['responseType'] as String;
    final data = response['response'];
    try {
      // account data always contain an auth token
      if (type == 'Account') {
        final accountData = data as Json;
        await tokenCacher.cache(accountData.get('authToken'));
        return Account.fromJson(accountData) as T;
      }
      if (type == 'String') {
        return data as T;
      }
      if (type == 'Id') {
        return Id(data as String) as T;
      }
      if (type == 'Null') {
        return null as T;
      }
      if (type == 'Map<String, dynamic>') {
        return (data as Json) as T;
      }
      if (type.startsWith('Map')) {
        return (data as Map) as T;
      }
      if (type == 'Uri') {
        // TODO(xiru): save file and return appfile or simply return uri
      }
      if (type == 'List<Uri>') {
        // TODO(xiru): save file and return appfile or simply return uri
      }
      if (type.startsWith('List')) {
        return (data as Iterable).map((e) => e as Json).toList() as T;
      }
      return data as T;
    } on TypeError catch (e) {
      print('TYPEERROR: $e');
      throw AppException(
        'TypeException: while you requested for a $T, the server responded with a $type, which is incompatible.',
      );
    }
  }

  Future<dynamic> _serializeAppFiles(dynamic element) async {
    // recursively find appfiles in data structures and turn them into multipart files

    if (element is List) {
      for (var i = 0; i < element.length; i++) {
        element[i] = await _serializeAppFiles(element);
      }
      return element;
    } else if (element is Map) {
      for (final entry in element.entries) {
        element[entry.key] = await _serializeAppFiles(entry.value);
      }
      return element;
    } else if (element is AppFile) {
      return MultipartFile.fromBytes(element.byteContent);
    }
    return element;
  }
}
