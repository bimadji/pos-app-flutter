import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'receipt_email.dart';

Future<void> sendEmailReceipt(List<Map<String, dynamic>> items) async {
  final prefs = await SharedPreferences.getInstance();
  final customerName = prefs.getString('customer_name') ?? 'Customer';
  final customerEmail = prefs.getString('customer_email') ?? 'customer@example.com';
  final tableNumber = prefs.getInt('customer_table') ?? 0;

  final htmlBody = generateReceiptHtml(
    customerName: customerName,
    customerEmail: customerEmail,
    tableNumber: tableNumber,
    items: items,
  );

  final smtpServer = SmtpServer(
    'smtp.gmail.com',
    port: 587,
    username: 'ketumbarasin485@gmail.com',
    password: 'fixv irmb cacc umlc',
  );

  final message = Message()
    ..from = Address('noreply@kafeorange.com', 'POS KAFE ORANGE')
    ..recipients.add(customerEmail)
    ..subject = 'Struk Pesanan Anda'
    ..html = htmlBody;

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Email not sent. $e');
  }
}
