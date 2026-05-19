import 'package:flutter/material.dart';

class PasswordStrengthWidget extends StatelessWidget {
  final String password;

  const PasswordStrengthWidget({
    super.key,
    required this.password,
  });

  int calculateStrength() {

    int strength = 0;

    if (password.length >= 8) {
      strength++;
    }

    if (RegExp(r'[A-Z]').hasMatch(password)) {
      strength++;
    }

    if (RegExp(r'[a-z]').hasMatch(password)) {
      strength++;
    }

    if (RegExp(r'[0-9]').hasMatch(password)) {
      strength++;
    }

    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]')
        .hasMatch(password)) {
      strength++;
    }

    return strength;
  }

  @override
  Widget build(BuildContext context) {

    final strength = calculateStrength();

    String text = '';
    Color color = Colors.red;

    if (strength <= 2) {
      text = 'Débil';
      color = Colors.red;
    }
    else if (strength <= 4) {
      text = 'Media';
      color = Colors.orange;
    }
    else {
      text = 'Fuerte';
      color = Colors.green;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 10),

        LinearProgressIndicator(
          value: strength / 5,
          minHeight: 8,
          color: color,
          backgroundColor: Colors.grey.shade300,
        ),

        const SizedBox(height: 8),

        Text(
          'Seguridad: $text',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}