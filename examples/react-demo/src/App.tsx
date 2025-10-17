import {useState} from 'react';
import {UnsafeRender} from './components/UnsafeRender';
import {SafeRender} from './components/SafeRender';

export default function App() {
    const [input, setInput] = useState<string>('<b>Halo Dunia</b>');
    const [showHelp, setShowHelp] = useState<boolean>(false);

    return (
        <div className="app-container">
            <h1>🔒 Simulasi Sanitasi Input Frontend</h1>
            <p className="subtitle">
                Masukkan payload HTML atau XSS, lalu lihat perbandingan rendernya.
            </p>

            <textarea
                className="input-area"
                value={input}
                onChange={(e) => setInput(e.target.value)}
                placeholder="Ketik HTML di sini, misalnya: <script>alert('XSS')</script>"
            />

            <div className="render-grid">
                <div className="render-box">
                    <h2 className="danger-title">Tanpa Sanitasi</h2>
                    <UnsafeRender html={input}/>
                </div>
                <div className="render-box">
                    <h2 className="safe-title">Dengan Sanitasi</h2>
                    <SafeRender html={input}/>
                </div>
            </div>

            <button className="toggle-btn" onClick={() => setShowHelp(!showHelp)}>
                {showHelp ? 'Tutup Panduan' : 'Lihat Panduan Payload'}
            </button>

            {showHelp && (
                <div className="help-box">
                    <h3>Contoh payload untuk diuji</h3>
                    <ul>
                        <li><code>&lt;script&gt;alert('XSS')&lt;/script&gt;</code></li>
                        <li><code>&lt;img src=x onerror=alert(1)&gt;</code></li>
                        <li><code>&lt;a href="javascript:alert(1)"&gt;klik&lt;/a&gt;</code></li>
                        <li><code>&lt;svg onload=alert(1)&gt;&lt;/svg&gt;</code></li>
                    </ul>
                    <p>
                        Pada sisi kanan, hasil seharusnya tidak mengeksekusi kode berbahaya.
                        <br/>
                        Semua <code>script</code> dan event handler harus terhapus.
                    </p>
                </div>
            )}
        </div>
    );
}
