import 'package:sanitize_html/sanitize_html.dart' as sanitizer;

String sanitizeInput(String html) {
  return sanitizer.sanitizeHtml(html);
}
