(function () {
  "use strict";

  const _decode = (str) => atob(str);

  const CONFIG = {
    r: _decode("aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2Rib2ZjaGwvYnlwYXNzL21haW4vYnlwYXNzLnR4dA=="),
    t: _decode("aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2Rib2ZjaGwvYnlwYXNzL21haW4vY2gudHh0"),
    m: _decode("aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY39tL3Zhbnotd2Vic2l0ZS9WYW56QnlwYXNzL21haW4vbXVzaWMubXAz"),
  };

  const TELEGRAM_LINK = _decode("aHR0cHM6Ly90Lm1lL3l1cGltYXM=");
  const VALID_KEYS = ["YUPIMAS"];
  let audioPlayer = null;
  let matrixState = "LOGIN";
  const TITLE = "RESBOB AINCARD";
  const FALLBACK_MUSIC_URL = _decode("aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY39tL3Zhbnotd2Vic2l0ZS9WYW56QnlwYXNzL21haW4vbXVzaWMubXAz");

  (async function () {
    document.getElementById("matrix-bg-canvas")?.remove();
    document.getElementById("resbob-auth-box")?.remove();
    document.getElementById("resbob-floating-credit")?.remove();

    // ─── ULTIMATE STYLE ──────────────────────────────────────────────
    const styleEl = document.createElement("style");
    styleEl.textContent = `
      @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;900&display=swap');

      * { margin: 0; padding: 0; box-sizing: border-box; }

      body { font-family: 'Inter', sans-serif; }

      @keyframes fadeSlide {
        0% { opacity: 0; transform: translateY(20px) scale(0.98); }
        100% { opacity: 1; transform: translateY(0) scale(1); }
      }

      @keyframes glowPulse {
        0%, 100% { box-shadow: 0 0 8px rgba(255, 0, 51, 0.15), 0 0 20px rgba(255, 0, 51, 0.05); }
        50% { box-shadow: 0 0 20px rgba(255, 0, 51, 0.3), 0 0 40px rgba(255, 0, 51, 0.1); }
      }

      @keyframes glitchText {
        0% { text-shadow: 0 0 5px #ff0033; }
        95% { text-shadow: 0 0 5px #ff0033; }
        96% { text-shadow: -1px 0 #ff0055, 1px 0 #ff00aa; }
        98% { text-shadow: 1px 0 #ff0055, -1px 0 #ff00aa; }
        100% { text-shadow: 0 0 5px #ff0033; }
      }

      @keyframes spinClockwise {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }

      @keyframes spinCounter {
        0% { transform: rotate(360deg); }
        100% { transform: rotate(0deg); }
      }

      .resbob-glass {
        background: rgba(10, 10, 10, 0.85);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.05);
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.8), 0 0 40px rgba(255, 0, 51, 0.05);
      }

      .resbob-title {
        animation: glitchText 3s infinite linear;
        font-weight: 900;
        letter-spacing: 4px;
        background: linear-gradient(135deg, #ff0033, #ff3366);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
      }

      .resbob-input {
        width: 100%;
        padding: 14px 18px;
        background: rgba(0, 0, 0, 0.7);
        border: 1px solid rgba(255, 0, 51, 0.15);
        border-radius: 10px;
        color: #fff;
        font-size: 14px;
        font-weight: 500;
        letter-spacing: 1px;
        outline: none;
        transition: all 0.3s ease;
        font-family: 'Inter', sans-serif;
      }
      .resbob-input:focus {
        border-color: #ff0033;
        box-shadow: 0 0 20px rgba(255, 0, 51, 0.1);
      }

      .resbob-btn-primary {
        width: 100%;
        padding: 14px;
        background: linear-gradient(135deg, #ff0033, #cc0033);
        border: none;
        border-radius: 10px;
        color: #fff;
        font-weight: 700;
        font-size: 14px;
        letter-spacing: 2px;
        cursor: pointer;
        transition: all 0.3s ease;
        font-family: 'Inter', sans-serif;
        text-transform: uppercase;
        box-shadow: 0 4px 20px rgba(255, 0, 51, 0.2);
      }
      .resbob-btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 30px rgba(255, 0, 51, 0.35);
      }
      .resbob-btn-primary:disabled {
        opacity: 0.4;
        cursor: not-allowed;
        transform: none;
      }

      .resbob-btn-tele {
        width: 100%;
        padding: 12px;
        background: transparent;
        border: 1px solid rgba(34, 158, 217, 0.3);
        border-radius: 10px;
        color: #229ED9;
        font-weight: 600;
        font-size: 13px;
        letter-spacing: 1px;
        cursor: pointer;
        transition: all 0.3s ease;
        font-family: 'Inter', sans-serif;
      }
      .resbob-btn-tele:hover {
        background: rgba(34, 158, 217, 0.05);
        border-color: #229ED9;
      }

      .resbob-key-select {
        display: flex;
        gap: 12px;
        margin: 15px 0 20px 0;
        flex-wrap: wrap;
        justify-content: center;
      }

      .resbob-key-option {
        flex: 1;
        min-width: 100px;
        padding: 14px 10px;
        border-radius: 10px;
        font-weight: 700;
        font-size: 14px;
        letter-spacing: 1px;
        cursor: pointer;
        transition: all 0.3s ease;
        text-align: center;
        font-family: 'Inter', sans-serif;
        border: 2px solid rgba(255, 255, 255, 0.06);
        background: rgba(255, 255, 255, 0.02);
        color: #888;
      }
      .resbob-key-option.active {
        border-color: #ff0033;
        background: rgba(255, 0, 51, 0.08);
        color: #fff;
        box-shadow: 0 0 25px rgba(255, 0, 51, 0.1);
      }
      .resbob-key-option.fake {
        opacity: 0.3;
        cursor: not-allowed;
        filter: grayscale(1);
      }
      .resbob-key-option .badge {
        font-size: 10px;
        color: #666;
        display: block;
        margin-top: 4px;
        font-weight: 400;
        letter-spacing: 0.5px;
      }
      .resbob-key-option.active .badge {
        color: #ff3366;
      }

      .resbob-progress-wrap {
        background: rgba(255, 255, 255, 0.03);
        height: 6px;
        border-radius: 20px;
        overflow: hidden;
        margin: 20px 0 12px 0;
        box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.4);
      }
      .resbob-progress-bar {
        height: 100%;
        width: 0%;
        background: linear-gradient(90deg, #ff0033, #ff3366, #ff0033);
        background-size: 200% 100%;
        border-radius: 20px;
        transition: width 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        box-shadow: 0 0 20px #ff0033;
        animation: glowPulse 1.5s infinite;
      }

      .resbob-status-text {
        color: #ff3366;
        font-size: 12px;
        font-weight: 500;
        letter-spacing: 2px;
        margin: 8px 0 4px 0;
        text-shadow: 0 0 10px rgba(255, 51, 102, 0.2);
      }

      .resbob-countdown {
        color: #fff;
        font-size: 28px;
        font-weight: 700;
        letter-spacing: 2px;
        text-shadow: 0 0 30px rgba(255, 0, 51, 0.3);
        font-variant-numeric: tabular-nums;
      }

      .resbob-credit {
        position: fixed;
        bottom: 18px;
        right: 22px;
        font-size: 11px;
        font-weight: 600;
        letter-spacing: 1.5px;
        z-index: 2147483647;
        text-decoration: none;
        color: rgba(255, 0, 51, 0.5);
        background: rgba(0, 0, 0, 0.4);
        backdrop-filter: blur(6px);
        padding: 6px 14px;
        border-radius: 30px;
        border: 1px solid rgba(255, 0, 51, 0.05);
        transition: all 0.3s ease;
      }
      .resbob-credit:hover {
        color: #ff0033;
        border-color: rgba(255, 0, 51, 0.2);
      }

      .resbob-music-btn {
        position: absolute;
        top: 16px;
        right: 16px;
        background: transparent;
        border: 1px solid rgba(255, 0, 51, 0.1);
        color: #555;
        border-radius: 6px;
        width: 32px;
        height: 28px;
        cursor: pointer;
        font-size: 10px;
        font-family: 'Inter', sans-serif;
        transition: all 0.3s ease;
      }
      .resbob-music-btn:hover {
        border-color: #ff0033;
        color: #ff0033;
      }

      .resbob-auth-box {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 380px;
        max-width: 92vw;
        padding: 38px 30px 30px;
        border-radius: 20px;
        z-index: 2147483647;
        animation: fadeSlide 0.6s cubic-bezier(0.22, 1, 0.36, 1);
        text-align: center;
      }

      .resbob-timer-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        z-index: 2147483645;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(0, 0, 0, 0.75);
        backdrop-filter: blur(4px);
        animation: fadeSlide 0.4s ease;
      }

      .resbob-timer-card {
        width: 340px;
        padding: 35px 30px 30px;
        border-radius: 20px;
        text-align: center;
        animation: fadeSlide 0.5s ease;
      }

      @media (max-width: 480px) {
        .resbob-auth-box { padding: 30px 20px; }
        .resbob-key-option { min-width: 80px; font-size: 12px; padding: 12px 8px; }
      }
    `;
    document.head.appendChild(styleEl);

    // ─── MATRIX CANVAS ────────────────────────────────────────────────
    const canvas = document.createElement("canvas");
    canvas.id = "matrix-bg-canvas";
    canvas.style.cssText =
      "position:fixed; top:0; left:0; width:100%; height:100%; z-index:2147483640; background:#07070a;";
    document.body.appendChild(canvas);

    const ctx = canvas.getContext("2d");
    let width = (canvas.width = window.innerWidth);
    let height = (canvas.height = window.innerHeight);

    window.addEventListener("resize", () => {
      width = canvas.width = window.innerWidth;
      height = canvas.height = window.innerHeight;
    });

    const fontSize = 13;
    const columns = Math.floor(width / fontSize);
    const drops = Array(columns).fill(1);
    const matrixChars = "01ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");

    function drawMatrix() {
      ctx.fillStyle =
        matrixState === "LOGIN" ? "rgba(7,7,10,0.04)" : "rgba(10,5,5,0.06)";
      ctx.fillRect(0, 0, width, height);

      ctx.fillStyle =
        matrixState === "LOGIN"
          ? "rgba(60,60,70,0.15)"
          : matrixState === "OVERLOAD"
          ? "rgba(255,0,51,0.12)"
          : "rgba(255,51,102,0.10)";
      ctx.font = fontSize + "px monospace";

      for (let i = 0; i < drops.length; i++) {
        const text = matrixChars[Math.floor(Math.random() * matrixChars.length)];
        ctx.fillText(text, i * fontSize, drops[i] * fontSize);
        const resetThreshold = matrixState === "LOGIN" ? 0.975 : 0.93;
        if (drops[i] * fontSize > height && Math.random() * 1 > resetThreshold)
          drops[i] = 0;
        drops[i] += matrixState === "LOGIN" ? 1 : 1.6;
      }
    }
    let matrixInterval = setInterval(drawMatrix, 33);

    // ─── FLOATING CREDIT ──────────────────────────────────────────────
    const creditLink = document.createElement("a");
    creditLink.id = "resbob-floating-credit";
    creditLink.className = "resbob-credit";
    creditLink.innerText = `// ${TITLE}`;
    creditLink.href = TELEGRAM_LINK;
    creditLink.target = "_blank";
    document.body.appendChild(creditLink);

    // ─── AUTH BOX ──────────────────────────────────────────────────────
    const authBox = document.createElement("div");
    authBox.id = "resbob-auth-box";
    authBox.className = "resbob-glass resbob-auth-box";
    authBox.innerHTML = `
      <button class="resbob-music-btn" id="resbob-music-btn">MUTE</button>

      <div class="resbob-title" style="font-size:26px; margin: 0 0 2px 0;">${TITLE}</div>
      <div style="color:#555; font-size:11px; letter-spacing:2px; margin-bottom:28px;">AUTH v3.0</div>

      <input type="text" id="resbob-key-input" class="resbob-input" placeholder="ACCESS KEY" autocomplete="off">

      <button class="resbob-btn-primary" id="resbob-login-btn" style="margin-bottom:12px;">UNLOCK</button>

      <button class="resbob-btn-tele" id="resbob-telegram-btn">TELEGRAM</button>

      <div id="resbob-status" style="margin-top:20px; font-size:11px; color:#444; letter-spacing:1px; min-height:18px;">STATUS: IDLE</div>
    `;
    document.body.appendChild(authBox);

    const musicBtn = document.getElementById("resbob-music-btn");
    const keyInput = document.getElementById("resbob-key-input");
    const loginBtn = document.getElementById("resbob-login-btn");
    const telegramBtn = document.getElementById("resbob-telegram-btn");
    const statusEl = document.getElementById("resbob-status");

    // ─── MUSIC ────────────────────────────────────────────────────────
    let musicLoading = false;
    musicBtn.addEventListener("click", async () => {
      if (musicLoading) return;
      if (!audioPlayer) {
        musicLoading = true;
        musicBtn.textContent = "...";
        let resolvedUrl = FALLBACK_MUSIC_URL;
        try {
          const res = await fetch(CONFIG.m + "?t=" + Date.now(), {
            credentials: "omit",
            mode: "cors",
          });
          const audioUrl = (await res.text()).trim();
          if (audioUrl && audioUrl.startsWith("http")) resolvedUrl = audioUrl;
        } catch (err) {}
        audioPlayer = new Audio(resolvedUrl);
        audioPlayer.loop = true;
        musicLoading = false;
      }
      if (audioPlayer.paused) {
        audioPlayer
          .play()
          .then(() => {
            musicBtn.textContent = "PLAY";
            musicBtn.style.color = "#ff0033";
            musicBtn.style.borderColor = "#ff0033";
          })
          .catch(() => {
            musicBtn.textContent = "MUTE";
          });
      } else {
        audioPlayer.pause();
        musicBtn.textContent = "MUTE";
        musicBtn.style.color = "#555";
        musicBtn.style.borderColor = "rgba(255,0,51,0.1)";
      }
    });

    telegramBtn.addEventListener("click", () => {
      if (TELEGRAM_LINK?.startsWith("http")) window.open(TELEGRAM_LINK, "_blank");
    });

    // ─── RUN REDIRECT WITH PROGRESS BAR ──────────────────────────────
    function runRedirect(countdownSeconds) {
      matrixState = "BYPASS";
      authBox.remove();

      const overlay = document.createElement("div");
      overlay.id = "resbob-timer-overlay";
      overlay.className = "resbob-timer-overlay";

      overlay.innerHTML = `
        <div class="resbob-glass resbob-timer-card">
          <div style="font-size:18px; font-weight:700; letter-spacing:3px; color:#ff0033; margin-bottom:6px; text-shadow:0 0 20px #ff0033;">BYPASS IN PROGRESS</div>
          <div style="color:#666; font-size:11px; letter-spacing:1px; margin-bottom:16px;">EXECUTING PAYLOAD</div>

          <div class="resbob-progress-wrap">
            <div class="resbob-progress-bar" id="resbob-progress-bar"></div>
          </div>

          <div class="resbob-status-text" id="resbob-status-text">INITIATING...</div>
          <div class="resbob-countdown" id="resbob-countdown-text">${countdownSeconds}s</div>
        </div>
      `;
      document.body.appendChild(overlay);

      const progressBar = document.getElementById("resbob-progress-bar");
      const statusText = document.getElementById("resbob-status-text");
      const countdownEl = document.getElementById("resbob-countdown-text");

      let remaining = countdownSeconds;
      const total = countdownSeconds;
      const statusMessages = [
        "INITIATING CONNECTION...",
        "OVERRIDING GATEWAY...",
        "INJECTING PAYLOAD...",
        "BYPASSING DETECTION...",
        "ESTABLISHING TUNNEL...",
        "HANDSHAKE IN PROGRESS...",
        "ALMOST THERE...",
        "FINALIZING...",
      ];

      const timer = setInterval(async () => {
        remaining--;
        const percent = ((total - remaining) / total) * 100;
        progressBar.style.width = Math.min(percent, 100) + "%";
        countdownEl.textContent = remaining + "s";

        const idx = Math.min(
          Math.floor((total - remaining) / (total / statusMessages.length)),
          statusMessages.length - 1
        );
        statusText.textContent = statusMessages[idx] || "PROCESSING...";

        if (remaining <= 0) {
          clearInterval(timer);
          clearInterval(matrixInterval);
          statusText.textContent = "HANDSHAKE ESTABLISHED!";
          progressBar.style.width = "100%";
          if (audioPlayer) {
            audioPlayer.pause();
            audioPlayer = null;
          }

          try {
            const res = await fetch(CONFIG.r + "?t=" + Date.now(), {
              credentials: "omit",
            });
            const redirectUrl = (await res.text()).trim();
            document.getElementById("matrix-bg-canvas")?.remove();
            overlay.remove();
            if (redirectUrl.startsWith("http")) {
              window.location.replace(redirectUrl);
            } else {
              alert("CRITICAL ERR: TARGET NOT FOUND");
            }
          } catch {
            alert("NETWORK TIMEOUT: REDIRECT FAILED");
          }
        }
      }, 1000);
    }

    // ─── LOGIN LOGIC ──────────────────────────────────────────────────
    loginBtn.addEventListener("click", () => {
      const inputKey = keyInput.value.trim();
      if (!inputKey) {
        statusEl.innerHTML = "<span style='color:#ff0033;'>ERR: KEY EMPTY</span>";
        return;
      }

      const isValid = VALID_KEYS.some(
        (k) => k.toLowerCase() === inputKey.toLowerCase()
      );

      if (isValid) {
        matrixState = "OVERLOAD";
        statusEl.innerHTML = "<span style='color:#ff0033;'>KEY VERIFIED</span>";
        loginBtn.disabled = true;
        keyInput.disabled = true;

        setTimeout(() => {
          // ─── CHOOSE KEY UI ──────────────────────────────────────────
          authBox.innerHTML = `
            <div style="font-size:18px; font-weight:700; color:#fff; letter-spacing:2px; margin-bottom:4px;">CHOOSE KEY</div>
            <div style="color:#666; font-size:11px; letter-spacing:1px; margin-bottom:18px;">SELECT TARGET</div>

            <div class="resbob-key-select">
              <div class="resbob-key-option fake" id="resbob-key-resbob">
                @RESBOB
                <span class="badge">LOCKED</span>
              </div>
              <div class="resbob-key-option active" id="resbob-key-aincard">
                AINCARD
                <span class="badge">READY</span>
              </div>
            </div>

            <button class="resbob-btn-primary" id="resbob-execute-btn">EXECUTE</button>
            <div style="margin-top:14px; font-size:10px; color:#444; letter-spacing:1px;">SELECT AINCARD TO CONTINUE</div>
          `;

          const execBtn = document.getElementById("resbob-execute-btn");
          const optResbob = document.getElementById("resbob-key-resbob");
          const optAincard = document.getElementById("resbob-key-aincard");

          let selected = "AINCARD";

          optAincard.addEventListener("click", () => {
            optAincard.classList.add("active");
            optResbob.classList.remove("active");
            selected = "AINCARD";
            execBtn.disabled = false;
            execBtn.style.opacity = "1";
            execBtn.textContent = "EXECUTE";
          });

          optResbob.addEventListener("click", () => {
            // fake – ga jalan
            optResbob.classList.add("active");
            optAincard.classList.remove("active");
            selected = "AINCARD PROXY";
            execBtn.disabled = true;
            execBtn.style.opacity = "0.4";
            execBtn.textContent = "LOCKED";
          });

          execBtn.addEventListener("click", () => {
            if (selected === "AINCARD") {
              runRedirect(30);
            } else {
              alert("AINCARD PROXY IS LOCKED! SELECT AINCARD.");
            }
          });
        }, 600);
      } else {
        statusEl.innerHTML = "<span style='color:#ff0033;'>ERR: BAD KEY</span>";
        authBox.style.transform = "translate(-50%, -50%) scale(1.02)";
        setTimeout(
          () => (authBox.style.transform = "translate(-50%, -50%) scale(1)"),
          150
        );
      }
    });
  })();
})();
