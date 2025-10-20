import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../sanitizer.dart';

class SafeRender extends StatelessWidget {
  final String html;
  const SafeRender({super.key, required this.html});

  @override
  Widget build(BuildContext context) {
    final clean = sanitizeInput(html);
    return Card(
      color: Colors.green[50],
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Html(
          data: clean,
          style: {"*": Style(color: Colors.green[900])},
        ),
      ),
    );
  }
}
