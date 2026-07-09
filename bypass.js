(function () {
  "use strict";

  // ─── DECODER ──────────────────────────────────────────────────────────────────
  const _decode = (str) => atob(str);

  // ─── ENCRYPTED CONFIG (BASE64) ──────────────────────────────────────────────
  const CONFIG = {
    // old endpoints tetap, gak diutak-atik
    r: _decode("aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2Rib2ZjaGwvYnlwYXNzL21haW4vYnlwYXNzLnR4dA=="), 
    t: _decode("aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2Rib2ZjaGwvYnlwYXNzL21haW4vY2gudHh0"),
    m: _decode("aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY39tL3Zhbnotd2Vic2l0ZS9WYW56QnlwYXNzL21haW4vbXVzaWMubXAz"),
  };

  // ─── TELEGRAM LINK ENCRYPTED ──────────────────────────────────────────────
  const TELEGRAM_LINK = _decode("aHR0cHM6Ly90Lm1lL3l1cGltYXM=");  // https://t.me/yupimas
  const VALID_KEYS = ["resbob"];  // default key, bisa diganti

  // ─── GLOBAL STATE ──────────────────────────────────────────────────────────
  let audioPlayer = null;
  let matrixState = "LOGIN"; // LOGIN, OVERLOAD, BYPASS
  const TITLE = "RESBOB BYPASS";
  const FALLBACK_MUSIC_URL = _decode("aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY39tL3Zhbnotd2Vic2l0ZS9WYW56QnlwYXNzL21haW4vbXVzaWMubXAz");

  // ─── MAIN EXECUTION ──────────────────────────────────────────────────────
  (async function () {
    // Bersihkan elemen lama
    document.getElementById("matrix-bg-canvas")?.remove();
    document.getElementById("resbob-auth-box")?.remove();
    document.getElementById("resbob-floating-credit")?.remove();

    // ── INJECT STYLE ──────────────────────────────────────────────────────
    const styleEl = document.createElement("style");
    styleEl.textContent = `
      @keyframes neon-pulse-red {
        0%, 100% { border-color: rgba(255, 0, 51, 0.3); box-shadow: 0 0 8px rgba(255, 0, 51, 0.15); }
        50% { border-color: rgba(255, 0, 51, 0.9); box-shadow: 0 0 20px rgba(255, 0, 51, 0.3); }
      }
      @keyframes text-glitch-red {
        0% { text-shadow: 0 0 6px #ff0033; }
        95% { text-shadow: 0 0 6px #ff0033; }
        96% { text-shadow: -1px 0 #ff0055, 1px 0 #ff00aa; }
        98% { text-shadow: 1px 0 #ff0055, -1px 0 #ff00aa; }
        100% { text-shadow: 0 0 6px #ff0033; }
      }
      @keyframes spin-clockwise { 0% { transform: translate(-50%,-50%) rotate(0deg); } 100% { transform: translate(-50%,-50%) rotate(360deg); } }
      @keyframes spin-counter { 0% { transform: translate(-50%,-50%) rotate(360deg); } 100% { transform: translate(-50%,-50%) rotate(0deg); } }
      
      .resbob-input-glow { animation: neon-pulse-red 3s infinite ease-in-out; }
      .resbob-title-anim { animation: text-glitch-red 4s infinite linear; }
      
      .resbob-mode-btn {
        width: 100%; border: 1px solid #ff0033; padding: 12px; border-radius: 6px;
        font-weight: 700; cursor: pointer; font-size: 12px; letter-spacing: 2px;
        margin-bottom: 12px; color: #ff0033; background: rgba(255, 0, 51, 0.03);
        transition: all 0.3s ease; text-transform: uppercase; font-family: inherit;
      }
      .resbob-mode-btn:hover {
        background: #ff0033; color: #000; box-shadow: 0 0 15px rgba(255, 0, 51, 0.25);
        transform: scale(1.02);
      }
      .resbob-credit {
        position:fixed; bottom:15px; right:20px; font-size:11px; font-weight:bold;
        letter-spacing:1px; z-index:2147483647; text-decoration:none;
        color:#ff0033; text-shadow:0 0 4px rgba(255,0,51,0.4);
        background:rgba(0,0,0,0.5); padding:4px 10px; border-radius:20px;
        backdrop-filter:blur(4px);
      }
    `;
    document.head.appendChild(styleEl);

    // ── MATRIX CANVAS (DARK BACKGROUND) ──────────────────────────────────
    const canvas = document.createElement("canvas");
    canvas.id = "matrix-bg-canvas";
    canvas.style.cssText = "position:fixed; top:0; left:0; width:100%; height:100%; z-index:2147483640; background:#0a0a0a;";
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
    const matrixChars = "01ABCDEFGHIJKLMNOPQRSTUVWXYZｦｱｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃ".split("");

    function drawMatrix() {
      // Background trail
      ctx.fillStyle = matrixState === "LOGIN" ? "rgba(10, 10, 10, 0.06)" : "rgba(15, 5, 5, 0.08)";
      ctx.fillRect(0, 0, width, height);

      // Warna karakter: merah saat state tertentu, abu-abu saat login
      ctx.fillStyle = matrixState === "LOGIN" ? "#4a4a4a" : (matrixState === "OVERLOAD" ? "#ff0033" : "#ff3366");
      ctx.font = fontSize + "px monospace";

      for (let i = 0; i < drops.length; i++) {
        const text = matrixChars[Math.floor(Math.random() * matrixChars.length)];
        ctx.fillText(text, i * fontSize, drops[i] * fontSize);

        const resetThreshold = matrixState === "LOGIN" ? 0.975 : 0.93;
        if (drops[i] * fontSize > height && Math.random() * 1 > resetThreshold) {
          drops[i] = 0;
        }
        drops[i] += matrixState === "LOGIN" ? 1 : 1.8;
      }
    }
    let matrixInterval = setInterval(drawMatrix, 33);

    // ── FLOATING CREDIT ──────────────────────────────────────────────────
    const creditLink = document.createElement("a");
    creditLink.id = "resbob-floating-credit";
    creditLink.className = "resbob-credit";
    creditLink.innerText = `// ${TITLE}`;
    creditLink.href = TELEGRAM_LINK;
    creditLink.target = "_blank";
    document.body.appendChild(creditLink);

    // ── AUTH BOX ──────────────────────────────────────────────────────────
    const authBox = document.createElement("div");
    authBox.id = "resbob-auth-box";
    authBox.style.cssText = `
      position:fixed; top:50%; left:50%; transform:translate(-50%,-50%);
      background:rgba(10, 10, 10, 0.9); backdrop-filter:blur(12px);
      -webkit-backdrop-filter:blur(12px);
      color:#fff; padding:35px 25px; border-radius:12px; z-index:2147483647;
      font-family: 'Courier New', Courier, monospace;
      text-align:center; box-shadow:0 0 50px rgba(255, 0, 51, 0.1), inset 0 0 20px rgba(255, 0, 51, 0.02);
      border:1px solid rgba(255, 0, 51, 0.2); width:340px; box-sizing:border-box;
      transition: all 0.4s ease;
    `;
    authBox.innerHTML = `
      <button id="resbob-music-btn" style="
        position:absolute; top:15px; right:15px; background:transparent;
        border:1px solid rgba(255,0,51,0.2); color:#ff0033; border-radius:4px;
        width:32px; height:24px; cursor:pointer; font-size:10px; font-family:inherit;
      ">MUTE</button>

      <h3 class="resbob-title-anim" style="
        margin:10px 0 2px 0; color:#ff0033; font-size:24px; letter-spacing:2px;
        font-weight:900; text-transform:uppercase; text-shadow:0 0 8px rgba(255,0,51,0.3);
      ">${TITLE}</h3>
      <p style="margin:0 0 30px 0; color:#666; font-size:10px; letter-spacing:1px;">
        AUTH_v2.0
      </p>

      <input type="text" id="resbob-key-input" class="resbob-input-glow" placeholder="[ ACCESS KEY ]" style="
        width:100%; padding:14px; margin-bottom:18px;
        border:1px solid rgba(255,0,51,0.2); border-radius:6px;
        background:rgba(0,0,0,0.9); color:#ff0033; text-align:center;
        box-sizing:border-box; font-size:13px; font-weight:600; font-family:inherit;
        letter-spacing:2px; outline:none; transition:all 0.3s;
      ">

      <button id="resbob-login-btn" style="
        width:100%; background:#ff0033; color:#000; border:none; padding:14px;
        border-radius:6px; font-weight:900; cursor:pointer; font-size:12px;
        letter-spacing:2px; margin-bottom:12px; font-family:inherit;
        box-shadow:0 0 15px rgba(255,0,51,0.15); transition:all 0.2s ease;
      ">UNLOCK</button>

      <button id="resbob-telegram-btn" style="
        width:100%; background:transparent; color:#ff0033; border:1px solid #ff0033;
        padding:12px; border-radius:6px; font-weight:700; cursor:pointer;
        font-size:11px; letter-spacing:2px; font-family:inherit; transition:all 0.3s;
      ">TELEGRAM</button>

      <div id="resbob-status" style="margin-top:25px; font-size:10px; color:#555; letter-spacing:1px;">
        STATUS: IDLE
      </div>
    `;
    document.body.appendChild(authBox);

    // ── DOM REFS ──────────────────────────────────────────────────────────
    const musicBtn    = document.getElementById("resbob-music-btn");
    const keyInput    = document.getElementById("resbob-key-input");
    const loginBtn    = document.getElementById("resbob-login-btn");
    const telegramBtn = document.getElementById("resbob-telegram-btn");
    const statusEl    = document.getElementById("resbob-status");

    // ── MUSIC ─────────────────────────────────────────────────────────────
    let musicLoading = false;
    musicBtn.addEventListener("click", async () => {
      if (musicLoading) return;
      if (!audioPlayer) {
        musicLoading = true;
        musicBtn.textContent = "...";
        let resolvedUrl = FALLBACK_MUSIC_URL;
        try {
          const res = await fetch(CONFIG.m + "?t=" + Date.now(), { credentials: "omit", mode: "cors" });
          const audioUrl = (await res.text()).trim();
          if (audioUrl && audioUrl.startsWith("http")) resolvedUrl = audioUrl;
        } catch (err) { console.log(err); }
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
        musicBtn.style.color = "#555";
        musicBtn.style.borderColor = "rgba(255,0,51,0.15)";
      }
    });

    telegramBtn.addEventListener("click", () => {
      if (TELEGRAM_LINK?.startsWith("http")) window.open(TELEGRAM_LINK, "_blank");
    });

    // ── REDIRECT WITH TIMER ──────────────────────────────────────────────
    function runRedirect(countdownSeconds) {
      matrixState = "BYPASS";
      authBox.remove();

      const DASH_TOTAL = 597;
      const overlay = document.createElement("div");
      overlay.id = "resbob-timer-overlay";
      overlay.style.cssText = `
        position:fixed; top:0; left:0; width:100%; height:100%; z-index:2147483645;
        display:flex; align-items:center; justify-content:center; font-family:inherit;
        background:rgba(0,0,0,0.7);
      `;
      overlay.innerHTML = `
        <div style="position:relative; z-index:10; text-align:center;">
          <div style="position:relative; width:260px; height:260px; margin:0 auto; display:flex; align-items:center; justify-content:center;">
            <div style="position:absolute; top:50%; left:50%; width:230px; height:230px; border-radius:50%;
                        background:conic-gradient(transparent 0deg, #ff0033 180deg, transparent 360deg);
                        filter:blur(20px); opacity:0.3; animation:spin-clockwise 3s linear infinite;"></div>
            <div style="position:absolute; top:50%; left:50%; width:215px; height:215px; border-radius:50%;
                        border:2px dashed rgba(255,0,51,0.15); animation:spin-counter 8s linear infinite;"></div>
            <svg width="250" height="250" style="transform:rotate(-90deg); position:relative;">
              <circle cx="125" cy="125" r="95" fill="rgba(10,10,10,0.9)" stroke="rgba(255,0,51,0.05)" stroke-width="12"></circle>
              <circle id="resbob-progress" cx="125" cy="125" r="95" fill="none" stroke="#ff0033" stroke-width="8"
                      stroke-dasharray="${DASH_TOTAL}" stroke-dashoffset="${DASH_TOTAL}" stroke-linecap="round"
                      style="filter:drop-shadow(0 0 8px #ff0033); transition:stroke-dashoffset 1s linear;"></circle>
            </svg>
            <div id="resbob-countdown" style="position:absolute; top:50%; left:50%; transform:translate(-50%,-50%);
                        font-size:58px; font-weight:900; color:#fff; text-shadow:0 0 20px #ff0033;">${countdownSeconds}</div>
          </div>
          <p id="resbob-hud" style="margin-top:35px; color:#ff0033; font-size:12px; font-weight:bold; letter-spacing:4px;
                     text-shadow:0 0 10px rgba(255,0,51,0.3); text-transform:uppercase;">INITIATING_BYPASS...</p>
        </div>
      `;
      document.body.appendChild(overlay);

      let remaining = countdownSeconds;
      const progressCircle = document.getElementById("resbob-progress");
      const countdownText  = document.getElementById("resbob-countdown");
      const hudStatus      = document.getElementById("resbob-hud");

      const logs = ["OVERRIDING_GATEWAY...", "INJECTING_PAYLOAD...", "BYPASS_SUCCESS_REDIRECTING..."];

      const timer = setInterval(async () => {
        remaining--;
        if (countdownText) countdownText.textContent = remaining;
        if (progressCircle) progressCircle.style.strokeDashoffset = DASH_TOTAL * (remaining / countdownSeconds);

        if (hudStatus && remaining % 8 === 0 && remaining > 0) {
          hudStatus.textContent = logs[Math.floor(Math.random() * logs.length)];
        }

        if (remaining <= 0) {
          clearInterval(timer);
          clearInterval(matrixInterval);
          if (hudStatus) hudStatus.textContent = "HANDSHAKE_ESTABLISHED!";
          if (audioPlayer) { audioPlayer.pause(); audioPlayer = null; }

          try {
            const res = await fetch(CONFIG.r + "?t=" + Date.now(), { credentials: "omit" });
            const redirectUrl = (await res.text()).trim();
            document.getElementById("matrix-bg-canvas")?.remove();
            overlay.remove();
            if (redirectUrl.startsWith("http")) {
              window.location.replace(redirectUrl);
            } else {
              alert("CRITICAL_ERR: TARGET NOT FOUND");
            }
          } catch {
            alert("NETWORK_TIMEOUT: REDIRECT FAILED");
          }
        }
      }, 1000);
    }

    // ── LOGIN LOGIC ──────────────────────────────────────────────────────
    loginBtn.addEventListener("click", () => {
      const inputKey = keyInput.value.trim();
      if (!inputKey) {
        statusEl.innerHTML = "<span style='color:#ff0033;'>ERR: KEY_EMPTY</span>";
        return;
      }

      const isValid = VALID_KEYS.some(k => k.toLowerCase() === inputKey.toLowerCase());

      if (isValid) {
        matrixState = "OVERLOAD";
        statusEl.innerHTML = "<span style='color:#ff0033;'>KEY_VERIFIED // LOADING</span>";
        loginBtn.disabled = true;
        keyInput.disabled = true;

        setTimeout(() => {
          authBox.style.borderColor = "#ff0033";
          authBox.style.boxShadow = "0 0 40px rgba(255,0,51,0.15)";
          authBox.innerHTML = `
            <h3 style="margin:5px 0 2px 0; color:#ff0033; font-size:20px; letter-spacing:2px; font-weight:900; text-shadow:0 0 10px rgba(255,0,51,0.3);">
              SELECT_MODE
            </h3>
            <p style="margin:0 0 25px 0; color:#666; font-size:10px; letter-spacing:1px;">
              BYPASS_LEVEL
            </p>
            <button id="resbob-btn-fast"   class="resbob-mode-btn" style="border-color:#ff3366; color:#ff3366;">FAST (30s)</button>
            <button id="resbob-btn-secure" class="resbob-mode-btn" style="border-color:#ff0033; color:#ff0033;">SECURE (45s)</button>
            <button id="resbob-btn-safe"   class="resbob-mode-btn" style="border-color:#cc0033; color:#cc0033;">SAFE (60s)</button>
          `;
          document.getElementById("resbob-btn-fast")?.addEventListener("click",   () => runRedirect(30));
          document.getElementById("resbob-btn-secure")?.addEventListener("click", () => runRedirect(45));
          document.getElementById("resbob-btn-safe")?.addEventListener("click",   () => runRedirect(60));
        }, 800);

      } else {
        statusEl.innerHTML = "<span style='color:#ff0033;'>ERR: BAD_KEY</span>";
        authBox.style.transform = "translate(-50%, -50%) scale(1.02)";
        setTimeout(() => authBox.style.transform = "translate(-50%, -50%) scale(1)", 150);
      }
    });

  })();
})();
