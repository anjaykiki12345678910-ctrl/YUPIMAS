// ============================================================
// RESBOB BYPASS v2.0 - SCRIPT.JS (REAL VERSION)
// Developer: YUPIMAS
// Key System: R3-SB-0B
// ============================================================

(function() {
    'use strict';

    // Konfigurasi
    const CONFIG = {
        VALID_KEY: 'R3-SB-0B',
        DELAY_SECONDS: 50,
        TARVIRAL_URL: 'https://tarviral.com/como-ganhar-dinheiro-online-de-forma-realista/',
        GETKEY_BASE: 'https://aincradmods.com/getkey',
        TELEGRAM_LINK: 't.me://yupimas'
    };

    // ============================================================
    // 1. BUILD UI
    // ============================================================
    function buildUI() {
        // Hapus jika sudah ada
        const existing = document.getElementById('resbob-overlay');
        if (existing) existing.remove();

        // Overlay utama
        const overlay = document.createElement('div');
        overlay.id = 'resbob-overlay';
        overlay.style.cssText = `
            position: fixed;
            top: 0; left: 0; width: 100vw; height: 100vh;
            background: #0a0a0a;
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 999999;
            font-family: 'Orbitron', sans-serif;
            color: #fff;
            overflow: auto;
            padding: 20px;
            box-sizing: border-box;
            transition: all 0.5s ease;
        `;

        // Load Google Font
        const link = document.createElement('link');
        link.href = 'https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&display=swap';
        link.rel = 'stylesheet';
        document.head.appendChild(link);

        // Container
        const container = document.createElement('div');
        container.id = 'resbob-container';
        container.style.cssText = `
            max-width: 550px;
            width: 100%;
            background: #1a1a1a;
            border: 2px solid #ff0000;
            border-radius: 16px;
            padding: 40px 30px;
            box-shadow: 0 0 40px rgba(255,0,0,0.3);
            text-align: center;
            position: relative;
            transition: all 0.3s;
        `;

        // ============================================================
        // TOMBOL HIDE / UNHIDE (di pojok kanan atas)
        // ============================================================
        const hideBtn = document.createElement('button');
        hideBtn.id = 'resbob-hide-btn';
        hideBtn.innerHTML = '&#9650;'; // segitiga atas (hide)
        hideBtn.style.cssText = `
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: #ff0000;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            color: #fff;
            font-size: 24px;
            font-weight: 900;
            cursor: pointer;
            z-index: 9999999;
            box-shadow: 0 0 20px rgba(255,0,0,0.5);
            transition: all 0.3s;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Orbitron', sans-serif;
        `;
        hideBtn.addEventListener('mouseover', () => {
            hideBtn.style.transform = 'scale(1.1)';
        });
        hideBtn.addEventListener('mouseout', () => {
            hideBtn.style.transform = 'scale(1)';
        });

        let isHidden = false;
        hideBtn.addEventListener('click', function() {
            if (isHidden) {
                // Tampilkan
                overlay.style.display = 'flex';
                hideBtn.innerHTML = '&#9650;';
                isHidden = false;
            } else {
                // Sembunyikan
                overlay.style.display = 'none';
                hideBtn.innerHTML = '&#9660;'; // segitiga bawah (unhide)
                isHidden = true;
            }
        });

        document.body.appendChild(hideBtn);

        // ============================================================
        // LOGIN SCREEN (KEY VERIFICATION)
        // ============================================================
        const loginDiv = document.createElement('div');
        loginDiv.id = 'resbob-login';

        const title = document.createElement('h1');
        title.textContent = 'RESBOB BYPASS';
        title.style.cssText = `
            font-weight: 900;
            font-size: 2.2rem;
            color: #ff0000;
            text-shadow: 0 0 20px rgba(255,0,0,0.6);
            margin: 0 0 5px 0;
            letter-spacing: 2px;
        `;
        loginDiv.appendChild(title);

        const sub = document.createElement('p');
        sub.textContent = 'Developer: YUPIMAS';
        sub.style.cssText = `
            font-weight: 400;
            font-size: 0.9rem;
            color: #aaa;
            margin: 0 0 25px 0;
            letter-spacing: 1px;
        `;
        loginDiv.appendChild(sub);

        const keyLabel = document.createElement('label');
        keyLabel.textContent = 'ENTER SYSTEM KEY';
        keyLabel.style.cssText = `
            display: block;
            font-weight: 700;
            font-size: 0.8rem;
            color: #ff4444;
            letter-spacing: 2px;
            margin-bottom: 8px;
        `;
        loginDiv.appendChild(keyLabel);

        const keyInput = document.createElement('input');
        keyInput.type = 'text';
        keyInput.placeholder = 'R3-SB-0B';
        keyInput.style.cssText = `
            width: 100%;
            padding: 12px 16px;
            background: #111;
            border: 2px solid #333;
            border-radius: 8px;
            color: #fff;
            font-size: 1rem;
            font-family: 'Orbitron', sans-serif;
            text-align: center;
            outline: none;
            transition: border-color 0.3s;
            box-sizing: border-box;
        `;
        keyInput.addEventListener('focus', () => {
            keyInput.style.borderColor = '#ff0000';
        });
        keyInput.addEventListener('blur', () => {
            keyInput.style.borderColor = '#333';
        });
        loginDiv.appendChild(keyInput);

        const statusMsg = document.createElement('p');
        statusMsg.id = 'resbob-status';
        statusMsg.style.cssText = `
            font-size: 0.9rem;
            font-weight: 700;
            height: 24px;
            margin: 10px 0 15px 0;
        `;
        loginDiv.appendChild(statusMsg);

        const verifyBtn = document.createElement('button');
        verifyBtn.textContent = 'VERIFY KEY';
        verifyBtn.style.cssText = `
            width: 100%;
            padding: 14px;
            background: #ff0000;
            border: none;
            border-radius: 8px;
            color: #fff;
            font-weight: 900;
            font-size: 1.1rem;
            font-family: 'Orbitron', sans-serif;
            letter-spacing: 2px;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 0 20px rgba(255,0,0,0.3);
        `;
        verifyBtn.addEventListener('mouseover', () => {
            verifyBtn.style.transform = 'scale(1.02)';
            verifyBtn.style.boxShadow = '0 0 30px rgba(255,0,0,0.6)';
        });
        verifyBtn.addEventListener('mouseout', () => {
            verifyBtn.style.transform = 'scale(1)';
            verifyBtn.style.boxShadow = '0 0 20px rgba(255,0,0,0.3)';
        });
        loginDiv.appendChild(verifyBtn);

        container.appendChild(loginDiv);

        // ============================================================
        // MAIN SCREEN (after key valid)
        // ============================================================
        const mainDiv = document.createElement('div');
        mainDiv.id = 'resbob-main';
        mainDiv.style.display = 'none';

        const mainTitle = document.createElement('h1');
        mainTitle.textContent = 'RESBOB BYPASS';
        mainTitle.style.cssText = `
            font-weight: 900;
            font-size: 2.2rem;
            color: #ff0000;
            text-shadow: 0 0 20px rgba(255,0,0,0.6);
            margin: 0 0 5px 0;
            letter-spacing: 2px;
        `;
        mainDiv.appendChild(mainTitle);

        const mainSub = document.createElement('p');
        mainSub.textContent = 'Developer: YUPIMAS';
        mainSub.style.cssText = `
            font-weight: 400;
            font-size: 0.9rem;
            color: #aaa;
            margin: 0 0 30px 0;
            letter-spacing: 1px;
        `;
        mainDiv.appendChild(mainSub);

        // Tombol Aincard
        const aincardBtn = document.createElement('button');
        aincardBtn.textContent = 'AINCARD';
        aincardBtn.style.cssText = `
            width: 100%;
            padding: 16px;
            background: #cc0000;
            border: none;
            border-radius: 8px;
            color: #fff;
            font-weight: 900;
            font-size: 1.4rem;
            font-family: 'Orbitron', sans-serif;
            letter-spacing: 3px;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 0 25px rgba(204,0,0,0.4);
            margin-bottom: 20px;
        `;
        aincardBtn.addEventListener('mouseover', () => {
            aincardBtn.style.transform = 'scale(1.03)';
            aincardBtn.style.boxShadow = '0 0 40px rgba(204,0,0,0.7)';
        });
        aincardBtn.addEventListener('mouseout', () => {
            aincardBtn.style.transform = 'scale(1)';
            aincardBtn.style.boxShadow = '0 0 25px rgba(204,0,0,0.4)';
        });
        mainDiv.appendChild(aincardBtn);

        // Progress bar container
        const progressContainer = document.createElement('div');
        progressContainer.style.cssText = `
            width: 100%;
            height: 6px;
            background: #222;
            border-radius: 4px;
            margin: 15px 0 10px 0;
            overflow: hidden;
            display: none;
        `;
        const progressBar = document.createElement('div');
        progressBar.style.cssText = `
            height: 100%;
            width: 0%;
            background: #ff0000;
            border-radius: 4px;
            transition: width 0.5s linear;
        `;
        progressContainer.appendChild(progressBar);
        mainDiv.appendChild(progressContainer);

        const timerText = document.createElement('p');
        timerText.id = 'resbob-timer';
        timerText.style.cssText = `
            font-size: 0.9rem;
            color: #aaa;
            margin: 5px 0 15px 0;
            display: none;
        `;
        mainDiv.appendChild(timerText);

        // Tombol Telegram (icon)
        const telegramBtn = document.createElement('button');
        telegramBtn.innerHTML = `
            <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21.5 4.5L2.5 10.5L9 13.5L13 20.5L18.5 10.5L21.5 4.5Z" />
                <path d="M9 13.5L3.5 19.5" />
            </svg>
        `;
        telegramBtn.style.cssText = `
            position: absolute;
            bottom: 20px;
            right: 20px;
            background: #0088cc;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 0 20px rgba(0,136,204,0.5);
        `;
        telegramBtn.addEventListener('mouseover', () => {
            telegramBtn.style.transform = 'scale(1.1)';
        });
        telegramBtn.addEventListener('mouseout', () => {
            telegramBtn.style.transform = 'scale(1)';
        });
        telegramBtn.addEventListener('click', () => {
            window.open(CONFIG.TELEGRAM_LINK, '_blank');
        });
        mainDiv.appendChild(telegramBtn);

        container.appendChild(mainDiv);

        // ============================================================
        // INSTRUCTION & TOKEN INPUT SCREEN
        // ============================================================
        const instructionDiv = document.createElement('div');
        instructionDiv.id = 'resbob-instruction';
        instructionDiv.style.display = 'none';

        const instrTitle = document.createElement('h2');
        instrTitle.textContent = 'LANGKAH SELANJUTNYA';
        instrTitle.style.cssText = `
            font-weight: 900;
            font-size: 1.5rem;
            color: #ff0000;
            margin: 0 0 15px 0;
        `;
        instructionDiv.appendChild(instrTitle);

        const instrText = document.createElement('p');
        instrText.textContent = `1. Kami akan membuka Tarviral di tab baru.\n2. Selesaikan 6 langkah yang diberikan.\n3. Setelah selesai, Anda akan di-redirect ke halaman getkey dengan token di URL.\n4. Salin token dari URL (bagian setelah ?token=).\n5. Tempelkan token di bawah lalu klik "AMBIL KEY".`;
        instrText.style.cssText = `
            font-size: 0.95rem;
            color: #ccc;
            line-height: 1.6;
            margin: 0 0 20px 0;
            text-align: left;
            white-space: pre-line;
        `;
        instructionDiv.appendChild(instrText);

        const tokenLabel = document.createElement('label');
        tokenLabel.textContent = 'MASUKKAN TOKEN:';
        tokenLabel.style.cssText = `
            display: block;
            font-weight: 700;
            font-size: 0.8rem;
            color: #ff4444;
            letter-spacing: 2px;
            margin-bottom: 8px;
            text-align: left;
        `;
        instructionDiv.appendChild(tokenLabel);

        const tokenInput = document.createElement('input');
        tokenInput.type = 'text';
        tokenInput.placeholder = 'Contoh: 2506652d04f04a31ab536c0adb6d5969';
        tokenInput.style.cssText = `
            width: 100%;
            padding: 12px 16px;
            background: #111;
            border: 2px solid #333;
            border-radius: 8px;
            color: #fff;
            font-size: 0.9rem;
            font-family: 'Orbitron', sans-serif;
            text-align: center;
            outline: none;
            transition: border-color 0.3s;
            box-sizing: border-box;
        `;
        tokenInput.addEventListener('focus', () => {
            tokenInput.style.borderColor = '#ff0000';
        });
        tokenInput.addEventListener('blur', () => {
            tokenInput.style.borderColor = '#333';
        });
        instructionDiv.appendChild(tokenInput);

        const tokenStatus = document.createElement('p');
        tokenStatus.id = 'resbob-token-status';
        tokenStatus.style.cssText = `
            font-size: 0.9rem;
            font-weight: 700;
            height: 24px;
            margin: 10px 0 15px 0;
        `;
        instructionDiv.appendChild(tokenStatus);

        const getKeyBtn = document.createElement('button');
        getKeyBtn.textContent = 'AMBIL KEY';
        getKeyBtn.style.cssText = `
            width: 100%;
            padding: 14px;
            background: #ff0000;
            border: none;
            border-radius: 8px;
            color: #fff;
            font-weight: 900;
            font-size: 1.1rem;
            font-family: 'Orbitron', sans-serif;
            letter-spacing: 2px;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 0 20px rgba(255,0,0,0.3);
        `;
        getKeyBtn.addEventListener('mouseover', () => {
            getKeyBtn.style.transform = 'scale(1.02)';
            getKeyBtn.style.boxShadow = '0 0 30px rgba(255,0,0,0.6)';
        });
        getKeyBtn.addEventListener('mouseout', () => {
            getKeyBtn.style.transform = 'scale(1)';
            getKeyBtn.style.boxShadow = '0 0 20px rgba(255,0,0,0.3)';
        });
        instructionDiv.appendChild(getKeyBtn);

        container.appendChild(instructionDiv);

        overlay.appendChild(container);
        document.body.appendChild(overlay);

        // ============================================================
        // 2. LOGIC
        // ============================================================

        let isProcessing = false;

        // Verifikasi Key
        verifyBtn.addEventListener('click', function() {
            const inputKey = keyInput.value.trim();
            if (inputKey === CONFIG.VALID_KEY) {
                statusMsg.textContent = 'KEY VALID!';
                statusMsg.style.color = '#00ff00';
                loginDiv.style.display = 'none';
                mainDiv.style.display = 'block';
                setTimeout(() => {
                    statusMsg.textContent = '';
                }, 1500);
            } else {
                statusMsg.textContent = 'KEY INVALID!';
                statusMsg.style.color = '#ff0000';
                keyInput.value = '';
                keyInput.focus();
                keyInput.style.borderColor = '#ff0000';
                setTimeout(() => {
                    keyInput.style.borderColor = '#333';
                }, 600);
            }
        });

        keyInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                verifyBtn.click();
            }
        });

        // Aincard button
        aincardBtn.addEventListener('click', function() {
            if (isProcessing) return;
            const confirmAction = confirm('Apakah anda ingin melanjutkan bypass key aincard?');
            if (!confirmAction) return;

            isProcessing = true;
            aincardBtn.disabled = true;
            aincardBtn.textContent = 'PROCESSING...';
            aincardBtn.style.opacity = '0.6';

            progressContainer.style.display = 'block';
            timerText.style.display = 'block';
            progressBar.style.width = '0%';
            timerText.textContent = `Menunggu ${CONFIG.DELAY_SECONDS} detik...`;

            let elapsed = 0;
            const interval = setInterval(() => {
                elapsed += 0.5;
                const percent = (elapsed / CONFIG.DELAY_SECONDS) * 100;
                progressBar.style.width = Math.min(percent, 100) + '%';
                timerText.textContent = `Menunggu ${Math.ceil(CONFIG.DELAY_SECONDS - elapsed)} detik...`;
                if (elapsed >= CONFIG.DELAY_SECONDS) {
                    clearInterval(interval);
                    progressBar.style.width = '100%';
                    timerText.textContent = 'Delay selesai! Membuka Tarviral...';
                    setTimeout(() => {
                        // Buka tarviral di tab baru
                        window.open(CONFIG.TARVIRAL_URL, '_blank');
                        // Tampilkan instruksi, sembunyikan main
                        mainDiv.style.display = 'none';
                        instructionDiv.style.display = 'block';
                        isProcessing = false;
                        aincardBtn.disabled = false;
                        aincardBtn.textContent = 'AINCARD';
                        aincardBtn.style.opacity = '1';
                        progressContainer.style.display = 'none';
                        timerText.style.display = 'none';
                    }, 500);
                }
            }, 500);
        });

        // Ambil Key dengan token
        getKeyBtn.addEventListener('click', function() {
            const token = tokenInput.value.trim();
            if (!token) {
                tokenStatus.textContent = 'Token tidak boleh kosong!';
                tokenStatus.style.color = '#ff0000';
                return;
            }

            getKeyBtn.disabled = true;
            getKeyBtn.textContent = 'MENGAMBIL...';
            tokenStatus.textContent = '';

            const url = CONFIG.GETKEY_BASE + '?token=' + encodeURIComponent(token);

            fetch(url, {
                method: 'GET',
                credentials: 'include',
                headers: {
                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('HTTP ' + response.status + ' - ' + response.statusText);
                }
                return response.text();
            })
            .then(data => {
                // Tampilkan key
                instructionDiv.innerHTML = `
                    <h2 style="font-weight:900;font-size:1.5rem;color:#00ff00;margin:0 0 15px 0;">KEY BERHASIL DIDAPATKAN!</h2>
                    <pre style="background:#111;padding:15px;border-radius:8px;border:1px solid #00ff00;color:#00ff00;font-family:'Orbitron',monospace;font-size:1.1rem;word-wrap:break-word;white-space:pre-wrap;">${data}</pre>
                    <p style="color:#aaa;margin-top:15px;">Copy key di atas dan gunakan untuk aktivasi.</p>
                    <button onclick="location.reload()" style="width:100%;padding:14px;background:#ff0000;border:none;border-radius:8px;color:#fff;font-weight:900;font-size:1rem;font-family:'Orbitron',sans-serif;letter-spacing:1px;cursor:pointer;margin-top:15px;">KEMBALI</button>
                `;
            })
            .catch(error => {
                tokenStatus.textContent = 'GAGAL: ' + error.message;
                tokenStatus.style.color = '#ff0000';
                getKeyBtn.disabled = false;
                getKeyBtn.textContent = 'AMBIL KEY';
                // Tawarkan untuk coba lagi
                setTimeout(() => {
                    tokenStatus.textContent = '';
                }, 5000);
            });
        });

        // Tambahkan style global
        const style = document.createElement('style');
        style.textContent = `
            #resbob-overlay::-webkit-scrollbar {
                width: 6px;
            }
            #resbob-overlay::-webkit-scrollbar-track {
                background: #0a0a0a;
            }
            #resbob-overlay::-webkit-scrollbar-thumb {
                background: #ff0000;
                border-radius: 4px;
            }
            #resbob-overlay input:focus {
                outline: none;
            }
            #resbob-hide-btn:hover {
                box-shadow: 0 0 30px rgba(255,0,0,0.8);
            }
        `;
        document.head.appendChild(style);
    }

    // ============================================================
    // 3. INIT
    // ============================================================
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', buildUI);
    } else {
        buildUI();
    }
})();
