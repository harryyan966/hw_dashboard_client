import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hw_dashboard_client/requester/cachers/cacher.dart';
import 'package:hw_dashboard_domain/hw_dashboard_domain.dart';
import 'package:syntax_sugar/syntax_sugar.dart';

class Requester {
  Requester({
    required bool useHTTPS,
    required String baseURL,
    required Cacher cacher,
    bool debug = false,
  })  : _cacher = cacher,
        _baseURL = baseURL,
        _useHTTPS = useHTTPS,
        _client = Dio(
          BaseOptions(
            method: 'POST',
            validateStatus: (status) => true,
          ),
        ),
        _debug = debug;

  final bool _useHTTPS;
  final String _baseURL;
  final Cacher _cacher;
  final Dio _client;

  final bool _debug;

  static const _tokenKey = '__authToken__';

  Future<String?> token() => _cacher.getCache(_tokenKey);

  Future<Json> request({required String path, Json args = const {}}) async {
    final token = await _cacher.getCache(_tokenKey);
    final raw = await _postRequest(path, args, token);
    final json = _decodeResponse(raw);
    if (_debug) {
      print(path);
      print(json.pretty());
      print('-' * 30);
    }
    _checkErrorIn(json);
    if (json.has(_tokenKey)) {
      await _cacher.setCache(_tokenKey, json.get(_tokenKey));
    }
    return json;
  }

  Future<List<Json>> requestList({required String path, Json args = const {}}) async {
    final response = await request(path: path, args: args);
    return response.get<Iterable<dynamic>>('__list__').map((e) => e as Json).toList();
  }

  Future<Response<Json>> _postRequest(String path, Json args, String? token) async {
    try {
      // post request
      final raw = await _client.postUri<String>(
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
        _useHTTPS ? Uri.https(_baseURL, path) : Uri.http(_baseURL, path),
        data: FormData.fromMap(await _normalizeAppFiles(args)),
      );
      // find errors
      try {
        final data = jsonDecode(raw.data!) as Json;
        // error is in data as json
        if (data.has('error')) {
          return Response<Json>(
            requestOptions: raw.requestOptions,
            data: {'errorType': raw.statusMessage, ...data},
          );
        }
        // there is no error
        return Response<Json>(
          requestOptions: raw.requestOptions,
          data: jsonDecode(raw.data!) as Json,
        );
      } on FormatException {
        // has string return, usually not from our api and are errors
        return Response<Json>(
          requestOptions: raw.requestOptions,
          data: {
            'errorType': raw.statusMessage,
            'error': raw.data,
          },
        );
      }
    } catch (e) {
      // network errors
      throw Exception('Exception occurred when posting request: $e');
    }
  }

  Future<dynamic> _normalizeAppFile(dynamic element) async {
    // recursively find appfiles in json and turn it into bytes

    if (element is List) {
      for (var i = 0; i < element.length; i++) {
        element[i] = await _normalizeAppFile(element);
      }
      return element;
    } else if (element is Map) {
      for (final entry in element.entries) {
        element[entry.key] = await _normalizeAppFile(entry.value);
      }
      return element;
    } else if (element is AppFile) {
      return MultipartFile.fromBytes(File(await element.getSavedPath()).readAsBytesSync());
    }
    return element;
  }

  Future<Json> _normalizeAppFiles(Json args) async {
    for (final entry in args.entries) {
      args[entry.key] = await _normalizeAppFile(entry.value);
    }
    return args;
  }

  Json _decodeResponse(Response<Json> response) => response.data!;

  void _checkErrorIn(Json response) {
    if (response.has('errorType')) {
      try {
        final errorType = response.get<String>('errorType');

        if (errorType == 'validation') {
          throw ValidationException.fromString(response.get('error'));
        }
        throw AppException(
          response.get('error'),
          switch (errorType) {
            'Not Found' => ExceptionType.notFound,
            'Forbidden' => ExceptionType.forbidden,
            'Unauthorized' => ExceptionType.authorization,
            _ => ExceptionType.values.byName(errorType),
          },
        );
        // ignore: avoid_catching_errors
      } on ArgumentError {
        throw Exception('undocumented exception from server: ${response.get<String>('error')}');
      }
    }
  }
}
