// ignore_for_file: require_trailing_commas, avoid_catching_errors

import 'package:dio/dio.dart';
import 'package:hw_dashboard_client/services/cacher/token_cacher.dart';
import 'package:syntax_sugar/syntax_sugar.dart';

// TODO(xiru): address cases where conventions are not followed
class Requester {
  Requester(
    String serverAddress, {
    required this.tokenCacher,
  }) : _client = Dio(BaseOptions(
          method: 'POST',
          baseUrl: serverAddress,
          // prevent the library from throwing errors before we process it
          validateStatus: (status) => true,
        ));

  final Dio _client;
  final TokenCacher tokenCacher;

  Future<T> req<T>(String path, {required Json args}) async {
    final token = await tokenCacher.getToken();
    final formData = await _processArguments(args);
    final response = await _postRequest(path, formData, token);
    await _processPotentialErrorsIn(response);
    final responseData = await _extractDataFrom<T>(response);
    return responseData;
  }

  Future<FormData> _processArguments(Json data) async {
    // process app files
    return FormData.fromMap(data);
  }

  Future<Json> _postRequest(
    String path,
    FormData formData,
    String? token,
  ) async {
    final rawResponse = await _client.post<dynamic>(path,
        data: formData, options: Options(headers: {if (token != null) 'Authorization': 'Bearer $token'}));
    try {
      return rawResponse.data as Json;
    } on TypeError {
      // the server returned a raw string, indicating special errors. These can't be processed normally by our convention-based processors, so their error messages are caught and displayed as plain string.
      return {
        'errorType': 'ServerError',
        'error': rawResponse.data,
      };
    }
  }

  Future<void> _processPotentialErrorsIn(Json response) async {
    if (response.has('errorType') || response.has('error')) {
      
    }
  }

  Future<T> _extractDataFrom<T>(Json response) async {
    return response as T;
  }
}
