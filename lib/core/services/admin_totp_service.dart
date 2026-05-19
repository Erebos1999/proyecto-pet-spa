import 'dart:math';
import 'package:otp/otp.dart';

class AdminTotpService {
  String generateSecret() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final random = Random.secure();

    return List.generate(
      16,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  String buildOtpUrl({
    required String email,
    required String secret,
  }) {
    return
        'otpauth://totp/PetSpa:$email'
        '?secret=$secret'
        '&issuer=PetSpa';
  }

  bool verifyCode({
    required String secret,
    required String code,
  }) {
    final generated = OTP.generateTOTPCodeString(
      secret,
      DateTime.now().millisecondsSinceEpoch,
      interval: 30,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );

    return generated == code;
  }
}