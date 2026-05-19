class Validators {

  static String? validateEmail(String email) {

    if (email.isEmpty) {
      return 'El correo es obligatorio';
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Correo inválido';
    }

    return null;
  }

  static String? validatePassword(String password) {

    if (password.isEmpty) {
      return 'La contraseña es obligatoria';
    }

    if (password.length < 8) {
      return 'Mínimo 8 caracteres';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Debe contener mayúsculas';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Debe contener minúsculas';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Debe contener números';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
        .hasMatch(password)) {
      return 'Debe contener símbolos';
    }

    return null;
  }

  static String? validateRequired(
    String value,
    String fieldName,
  ) {

    if (value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }

    return null;
  }
}