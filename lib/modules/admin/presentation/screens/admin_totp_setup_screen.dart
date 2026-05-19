import 'package:cerberus_pet_spa/core/services/admin_totp_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';



class AdminTotpSetupScreen extends StatefulWidget {
  const AdminTotpSetupScreen({super.key});

  @override
  State<AdminTotpSetupScreen> createState() =>
      _AdminTotpSetupScreenState();
}

class _AdminTotpSetupScreenState
    extends State<AdminTotpSetupScreen> {
  final service = AdminTotpService();

  final codeController =
      TextEditingController();

  late String secret;
  late String otpUrl;

  @override
  void initState() {
    super.initState();

    final email =
        FirebaseAuth.instance
            .currentUser!
            .email!;

    secret =
        service.generateSecret();

    otpUrl =
        service.buildOtpUrl(
      email: email,
      secret: secret,
    );
  }

  Future<void> activate() async {
    final valid =
        service.verifyCode(
      secret: secret,
      code:
          codeController.text.trim(),
    );

    if (!valid) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Código inválido',
          ),
        ),
      );
      return;
    }

    final uid =
        FirebaseAuth.instance
            .currentUser!
            .uid;

    await FirebaseFirestore.instance
        .collection('Usuarios')
        .doc(uid)
        .update({
      'mfaEnabled': true,
      'mfaSecret': secret,
    });

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
                'Configurar 2FA'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Escanea con Authy',
            ),
            const SizedBox(
                height: 20),
            QrImageView(
              data: otpUrl,
              size: 220,
            ),
            const SizedBox(
                height: 30),
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
                  activate,
              child:
                  const Text(
                'Activar 2FA',
              ),
            )
          ],
        ),
      ),
    );
  }
}