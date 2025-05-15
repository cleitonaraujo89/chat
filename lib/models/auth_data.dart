// ignore_for_file: constant_identifier_names

import 'dart:io';

enum AuthMode {
  LOGIN,
  SIGNUP,
}

class AuthData {
  String? name;
  String? email;
  String? password;
  File? image;
  AuthMode _mode = AuthMode.LOGIN;

  bool get isLogin {
    return _mode == AuthMode.LOGIN;
  }

   bool get isSignup {
    return _mode == AuthMode.SIGNUP;
  }

  void toggleMode() {
    //se _mode for login atribui SIGNUP caso contrario LOGIN
    _mode = _mode == AuthMode.LOGIN ? AuthMode.SIGNUP : AuthMode.LOGIN;
  }
}
