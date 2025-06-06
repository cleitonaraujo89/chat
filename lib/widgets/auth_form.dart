// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:chat/models/auth_data.dart';
import 'package:chat/utils/form_validations.dart';
import 'package:chat/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.onSubmit,
    this.isLockedOut = false,
    this.lockoutSeconds = 0,
  });

  final void Function(AuthData authData) onSubmit;
  final bool isLockedOut;
  final int lockoutSeconds;

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
    if (widget.isLockedOut) return;
    bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    if (_authData.image == null && _authData.isSignup) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor adcione a Imagem.')),
      );
      return;
    }

    //fecha o teclado
    FocusScope.of(context).unfocus();
    _authData.name = _nameController.text.trim();
    _authData.email = _emailController.text.trim();
    _authData.password = _passwordController.text.trim();

    widget.onSubmit(_authData);
  }

  void _handlePickedImage(File image) {
    _authData.image = image;
  }

  String get _formattedTimer {
    final minutes = (widget.lockoutSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (widget.lockoutSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
              autovalidateMode: AutovalidateMode.onUnfocus,
              child: AnimatedSize(
                duration: Duration(milliseconds: 350),
                child: Column(
                  children: [
                    if (_authData.isSignup)
                      UserImagePicker(onImagePick: _handlePickedImage),
                    if (_authData.isSignup)
                      TextFormField(
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: true,
                        key: ValueKey('name'),
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Nome'),
                        validator: (value) =>
                            formFieldValidator(value, length: 5),
                      ),
                    TextFormField(
                      key: ValueKey('email'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: true,
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
                        onPressed: widget.isLockedOut ? null : _submit,
                        child: widget.isLockedOut
                            ? Text('Tente novamente em $_formattedTimer')
                            : Text(
                                _authData.isLogin ? 'Entrar' : 'Cadastrar',
                              ),
                      ),
                    ),
                    TextButton(
                      onPressed: widget.isLockedOut
                          ? null
                          : () {
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
