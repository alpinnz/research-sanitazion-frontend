import 'package:flutter/material.dart';
import 'widgets/safe_render.dart';
import 'widgets/unsafe_render.dart';

void main() {
  runApp(const SanitizeHtmlDemo());
}

class SanitizeHtmlDemo extends StatefulWidget {
  const SanitizeHtmlDemo({super.key});

  @override
  State<SanitizeHtmlDemo> createState() => _SanitizeHtmlDemoState();
}

class _SanitizeHtmlDemoState extends State<SanitizeHtmlDemo> {
  final controller = TextEditingController(
      text:
      '<b>Hello</b> <script>alert("XSS")</script> <a href="javascript:evil()">click me</a>');

  @override
  Widget build(BuildContext context) {
    final input = controller.text;

    return MaterialApp(
      title: 'Flutter Sanitize HTML Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: Scaffold(
        appBar: AppBar(title: const Text('Sanitize HTML Demo')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: ListView(
            children: [
              const Text('Masukkan HTML:'),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Tulis HTML di sini...',
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              const Text('Tanpa Sanitasi (berisiko):',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              UnsafeRender(html: input),
              const SizedBox(height: 16),
              const Text('Dengan Sanitasi (aman):',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SafeRender(html: input),
            ],
          ),
        ),
      ),
    );
  }
}
