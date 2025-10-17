// src/lib/sanitize.ts
import sanitizeHtmlLib from 'sanitize-html';

/**
 * Sanitizes user input HTML using sanitize-html.
 * Simpler alternative to DOMPurify (no DOM dependency).
 */
export function sanitizeHtml(input: string): string {
    if (!input || typeof input !== 'string') return '';

    // Konfigurasi whitelist elemen & atribut yang diizinkan
    const clean = sanitizeHtmlLib(input, {
        allowedTags: [
            'b', 'i', 'em', 'strong', 'u', 'a', 'p', 'ul', 'ol', 'li', 'br', 'span',
            'div', 'code', 'pre', 'img'
        ],
        allowedAttributes: {
            a: ['href', 'title'],
            img: ['src', 'alt'],
            '*': ['style'] // kalau mau izinkan styling inline tertentu
        },
        allowedSchemes: ['http', 'https', 'mailto'],
        disallowedTagsMode: 'discard', // hapus tag berbahaya
        selfClosing: ['img', 'br', 'hr'],
        allowProtocolRelative: false
    });

    return clean;
}

export default sanitizeHtml;
