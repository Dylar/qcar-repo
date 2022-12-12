import 'package:url_launcher/url_launcher.dart';

@override
Future sendEmail({String? email}) async {
  final uri = Uri.parse("mailto:${email ?? "feedback@qcar.de"}");
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
