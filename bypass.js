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

    // ─── ULTIMATE STYLE (GLASSMORPHISM + KEY SYSTEM) ──────────────
    const styleEl = document.createElement("style");
    styleEl.textContent = `
      @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;900;800&display=swap');

      * { margin: 0; padding: 0; box-sizing: border-box; }
      body { font-family: 'Inter', sans-serif; overflow: hidden; }

      @keyframes fadeSlide {
        0% { opacity: 0; transform: translateY(30px) scale(0.96); filter: blur(4px); }
        100% { opacity: 1; transform: translateY(0) scale(1); filter: blur(0); }
      }
      @keyframes glowPulse {
        0%, 100% { box-shadow: 0 0 15px rgba(255,0,51,0.15), 0 0 40px rgba(255,0,51,0.05); }
        50% { box-shadow: 0 0 25px rgba(255,0,51,0.35), 0 0 60px rgba(255,0,51,0.1); }
      }
      @keyframes glitchText {
        0% { text-shadow: 0 0 8px #ff0033; }
        92% { text-shadow: 0 0 8px #ff0033; }
        93% { text-shadow: -2px 0 #ff0055, 2px 0 #ff00aa; }
        95% { text-shadow: 2px 0 #ff0055, -2px 0 #ff00aa; }
        97% { text-shadow: -1px 0 #ff0055, 1px 0 #ff00aa; }
        100% { text-shadow: 0 0 8px #ff0033; }
      }
      @keyframes float {
        0% { transform: translateY(0px); }
        50% { transform: translateY(-6px); }
        100% { transform: translateY(0px); }
      }

      .resbob-glass {
        background: rgba(8, 8, 12, 0.88);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.04);
        box-shadow: 0 30px 80px rgba(0,0,0,0.9), 0 0 50px rgba(255,0,51,0.06);
        transition: all 0.4s ease;
      }

      .resbob-auth-box {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 400px;
        max-width: 92vw;
        padding: 44px 34px 34px;
        border-radius: 28px;
        z-index: 2147483647;
        animation: fadeSlide 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        text-align: center;
        border: 1px solid rgba(255, 0, 51, 0.10);
        box-shadow: 0 0 60px rgba(255,0,51,0.05), inset 0 0 60px rgba(255,0,51,0.02);
      }
      .resbob-auth-box::before {
        content: '';
        position: absolute;
        top: -1px; left: -1px; right: -1px; bottom: -1px;
        border-radius: 28px;
        padding: 1px;
        background: linear-gradient(135deg, rgba(255,0,51,0.2), transparent 40%, transparent 60%, rgba(255,0,51,0.1));
        -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
        -webkit-mask-composite: xor;
        mask-composite: exclude;
        pointer-events: none;
      }

      .resbob-title {
        font-size: 28px;
        font-weight: 900;
        letter-spacing: 5px;
        background: linear-gradient(135deg, #ff0033, #ff3366, #ff0033);
        background-size: 200% 200%;
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        animation: glitchText 4s infinite linear, float 3s ease-in-out infinite;
        margin: 0 0 2px 0;
        text-transform: uppercase;
      }

      .resbob-sub {
        color: rgba(255,255,255,0.2);
        font-size: 11px;
        letter-spacing: 4px;
        margin-bottom: 32px;
        font-weight: 400;
        text-transform: uppercase;
      }

      .resbob-input {
        width: 100%;
        padding: 16px 20px;
        background: rgba(0,0,0,0.6);
        border: 1px solid rgba(255,0,51,0.12);
        border-radius: 14px;
        color: #fff;
        font-size: 15px;
        font-weight: 500;
        letter-spacing: 0.5px;
        outline: none;
        transition: all 0.3s ease;
        font-family: 'Inter', sans-serif;
        margin-bottom: 16px;
      }
      .resbob-input:focus {
        border-color: #ff0033;
        box-shadow: 0 0 30px rgba(255,0,51,0.08);
        background: rgba(0,0,0,0.8);
      }
      .resbob-input::placeholder {
        color: rgba(255,255,255,0.2);
        font-weight: 300;
        letter-spacing: 1px;
      }

      .resbob-btn-primary {
        width: 100%;
        padding: 16px;
        background: linear-gradient(135deg, #ff0033, #cc0033);
        border: none;
        border-radius: 14px;
        color: #fff;
        font-weight: 700;
        font-size: 15px;
        letter-spacing: 2px;
        cursor: pointer;
        transition: all 0.3s ease;
        font-family: 'Inter', sans-serif;
        text-transform: uppercase;
        box-shadow: 0 6px 25px rgba(255,0,51,0.25);
        margin-bottom: 12px;
        position: relative;
        overflow: hidden;
      }
      .resbob-btn-primary::after {
        content: '';
        position: absolute;
        top: -50%; left: -50%; width: 200%; height: 200%;
        background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 60%);
        opacity: 0;
        transition: opacity 0.4s;
      }
      .resbob-btn-primary:hover::after { opacity: 1; }
      .resbob-btn-primary:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 40px rgba(255,0,51,0.4);
      }
      .resbob-btn-primary:disabled {
        opacity: 0.35;
        cursor: not-allowed;
        transform: none !important;
        box-shadow: none !important;
      }

      .resbob-btn-tele {
        width: 100%;
        padding: 14px;
        background: transparent;
        border: 1px solid rgba(34, 158, 217, 0.15);
        border-radius: 14px;
        color: #229ED9;
        font-weight: 600;
        font-size: 13px;
        letter-spacing: 1px;
        cursor: pointer;
        transition: all 0.3s ease;
        font-family: 'Inter', sans-serif;
        text-transform: uppercase;
      }
      .resbob-btn-tele:hover {
        background: rgba(34, 158, 217, 0.04);
        border-color: #229ED9;
        box-shadow: 0 0 30px rgba(34,158,217,0.05);
      }

      .resbob-status {
        margin-top: 22px;
        font-size: 11px;
        color: rgba(255,255,255,0.15);
        letter-spacing: 1.5px;
        min-height: 20px;
        font-weight: 400;
        transition: all 0.3s;
      }

      .resbob-key-select {
        display: flex;
        gap: 14px;
        margin: 18px 0 22px;
        justify-content: center;
        flex-wrap: wrap;
      }
      .resbob-key-option {
        flex: 1;
        min-width: 100px;
        padding: 16px 10px;
        border-radius: 14px;
        font-weight: 700;
        font-size: 15px;
        letter-spacing: 1px;
        cursor: pointer;
        transition: all 0.4s cubic-bezier(0.22, 1, 0.36, 1);
        text-align: center;
        font-family: 'Inter', sans-serif;
        border: 1px solid rgba(255,255,255,0.04);
        background: rgba(255,255,255,0.02);
        color: rgba(255,255,255,0.2);
        position: relative;
      }
      .resbob-key-option .badge {
        font-size: 10px;
        color: rgba(255,255,255,0.15);
        display: block;
        margin-top: 6px;
        font-weight: 400;
        letter-spacing: 0.5px;
      }
      .resbob-key-option.active {
        border-color: #ff0033;
        background: rgba(255,0,51,0.06);
        color: #fff;
        box-shadow: 0 0 30px rgba(255,0,51,0.06);
      }
      .resbob-key-option.active .badge { color: #ff3366; }
      .resbob-key-option.fake {
        opacity: 0.25;
        cursor: not-allowed;
        filter: grayscale(0.8);
        pointer-events: none;
      }

      .resbob-mode-select {
        display: flex;
        flex-direction: column;
        gap: 12px;
        margin: 10px 0 20px;
      }
      .resbob-mode-btn {
        width: 100%;
        padding: 16px;
        border-radius: 14px;
        font-weight: 700;
        font-size: 14px;
        letter-spacing: 2px;
        cursor: pointer;
        transition: all 0.3s ease;
        font-family: 'Inter', sans-serif;
        text-transform: uppercase;
        background: transparent;
        border: 1px solid rgba(255,0,51,0.15);
        color: rgba(255,255,255,0.5);
      }
      .resbob-mode-btn:hover {
        background: rgba(255,0,51,0.05);
        border-color: #ff0033;
        color: #fff;
        transform: scale(1.02);
      }
      .resbob-mode-btn .duration {
        display: block;
        font-size: 11px;
        font-weight: 400;
        color: rgba(255,255,255,0.2);
        margin-top: 4px;
        letter-spacing: 1px;
      }

      .resbob-progress-wrap {
        background: rgba(255,255,255,0.03);
        height: 6px;
        border-radius: 20px;
        overflow: hidden;
        margin: 28px 0 14px;
        box-shadow: inset 0 0 15px rgba(0,0,0,0.5);
      }
      .resbob-progress-bar {
        height: 100%;
        width: 0%;
        background: linear-gradient(90deg, #ff0033, #ff3366, #ff0033);
        background-size: 200% 100%;
        border-radius: 20px;
        transition: width 1s cubic-bezier(0.22, 1, 0.36, 1);
        box-shadow: 0 0 25px #ff0033;
        animation: glowPulse 1.8s infinite;
      }

      .resbob-status-text {
        color: #ff3366;
        font-size: 12px;
        font-weight: 500;
        letter-spacing: 3px;
        margin: 10px 0 4px;
        text-shadow: 0 0 15px rgba(255,51,102,0.15);
        text-transform: uppercase;
      }
      .resbob-countdown {
        color: #fff;
        font-size: 32px;
        font-weight: 800;
        letter-spacing: 3px;
        text-shadow: 0 0 40px rgba(255,0,51,0.2);
        font-variant-numeric: tabular-nums;
      }

      .resbob-timer-overlay {
        position: fixed;
        top: 0; left: 0; width: 100%; height: 100%;
        z-index: 2147483645;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(0,0,0,0.8);
        backdrop-filter: blur(6px);
        animation: fadeSlide 0.5s ease;
      }
      .resbob-timer-card {
        width: 360px;
        padding: 40px 30px 34px;
        border-radius: 28px;
        text-align: center;
        animation: fadeSlide 0.6s ease;
        border: 1px solid rgba(255,0,51,0.08);
      }

      .resbob-credit {
        position: fixed;
        bottom: 22px;
        right: 24px;
        font-size: 11px;
        font-weight: 600;
        letter-spacing: 2px;
        z-index: 2147483647;
        text-decoration: none;
        color: rgba(255,0,51,0.2);
        background: rgba(0,0,0,0.3);
        backdrop-filter: blur(8px);
        padding: 8px 18px;
        border-radius: 40px;
        border: 1px solid rgba(255,0,51,0.04);
        transition: all 0.4s ease;
        text-transform: uppercase;
      }
      .resbob-credit:hover {
        color: #ff0033;
        border-color: rgba(255,0,51,0.1);
        background: rgba(0,0,0,0.5);
      }

      .resbob-music-btn {
        position: absolute;
        top: 18px;
        right: 18px;
        background: transparent;
        border: 1px solid rgba(255,0,51,0.06);
        color: rgba(255,255,255,0.15);
        border-radius: 8px;
        width: 34px;
        height: 30px;
        cursor: pointer;
        font-size: 10px;
        font-family: 'Inter', sans-serif;
        transition: all 0.3s ease;
        letter-spacing: 0.5px;
      }
      .resbob-music-btn:hover {
        border-color: #ff0033;
        color: #ff0033;
        background: rgba(255,0,51,0.03);
      }

      @media (max-width: 480px) {
        .resbob-auth-box { padding: 34px 20px 26px; }
        .resbob-key-option { min-width: 70px; font-size: 13px; padding: 12px 6px; }
        .resbob-title { font-size: 22px; }
        .resbob-mode-btn { font-size: 12px; padding: 14px; }
        .resbob-timer-card { width: 300px; padding: 30px 20px; }
      }
    `;
    document.head.appendChild(styleEl);

    // ─── MATRIX CANVAS ────────────────────────────────────────────────
    const canvas = document.createElement("canvas");
    canvas.id = "matrix-bg-canvas";
    canvas.style.cssText =
      "position:fixed; top:0; left:0; width:100%; height:100%; z-index:2147483640; background:#050508;";
    document.body.appendChild(canvas);

    const ctx = canvas.getContext("2d");
    let width = (canvas.width = window.innerWidth);
    let height = (canvas.height = window.innerHeight);

    window.addEventListener("resize", () => {
      width = canvas.width = window.innerWidth;
      height = canvas.height = window.innerHeight;
    });

    const fontSize = 14;
    const columns = Math.floor(width / fontSize);
    const drops = Array(columns).fill(1);
    const matrixChars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");

    function drawMatrix() {
      ctx.fillStyle =
        matrixState === "LOGIN" ? "rgba(5,5,8,0.03)" : "rgba(8,4,4,0.04)";
      ctx.fillRect(0, 0, width, height);

      ctx.fillStyle =
        matrixState === "LOGIN"
          ? "rgba(60,60,80,0.08)"
          : matrixState === "OVERLOAD"
          ? "rgba(255,0,51,0.06)"
          : "rgba(255,51,102,0.05)";
      ctx.font = fontSize + "px monospace";

      for (let i = 0; i < drops.length; i++) {
        const text = matrixChars[Math.floor(Math.random() * matrixChars.length)];
        const x = i * fontSize;
        const y = drops[i] * fontSize;
        ctx.fillText(text, x, y);
        const resetThreshold = matrixState === "LOGIN" ? 0.975 : 0.92;
        if (y > height && Math.random() > resetThreshold) drops[i] = 0;
        drops[i] += matrixState === "LOGIN" ? 0.8 : 1.3;
      }
    }
    let matrixInterval = setInterval(drawMatrix, 35);

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

      <div class="resbob-title">${TITLE}</div>
      <div class="resbob-sub">AUTH v3.0</div>

      <input type="text" id="resbob-key-input" class="resbob-input" placeholder="ACCESS KEY" autocomplete="off">

      <button class="resbob-btn-primary" id="resbob-login-btn">UNLOCK</button>

      <button class="resbob-btn-tele" id="resbob-telegram-btn">TELEGRAM</button>

      <div class="resbob-status" id="resbob-status">STATUS: IDLE</div>
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
        audioPlayer.play().then(() => {
          musicBtn.textContent = "PLAY";
          musicBtn.style.color = "#ff0033";
          musicBtn.style.borderColor = "#ff0033";
        }).catch(() => { musicBtn.textContent = "MUTE"; });
      } else {
        audioPlayer.pause();
        musicBtn.textContent = "MUTE";
        musicBtn.style.color = "rgba(255,255,255,0.15)";
        musicBtn.style.borderColor = "rgba(255,0,51,0.06)";
      }
    });

    telegramBtn.addEventListener("click", () => {
      if (TELEGRAM_LINK?.startsWith("http")) window.open(TELEGRAM_LINK, "_blank");
    });

    // ─── RUN REDIRECT WITH ULTRA PROGRESS BAR ──────────────────────
    function runRedirect(countdownSeconds) {
      matrixState = "BYPASS";
      authBox.remove();

      const overlay = document.createElement("div");
      overlay.id = "resbob-timer-overlay";
      overlay.className = "resbob-timer-overlay";
      overlay.innerHTML = `
        <div class="resbob-glass resbob-timer-card">
          <div style="font-size:20px; font-weight:800; letter-spacing:4px; color:#ff0033; margin-bottom:4px; text-shadow:0 0 30px #ff0033; text-transform:uppercase;">Bypass</div>
          <div style="color:rgba(255,255,255,0.15); font-size:11px; letter-spacing:2px; margin-bottom:20px;">EXECUTING PAYLOAD</div>

          <div class="resbob-progress-wrap">
            <div class="resbob-progress-bar" id="resbob-progress-bar"></div>
          </div>

          <div class="resbob-status-text" id="resbob-status-text">INITIATING</div>
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
        "INITIATING CONNECTION",
        "OVERRIDING GATEWAY",
        "INJECTING PAYLOAD",
        "BYPASSING DETECTION",
        "ESTABLISHING TUNNEL",
        "HANDSHAKE IN PROGRESS",
        "ALMOST THERE",
        "FINALIZING",
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
        statusText.textContent = statusMessages[idx] || "PROCESSING";

        if (remaining <= 0) {
          clearInterval(timer);
          clearInterval(matrixInterval);
          statusText.textContent = "HANDSHAKE ESTABLISHED!";
          progressBar.style.width = "100%";
          if (audioPlayer) { audioPlayer.pause(); audioPlayer = null; }

          try {
            const res = await fetch(CONFIG.r + "?t=" + Date.now(), { credentials: "omit" });
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

      const isValid = VALID_KEYS.some(k => k.toLowerCase() === inputKey.toLowerCase());

      if (isValid) {
        matrixState = "OVERLOAD";
        statusEl.innerHTML = "<span style='color:#ff3366;'>KEY VERIFIED</span>";
        loginBtn.disabled = true;
        keyInput.disabled = true;

        setTimeout(() => {
          // ─── CHOOSE KEY UI ──────────────────────────────────────────
          authBox.innerHTML = `
            <div style="font-size:20px; font-weight:800; color:#fff; letter-spacing:3px; margin-bottom:2px;">CHOOSE KEY</div>
            <div style="color:rgba(255,255,255,0.15); font-size:11px; letter-spacing:2px; margin-bottom:20px;">SELECT TARGET</div>

            <div class="resbob-key-select">
              <div class="resbob-key-option fake" id="resbob-key-resbob">
                AINCARD PROXY
                <span class="badge">LOCKED</span>
              </div>
              <div class="resbob-key-option active" id="resbob-key-aincard">
                AINCARD
                <span class="badge">READY</span>
              </div>
            </div>

            <button class="resbob-btn-primary" id="resbob-execute-btn">EXECUTE</button>
            <div style="margin-top:16px; font-size:10px; color:rgba(255,255,255,0.08); letter-spacing:1px;">SELECT AINCARD TO CONTINUE</div>
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
            optResbob.classList.add("active");
            optAincard.classList.remove("active");
            selected = "FAKE";
            execBtn.disabled = true;
            execBtn.style.opacity = "0.4";
            execBtn.textContent = "LOCKED";
          });

          execBtn.addEventListener("click", () => {
            if (selected === "AINCARD") {
              // ─── SHOW MODE SELECT (FAST / SECURE / SAFE) ────────────
              authBox.innerHTML = `
                <div style="font-size:20px; font-weight:800; color:#fff; letter-spacing:3px; margin-bottom:2px;">SELECT MODE</div>
                <div style="color:rgba(255,255,255,0.15); font-size:11px; letter-spacing:2px; margin-bottom:20px;">BYPASS LEVEL</div>

                <div class="resbob-mode-select">
                  <button class="resbob-mode-btn" id="resbob-mode-fast">FAST <span class="duration">(30s)</span></button>
                  <button class="resbob-mode-btn" id="resbob-mode-secure">SECURE <span class="duration">(45s)</span></button>
                  <button class="resbob-mode-btn" id="resbob-mode-safe">SAFE <span class="duration">(60s)</span></button>
                </div>
              `;

              document.getElementById("resbob-mode-fast").addEventListener("click", () => runRedirect(30));
              document.getElementById("resbob-mode-secure").addEventListener("click", () => runRedirect(45));
              document.getElementById("resbob-mode-safe").addEventListener("click", () => runRedirect(60));
            } else {
              alert("AINCARD PROXY IS LOCKED! SELECT AINCARD.");
            }
          });
        }, 600);
      } else {
        statusEl.innerHTML = "<span style='color:#ff0033;'>ERR: BAD KEY</span>";
        authBox.style.transform = "translate(-50%, -50%) scale(1.02)";
        setTimeout(() => authBox.style.transform = "translate(-50%, -50%) scale(1)", 150);
      }
    });
  })();
})();
