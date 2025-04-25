// ignore_for_file: constant_identifier_names

enum AuthMode {
  LOGIN,
  SIGNUP,
}

class AuthData {
  String? name;
  String? email;
  String? password;
  AuthMode _mode = AuthMode.LOGIN;

  bool get isLogin {
    return _mode == AuthMode.LOGIN;
  }

  void toggleMode() {
    //se _mode for login atribui SIGNUP caso contrario LOGIN
    _mode = _mode == AuthMode.LOGIN ? AuthMode.SIGNUP : AuthMode.LOGIN;
  }
}
