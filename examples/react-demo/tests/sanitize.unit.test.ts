import { describe, it, expect } from "vitest";
import { sanitizeHtml } from "../src/lib/sanitize";
import * as fs from "fs";
import * as path from "path";

// 🔹 Baca payloads.json secara eksplisit agar aman dari TS & bundler
const payloadPath = path.resolve(__dirname, "./payloads.json");
const payloads: string[] = JSON.parse(fs.readFileSync(payloadPath, "utf-8"));

describe("🧼 Sanitasi Input Frontend (Vitest)", () => {
    it("Membersihkan tag <script>", () => {
        const out = sanitizeHtml("<script>alert(1)</script><p>aman</p>");
        expect(out).not.toMatch(/script/i);
        expect(out).toContain("<p>aman</p>");
    });

    it("Membersihkan atribut event handler", () => {
        const out = sanitizeHtml('<img src="x" onerror="alert(1)">');
        expect(out).not.toMatch(/onerror/);
    });

    it("Menghapus tautan dengan javascript: URI", () => {
        const out = sanitizeHtml('<a href="javascript:alert(1)">klik</a>');
        expect(out).not.toMatch(/javascript:/);
    });

    it("Mengukur efektivitas sanitasi terhadap dataset payload XSS", () => {
        const total = payloads.length;
        let blocked = 0;
        const failed: string[] = [];

        for (const p of payloads) {
            const out = sanitizeHtml(p);
            // Payload dianggap lolos bila hasil masih mengandung elemen/atribut berbahaya
            const isClean = !/(<script|on\w+=|javascript:|data:text\/html|srcdoc=)/i.test(out);
            if (isClean) {
                blocked++;
            } else {
                failed.push(p);
            }
        }

        const rate = (blocked / total) * 100;
        console.log(`Efektivitas sanitasi: ${blocked}/${total} payload → ${rate.toFixed(1)}%`);

        // Simpan hasil detail (optional untuk laporan riset)
        const resultPath = path.resolve(__dirname, "./output/effectiveness.json");
        fs.mkdirSync(path.dirname(resultPath), { recursive: true });
        fs.writeFileSync(
            resultPath,
            JSON.stringify({ blocked, total, rate, failed }, null, 2),
            "utf-8"
        );

        expect(rate).toBeGreaterThanOrEqual(90);
    });
});
