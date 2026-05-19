import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/admin_totp_service.dart';

class AdminTotpVerifyScreen
    extends StatefulWidget {
  final String secret;

  const AdminTotpVerifyScreen({
    super.key,
    required this.secret,
  });

  @override
  State<AdminTotpVerifyScreen>
      createState() =>
          _AdminTotpVerifyScreenState();
}

class _AdminTotpVerifyScreenState
    extends State<
        AdminTotpVerifyScreen> {
  final codeController =
      TextEditingController();

  final service =
      AdminTotpService();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  void verify() {
    final valid =
        service.verifyCode(
      secret: widget.secret,
      code:
          codeController.text
              .trim(),
    );

    if (!valid) {
      ScaffoldMessenger.of(
              context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Código inválido',
          ),
        ),
      );
      return;
    }

    context.go('/admin');
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
                'Verificar 2FA'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(
                20),
        child: Column(
          children: [
            const Text(
              'Ingresa el código de Authy',
            ),

            const SizedBox(
                height: 20),

            TextField(
              controller:
                  codeController,
              keyboardType:
                  TextInputType
                      .number,
              decoration:
                  const InputDecoration(
                labelText:
                    'Código OTP',
              ),
            ),

            const SizedBox(
                height: 20),

            ElevatedButton(
              onPressed:
                  verify,
              child:
                  const Text(
                'Validar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}