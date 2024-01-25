class ApiEndPoints {
  static const String baseUrl = 'https://tanya-app-production.up.railway.app/api/';
  // static const String baseUrl = 'http://127.0.0.1:8091/api/';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String register = 'users';
  final String login = 'auth/user';
  final String logout = 'auth/logout';
  final String lazy_load= 'beranda';
  final String getUser = 'user/current';
  final String pertanyaan = 'pertanyaan';
  final String komentar = 'komentar';
}