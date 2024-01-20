class TokenCacher {
  String? _token;

  Future<void> cache(String token) async {
    _token = token;
  }

  Future<String?> getToken() async {
    return _token;
  }
}
