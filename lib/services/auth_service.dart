class AuthService {
  static final AuthService instance = AuthService._init();
  AuthService._init();

  final Map<String, String> _users = {"admin": "1234"};

  bool login(String username, String password) {
    return _users.containsKey(username) && _users[username] == password;
  }

  bool register(String username, String password) {
    if (_users.containsKey(username)) {
      return false;
    }
    _users[username] = password;
    return true;
  }
}
