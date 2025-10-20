import 'dart:convert';
import 'dart:io';

import 'package:research_sanitazion_frontend/sanitizer.dart';
import 'package:flutter_test/flutter_test.dart';

/// Daftar pola berbahaya yang tidak boleh muncul
/// di hasil sanitasi HTML.
final forbiddenPatterns = <RegExp>[
  RegExp(r'<script', caseSensitive: false),
  RegExp(r'on\w+\s*=', caseSensitive: false), // contoh: onerror=, onclick=
  RegExp(r'javascript\s*:', caseSensitive: false),
  RegExp(r'\bdata\s*:', caseSensitive: false),
  RegExp(r'<iframe', caseSensitive: false),
  RegExp(r'<svg', caseSensitive: false),
  RegExp(r'<object', caseSensitive: false),
  RegExp(r'<embed', caseSensitive: false),
  RegExp(r'expression\s*\(', caseSensitive: false),
  RegExp(r'vbscript\s*:', caseSensitive: false),
  RegExp(r'<meta', caseSensitive: false),
  RegExp(r'<form', caseSensitive: false),
  RegExp(r'<plaintext', caseSensitive: false),
  RegExp(r'document\.domain', caseSensitive: false),
];

/// Fungsi bantu untuk memastikan tidak ada pola berbahaya.
void assertClean(String sanitized, String original) {
  for (final pattern in forbiddenPatterns) {
    if (pattern.hasMatch(sanitized)) {
      fail(
        '🚨 Sanitasi gagal!\n'
        'Masih mengandung pola: ${pattern.pattern}\n'
        'Input: $original\n'
        'Output: $sanitized',
      );
    }
  }
}

/// Entry utama test
Future<void> main() async {
  // Muat dataset payloads.json
  final file = File('test/payloads.json');
  if (!await file.exists()) {
    throw Exception('❌ File test/payloads.json tidak ditemukan.');
  }

  final jsonText = await file.readAsString();
  final payloads = List<String>.from(json.decode(jsonText));

  // Buat direktori output laporan bila belum ada
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  // Statistik hasil uji
  final results = <Map<String, dynamic>>[];
  int passed = 0;
  int failed = 0;

  group('Flutter Sanitization Payload Test', () {
    test('Dataset payloads.json berhasil dimuat', () {
      expect(payloads.isNotEmpty, true, reason: 'File payloads.json harus berisi data XSS payload.');
      expect(payloads.length, greaterThan(10), reason: 'Dataset minimal berisi lebih dari 10 payload.');
    });

    // Uji setiap payload satu per satu
    for (var i = 0; i < payloads.length; i++) {
      final payload = payloads[i];

      test('Payload #$i', () {
        final sanitized = sanitizeInput(payload);

        try {
          assertClean(sanitized, payload);
          results.add({'index': i, 'input': payload, 'output': sanitized, 'status': 'passed'});
          passed++;
        } catch (e) {
          results.add({'index': i, 'input': payload, 'output': sanitizeInput(payload), 'status': 'failed', 'error': e.toString()});
          failed++;
          rethrow; // biar test tetap ditandai gagal di laporan Flutter
        }
      });
    }

    // Tes tambahan: elemen aman tetap tampil
    test('Mempertahankan tag aman', () {
      const safe = '<p>Hello <b>world</b> <a href="https://example.com">safe</a></p>';
      final sanitized = sanitizeInput(safe);
      expect(sanitized, contains('<b>world</b>'));
      expect(sanitized, contains('href="https://example.com"'));
    });
  });

  // Setelah semua test selesai, tulis laporan hasil
  tearDownAll(() {
    final report = {'testedPayloads': payloads.length, 'passed': passed, 'failed': failed, 'timestamp': DateTime.now().toIso8601String(), 'results': results};

    final reportPath = 'test/output/sanitize_report.json';
    File(reportPath).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(report));

    print('\n📊 Laporan uji disimpan di: $reportPath\n✅ Passed: $passed | ❌ Failed: $failed');
  });
}
