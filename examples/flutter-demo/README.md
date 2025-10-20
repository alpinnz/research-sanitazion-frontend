# 🧼 Flutter Frontend Sanitization Demo

**Tujuan:** Membuat dan menguji *library sanitasi input* di sisi frontend Flutter untuk mencegah serangan seperti **XSS (Cross-Site Scripting)** dan **HTML Injection**.

---

## 📖 Latar Belakang

Sanitasi input di frontend adalah langkah penting dalam menjaga keamanan aplikasi agar tidak mengeksekusi konten HTML atau JavaScript berbahaya yang dimasukkan pengguna.
Riset ini bertujuan untuk:

* 🧩 Merumuskan **standar sanitasi input frontend**
* ⚙️ Menghasilkan **library lintas platform (Flutter, React, dll.)**
* 🔬 Melakukan **evaluasi otomatis menggunakan dataset payload XSS**

---

## 🧠 Arsitektur Proyek

```
flutter_sanitize_html_demo/
│
├── lib/
│   ├── main.dart                  # Aplikasi demo
│   ├── sanitizer.dart             # Fungsi inti sanitasi menggunakan sanitize_html
│   └── widgets/
│       ├── safe_render.dart       # Render hasil yang telah disanitasi
│       └── unsafe_render.dart     # Render HTML mentah (tanpa sanitasi)
│
└── test/
    ├── payloads.json              # Dataset payload XSS
    ├── sanitizer_basic_test.dart  # Uji dasar fungsi sanitasi
    ├── sanitizer_payloads_test.dart # Uji semua payload
    └── output/                    # Folder laporan hasil uji (opsional)
```

---

## ⚙️ Setup Lingkungan

### 1️⃣ Prasyarat

* Flutter SDK ≥ 3.0.0
* Dart ≥ 3.0.0
* Paket `sanitize_html` dari pub.dev

### 2️⃣ Install dependensi

```bash
flutter pub get
```

### 3️⃣ Jalankan aplikasi demo

```bash
flutter run
```

Akan muncul tampilan perbandingan antara:

* **UnsafeRender** → menampilkan HTML mentah (berisiko)
* **SafeRender** → menampilkan HTML yang sudah disanitasi

---

## 🔒 Sanitizer Core (lib/sanitizer.dart)

Menggunakan [`sanitize_html`](https://pub.dev/packages/sanitize_html) untuk membersihkan konten HTML sebelum dirender.

```dart
import 'package:sanitize_html/sanitize_html.dart' as sanitizer;

String sanitizeInput(String html) {
  return sanitizer.sanitizeHtml(
    html,
    allowedTags: ['b', 'i', 'u', 'strong', 'em', 'p', 'a', 'ul', 'ol', 'li'],
    allowedAttributes: {'a': ['href', 'title']},
    uriPolicy: (uri) =>
        uri?.scheme == 'https' || uri?.scheme == 'mailto',
  );
}
```

---

## 🧩 Komponen Demo

| Komponen            | Fungsi                                 | File                                |
| ------------------- | -------------------------------------- | ----------------------------------- |
| **SafeRender**      | Menampilkan HTML yang telah disanitasi | `lib/widgets/safe_render.dart`      |
| **UnsafeRender**    | Menampilkan HTML mentah tanpa filter   | `lib/widgets/unsafe_render.dart`    |
| **SanitizeInput()** | Fungsi inti sanitasi                   | `lib/sanitizer.dart`                |
| **Sanitize Tests**  | Uji keamanan berdasarkan payload XSS   | `test/sanitizer_payloads_test.dart` |

---

## 🧪 Pengujian Keamanan Otomatis

### Dataset `payloads.json`

Berisi lebih dari 60+ payload XSS umum:

```json
[
  "<script>alert('xss')</script>",
  "<img src=x onerror=alert(1)>",
  "<a href=javascript:alert(1)>click</a>",
  "<svg onload=alert(1)>",
  "<iframe srcdoc='<script>alert(1)</script>'></iframe>"
]
```

---

### Menjalankan Unit Test

Gunakan perintah berikut:

```bash
flutter test
```

Contoh output:

```
00:00 +65: All tests passed!
```

---

## ✅ Cakupan Pengujian

| Jenis Test                       | Deskripsi                               | Tujuan                                         |
| -------------------------------- | --------------------------------------- | ---------------------------------------------- |
| **sanitizer_basic_test.dart**    | Uji dasar fungsi `sanitizeInput()`      | Pastikan fungsi menghapus tag/script berbahaya |
| **sanitizer_payloads_test.dart** | Uji semua payload dari `payloads.json`  | Evaluasi keamanan terhadap XSS nyata           |
| **Widget Test**                  | Perbandingan SafeRender vs UnsafeRender | Menjamin perilaku UI aman                      |

---

## 📊 Evaluasi Hasil

| Payload                          | Status | Catatan                    |
| -------------------------------- | ------ | -------------------------- |
| `<script>alert(1)</script>`      | ✅ Aman | Tag `script` dihapus       |
| `<img src=x onerror=alert(1)>`   | ✅ Aman | Atribut `onerror` dihapus  |
| `<a href="javascript:alert(1)">` | ✅ Aman | URL `javascript:` diblokir |
| `<b>Safe text</b>`               | ✅ Aman | Tetap tampil normal        |
| `<iframe srcdoc='<script>'>`     | ✅ Aman | Tag `iframe` dihapus       |

---

## 📁 Output Hasil Evaluasi (opsional)

File hasil uji dapat disimpan ke folder:

```
test/output/sanitize_report.json
```

Contoh isi:

```json
{
  "testedPayloads": 65,
  "passed": 65,
  "failed": 0,
  "timestamp": "2025-10-20T12:35:00Z"
}
```

---

## 🧩 Integrasi Lintas Platform (Future Work)

Riset ini menjadi dasar untuk membuat:

```
sanitize/
 ┣ sanitize-core/      ← logika umum (Dart + JS)
 ┣ sanitize-dart/      ← adapter Flutter
 ┣ sanitize-js/        ← adapter React/Vue
 ┗ sanitize-tests/     ← dataset + test lintas platform
```

---

## 🧠 Kesimpulan

✅ **Flutter dapat melakukan sanitasi HTML secara aman** dengan `sanitize_html`.
✅ Library ini **mampu menangani mayoritas payload XSS umum**.
✅ Hasil uji menunjukkan **konsistensi output aman** lintas payload.
✅ Riset ini dapat diperluas untuk membuat **standar sanitasi frontend lintas framework (FEDO)**.

---

## 📚 Referensi

* [OWASP XSS Prevention Cheat Sheet](https://owasp.org/www-community/xss-prevention)
* [sanitize_html (Dart)](https://pub.dev/packages/sanitize_html)
* [DOMPurify (JS Reference)](https://github.com/cure53/DOMPurify)
* [Flutter HTML Rendering Docs](https://pub.dev/packages/flutter_html)

---

🧩 **Dibuat oleh:** Tim Riset FEDO
🧱 **Tujuan:** Standardisasi *Frontend Input Sanitization* lintas platform (Flutter, React, Vue)
📆 **Versi Demo:** 1.0 — *Riset tahap uji payload XSS*