import 'package:emailjs/emailjs.dart' as emailjs;

class EmailjsDatasource {
  Future<void> sendEmail({
    required String toEmail,
    required String title,
    required String message,
  }) async {
    try {
      await emailjs.send(
        'service_gepmi0m',
        'template_sopa9k9',
        {
          'to_email': toEmail,
          'title': title,
          'message': message,
        },
        const emailjs.Options(
          publicKey: 'Rf0v89nrtsDred264',
        ),
      );

      print('EMAIL ENVIADO');
    } catch (e) {
      print('ERROR EMAIL: $e');
    }
  }
}