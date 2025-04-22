// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nome'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-Mail'),
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Senha'),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Entrar',
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Criar uma nova conta?'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
