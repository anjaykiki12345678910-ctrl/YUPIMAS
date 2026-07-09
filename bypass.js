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

    // ─── UI STYLE (TETAP SAMA KAYA TADI) ──────────────────────────
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

      /* ── PROGRESS BAR ULTRA ── */
      .resbob-progress-wrap {
        background: rgba(255, 255, 255, 0.05);
        height: 6px;
        border-radius: 20px;
        overflow: hidden;
        margin: 20px 0 12px 0;
        box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.5);
      }
      .resbob-progress-bar {
        height: 100%;
        width: 0%;
        background: linear-gradient(90deg, #ff0033, #ff3366, #ff0033);
        background-size: 200% 100%;
        border-radius: 20px;
        transition: width 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        box-shadow: 0 0 20px #ff0033;
        animation: neon-pulse-red 1.5s infinite;
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
        font-family: inherit;
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
    `;
    document.head.appendChild(styleEl);

    // ─── MATRIX CANVAS (TETAP) ──────────────────────────────────────
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
      ctx.fillStyle = matrixState === "LOGIN" ? "rgba(10, 10, 10, 0.06)" : "rgba(15, 5, 5, 0.08)";
      ctx.fillRect(0, 0, width, height);
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
        AUTH v2.0
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
        STATUS: WORKING
      </div>
    `;
    document.body.appendChild(authBox);

    const musicBtn    = document.getElementById("resbob-music-btn");
    const keyInput    = document.getElementById("resbob-key-input");
    const loginBtn    = document.getElementById("resbob-login-btn");
    const telegramBtn = document.getElementById("resbob-telegram-btn");
    const statusEl    = document.getElementById("resbob-status");

    // ─── MUSIC (TETAP) ─────────────────────────────────────────────────
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

    // ─── RUN REDIRECT WITH ULTRA PROGRESS BAR ──────────────────────
    function runRedirect(countdownSeconds) {
      matrixState = "BYPASS";
      authBox.remove();

      const overlay = document.createElement("div");
      overlay.id = "resbob-timer-overlay";
      overlay.style.cssText = `
        position:fixed; top:0; left:0; width:100%; height:100%; z-index:2147483645;
        display:flex; align-items:center; justify-content:center; font-family:inherit;
        background:rgba(0,0,0,0.85); backdrop-filter:blur(6px);
      `;
      overlay.innerHTML = `
        <div style="position:relative; z-index:10; text-align:center; width:320px; padding:30px; background:rgba(10,10,10,0.9); border-radius:16px; border:1px solid rgba(255,0,51,0.3); box-shadow:0 0 50px rgba(255,0,51,0.15);">
          <h3 style="color:#ff0033; font-size:18px; letter-spacing:3px; margin-top:0; text-shadow:0 0 10px #ff0033;">BYPASS IN PROGRESS</h3>
          <div class="resbob-progress-wrap">
            <div class="resbob-progress-bar" id="resbob-progress-bar"></div>
          </div>
          <div class="resbob-status-text" id="resbob-status-text">INITIATING...</div>
          <div class="resbob-countdown" id="resbob-countdown-text">${countdownSeconds}s</div>
        </div>
      `;
      document.body.appendChild(overlay);

      const progressBar = document.getElementById("resbob-progress-bar");
      const statusText  = document.getElementById("resbob-status-text");
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
        "FINALIZING..."
      ];

      const timer = setInterval(async () => {
        remaining--;
        const percent = ((total - remaining) / total) * 100;
        progressBar.style.width = Math.min(percent, 100) + "%";
        countdownEl.textContent = remaining + "s";

        const idx = Math.min(Math.floor((total - remaining) / (total / statusMessages.length)), statusMessages.length - 1);
        statusText.textContent = statusMessages[idx] || "PROCESSING...";

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

    // ─── LOGIN LOGIC (DENGAN CHOOSE KEY) ────────────────────────────
    loginBtn.addEventListener("click", () => {
      const inputKey = keyInput.value.trim();
      if (!inputKey) {
        statusEl.innerHTML = "<span style='color:#ff0033;'>ERR: KEY EMPTY</span>";
        return;
      }

      const isValid = VALID_KEYS.some(k => k.toLowerCase() === inputKey.toLowerCase());

      if (isValid) {
        matrixState = "OVERLOAD";
        statusEl.innerHTML = "<span style='color:#ff0033;'>KEY VERIFIED // LOADING</span>";
        loginBtn.disabled = true;
        keyInput.disabled = true;

        setTimeout(() => {
          // ─── CHOOSE KEY UI ──────────────────────────────────────────
          authBox.style.borderColor = "#ff0033";
          authBox.style.boxShadow = "0 0 40px rgba(255,0,51,0.15)";
          authBox.innerHTML = `
            <h3 style="margin:5px 0 2px 0; color:#ff0033; font-size:20px; letter-spacing:2px; font-weight:900; text-shadow:0 0 10px rgba(255,0,51,0.3);">
              CHOOSE KEY
            </h3>
            <p style="margin:0 0 20px 0; color:#666; font-size:10px; letter-spacing:1px;">
              SELECT TARGET
            </p>

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

            <button class="resbob-mode-btn" id="resbob-execute-btn" style="background:#ff0033; color:#000; border:none; padding:14px; border-radius:6px; font-weight:900; cursor:pointer; font-size:12px; letter-spacing:2px; text-transform:uppercase; font-family:inherit; box-shadow:0 0 15px rgba(255,0,51,0.15); transition:all 0.2s ease;">EXECUTE</button>
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
            execBtn.style.background = "#ff0033";
            execBtn.style.color = "#000";
          });

          optResbob.addEventListener("click", () => {
            optResbob.classList.add("active");
            optAincard.classList.remove("active");
            selected = "FAKE";
            execBtn.disabled = true;
            execBtn.style.opacity = "0.4";
            execBtn.textContent = "LOCKED";
            execBtn.style.background = "#333";
            execBtn.style.color = "#888";
          });

          execBtn.addEventListener("click", () => {
            if (selected === "AINCARD") {
              // ─── SHOW MODE SELECT (FAST / SECURE / SAFE) ────────────
              authBox.innerHTML = `
                <h3 style="margin:5px 0 2px 0; color:#ff0033; font-size:20px; letter-spacing:2px; font-weight:900; text-shadow:0 0 10px rgba(255,0,51,0.3);">
                  SELECT MODE
                </h3>
                <p style="margin:0 0 20px 0; color:#666; font-size:10px; letter-spacing:1px;">
                  BYPASS LEVEL
                </p>
                <button class="resbob-mode-btn" id="resbob-btn-fast" style="border-color:#ff3366; color:#ff3366;">FAST (30s)</button>
                <button class="resbob-mode-btn" id="resbob-btn-secure" style="border-color:#ff0033; color:#ff0033;">SECURE (45s)</button>
                <button class="resbob-mode-btn" id="resbob-btn-safe" style="border-color:#cc0033; color:#cc0033;">SAFE (60s)</button>
              `;
              document.getElementById("resbob-btn-fast").addEventListener("click", () => runRedirect(30));
              document.getElementById("resbob-btn-secure").addEventListener("click", () => runRedirect(45));
              document.getElementById("resbob-btn-safe").addEventListener("click", () => runRedirect(60));
            } else {
              alert("❌ @RESBOB IS LOCKED! SELECT AINCARD.");
            }
          });
        }, 800);
      } else {
        statusEl.innerHTML = "<span style='color:#ff0033;'>ERR: BAD KEY</span>";
        authBox.style.transform = "translate(-50%, -50%) scale(1.02)";
        setTimeout(() => authBox.style.transform = "translate(-50%, -50%) scale(1)", 150);
      }
    });
  })();
})();
