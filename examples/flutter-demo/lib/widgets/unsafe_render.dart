import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class UnsafeRender extends StatelessWidget {
  final String html;

  const UnsafeRender({super.key, required this.html});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[50],
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Html(
          data: html,
          style: {"*": Style(color: Colors.red[900])},
        ),
      ),
    );
  }
}
