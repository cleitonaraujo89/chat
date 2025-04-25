String? validator(String? value, {int? length, bool? email, bool? password}) {
  final String? valueTrim = value?.trim();
  final RegExp emailRegexp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp passwordRegexp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$');

  if (valueTrim == null || valueTrim.isEmpty) {
    return 'Campo vazio';
  }

  if (length != null && length < valueTrim.length) {
    return 'Mínimo de $length caractéres';
  }

  if ((email ?? false) && !emailRegexp.hasMatch(valueTrim)) {
    return 'E-mail inválido';
  }

  if ((password ?? false) && !passwordRegexp.hasMatch(valueTrim)) {
    return 'A senha deve conter ao menos uma letra e um número';
  }

  return null;
}
