import 'package:flutter/material.dart';

bool handleAuthError(BuildContext context, String error) {
  // Mapa que associa o código de erro a uma mensagem
  final errorMessages = {
    'invalid-email': 'O e-mail fornecido não é válido.',
    'user-disabled': 'A conta foi desativada.',
    'user-not-found': 'Não encontramos uma conta com esse e-mail.',
    'invalid-credential': 'Email ou Senha incorretos',
    'wrong-password': 'Senha incorreta.',
    'email-already-in-use': 'Este e-mail já está em uso.',
    'weak-password': 'A senha deve ter no mínimo 6 caracteres.',
    'operation-not-allowed': 'A operação não é permitida.',
    'too-many-requests':
        'Número de Tentativas exedido, login temporariamente desativado',
    'undefined': 'Ocorreu um erro inesperado.',
  };

  String errorMessage =
      errorMessages[error] ?? 'Ocorreu um erro inesperado. Tente novamente.';

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMessage),
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: const Duration(seconds: 3),
    ),
  );

  if (error == 'too-many-requests') {
    return true;
  } else {
    return false;
  }
}
