// ignore_for_file: prefer_const_constructors

import 'package:chat/models/auth_data.dart';
import 'package:chat/utils/form_validations.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key, required this.onSubmit});

  final void Function(AuthData authData) onSubmit;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final AuthData _authData = AuthData();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  _submit() {
    bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    //fecha o teclado
    FocusScope.of(context).unfocus();
    _authData.name = _nameController.text.trim();
    _authData.email = _emailController.text.trim();
    _authData.password = _passwordController.text.trim();

    widget.onSubmit(_authData);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: AnimatedSize(
                duration: Duration(milliseconds: 350),
                child: Column(
                  children: [
                    if (!_authData.isLogin)
                      TextFormField(
                        key: ValueKey('name'),
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Nome'),
                        validator: (value) =>
                            formFieldValidator(value, length: 5),
                      ),
                    TextFormField(
                      key: ValueKey('email'),
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'E-Mail'),
                      validator: (value) =>
                          formFieldValidator(value, length: 7, email: true),
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Senha'),
                      validator: (value) =>
                          formFieldValidator(value, length: 5, password: true),
                    ),
                    SizedBox(height: 12),
                    AnimatedSize(
                      duration: Duration(milliseconds: 400),
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(
                          _authData.isLogin ? 'Entrar' : 'Cadastrar',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _authData.toggleMode();
                          if (_authData.isLogin) {
                            _authData.name = '';
                            _nameController.clear();
                          }
                        });
                      },
                      child: Text(
                        _authData.isLogin
                            ? 'Criar uma nova conta?'
                            : 'Já possui uma conta?',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
