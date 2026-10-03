<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EventPass.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.User.EventPass" EnableSessionState="ReadOnly" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Digital Event Pass &amp; QR Attendance Credential | QCU</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/global.css") %>" />
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/toast.css") %>" />
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/user/event-pass.css") %>" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Top Standalone Navigation Bar -->
        <header class="portal-navbar">
            <div class="navbar-inner">
                <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>" class="nav-brand">
                    <img src="<%= ResolveUrl("~/Frontend/Assets/QCU Logo.png") %>" alt="University Emblem" class="nav-logo-img" />
                    <div>
                        <div class="nav-brand-title">University Event Portal</div>
                        <div class="nav-brand-subtitle">Quezon City University</div>
                    </div>
                </a>

                <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>" class="nav-link-dashboard" aria-label="My Dashboard">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                    <span>My Dashboard</span>
                </a>
            </div>
        </header>

        <!-- Pass Container Workspace -->
        <main class="pass-container">
            <!-- Registration Success Banner -->
            <asp:Panel ID="pnlSuccessBanner" runat="server" CssClass="success-status-banner">
                <div class="success-icon-badge">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                </div>
                <div class="success-banner-text">
                    <h3>You're Registered!</h3>
                    <p>Your electronic admission pass is active. Present this digital pass at the entrance gate scanner.</p>
                </div>
            </asp:Panel>

            <!-- Boarding Pass Card / Digital Event Ticket Template -->
            <div class="ticket-scroll-container">
                <div class="boarding-pass-card" id="boardingPassElement">
                    <!-- Left Ivory Section -->
                    <div class="ticket-left-body">
                        <!-- Top Row: Logo & Portal Title (Left) + Student Number (Right) -->
                        <div class="ticket-top-row">
                            <div class="ticket-brand-lockup">
                                <img src="<%= ResolveUrl("~/Frontend/Assets/QCU Logo.png") %>" alt="QCU Emblem" class="ticket-crest-img pass-crest-img" />
                                <div class="ticket-issuer-text">
                                    <h4>University Event Portal</h4>
                                    <span>Quezon City University</span>
                                </div>
                            </div>

                            <div class="ticket-student-number-block">
                                <span class="ticket-meta-label">STUDENT NUMBER</span>
                                <span class="ticket-student-number-val" id="litPassStudentId"><asp:Literal ID="litPassStudentId" runat="server" Text="24-1611" /></span>
                            </div>
                        </div>

                        <!-- Middle: Event Headline -->
                        <div class="ticket-headline-block">
                            <h1 class="ticket-event-title" id="litPassEventTitle"><asp:Literal ID="litPassEventTitle" runat="server" Text="HACKATHON 2026" /></h1>
                        </div>

                        <!-- Bottom Row: Event Schedule Specs (Left) + Student Full Name (Right) -->
                        <div class="ticket-bottom-row">
                            <div class="ticket-schedule-specs">
                                <div class="ticket-spec-line">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                    <span id="litPassEventDate"><asp:Literal ID="litPassEventDate" runat="server" Text="Oct 09, 2026" /></span>
                                </div>

                                <div class="ticket-spec-line">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                    <span id="litPassEventTime"><asp:Literal ID="litPassEventTime" runat="server" Text="10:00 AM - 03:00 PM" /></span>
                                </div>

                                <div class="ticket-spec-line">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                        <circle cx="12" cy="10" r="3"></circle>
                                    </svg>
                                    <span id="litPassVenue"><asp:Literal ID="litPassVenue" runat="server" Text="QCU Auditorium" /></span>
                                </div>
                            </div>

                            <div class="ticket-student-name-block">
                                <span class="ticket-meta-label">STUDENT FULL NAME</span>
                                <span class="ticket-student-name-val" id="litPassStudentName"><asp:Literal ID="litPassStudentName" runat="server" Text="ARLAN MARTIN N. JALOP" /></span>
                            </div>
                        </div>
                    </div>

                    <!-- Perforation Notch Line (6 Circular Cutouts) -->
                    <div class="ticket-perforation-divider">
                        <div class="ticket-notch-hole ticket-notch-top"></div>
                        <div class="ticket-notch-hole"></div>
                        <div class="ticket-notch-hole"></div>
                        <div class="ticket-notch-hole"></div>
                        <div class="ticket-notch-hole"></div>
                        <div class="ticket-notch-hole ticket-notch-bottom"></div>
                    </div>

                    <!-- Right Navy Section (QR Stub) -->
                    <div class="ticket-right-stub">
                        <div class="ticket-qr-container">
                            <canvas id="qrCanvas"></canvas>
                            <span class="ticket-stub-ref" id="litPassTicketRef"><asp:Literal ID="litPassTicketRef" runat="server" Text="TCK-2026-00042" /></span>
                        </div>
                    </div>

                    <!-- Hidden legacy server controls preserved for backward compatibility -->
                    <asp:Literal ID="litPassCourse" runat="server" Visible="false" />
                    <asp:Literal ID="litPassYearSection" runat="server" Visible="false" />
                    <asp:Literal ID="litPassSecurityToken" runat="server" Visible="false" />
                    <asp:Literal ID="litPassStatusPill" runat="server" Visible="false" />
                </div>
            </div>

            <!-- Utility Actions Row -->
            <div class="pass-actions-row">
                <button type="button" class="btn-download-pass" id="btnDownloadPass" onclick="downloadPassAsPng();">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                        <polyline points="7 10 12 15 17 10"></polyline>
                        <line x1="12" y1="15" x2="12" y2="3"></line>
                    </svg>
                    <span>Download Pass (PNG)</span>
                </button>

                <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>" class="btn-return-dashboard">
                    <span>Return to My Events Dashboard</span>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                        <polyline points="12 5 19 12 12 19"></polyline>
                    </svg>
                </a>
            </div>
        </main>

        <!-- Enterprise Floating Lower-Right Toast Container -->
        <div id="appToastContainer" class="app-toast-container" aria-live="polite" aria-atomic="true"></div>
    </form>

    <!-- Embedded High-Fidelity Standalone QR Engine (White on Navy) -->
    <script>
        (function() {
            const rawPayload = "<%= QrPayload %>";
            const canvas = document.getElementById("qrCanvas");
            if (!canvas) return;

            const ctx = canvas.getContext('2d');
            const size = 190;
            canvas.width = size * 2;
            canvas.height = size * 2;
            ctx.scale(2, 2);

            // Draw crisp white QR code on navy background
            const qrImg = new Image();
            qrImg.crossOrigin = "anonymous";
            qrImg.onload = function() {
                ctx.fillStyle = "#0F1E60";
                ctx.fillRect(0, 0, size, size);
                ctx.drawImage(qrImg, 0, 0, size, size);
            };
            qrImg.onerror = function() {
                drawWhiteOnNavyQr(ctx, size, rawPayload);
            };
            qrImg.src = "https://api.qrserver.com/v1/create-qr-code/?size=380x380&color=ffffff&bgcolor=0f1e60&data=" + encodeURIComponent(rawPayload);

            // Draw initial offline fallback immediately so canvas is never blank
            drawWhiteOnNavyQr(ctx, size, rawPayload);

            function drawWhiteOnNavyQr(ctx, size, text) {
                ctx.fillStyle = "#0F1E60";
                ctx.fillRect(0, 0, size, size);

                ctx.fillStyle = "#FFFFFF";

                // Locator Corners
                drawWhiteFinder(ctx, 12, 12, 38);
                drawWhiteFinder(ctx, size - 50, 12, 38);
                drawWhiteFinder(ctx, 12, size - 50, 38);

                // Deterministic grid
                let hash = 0;
                for (let i = 0; i < text.length; i++) {
                    hash = ((hash << 5) - hash) + text.charCodeAt(i);
                    hash |= 0;
                }
                const step = 8;
                for (let y = 12; y < size - 12; y += step) {
                    for (let x = 12; x < size - 12; x += step) {
                        const inCorner1 = (x < 56 && y < 56);
                        const inCorner2 = (x > size - 56 && y < 56);
                        const inCorner3 = (x < 56 && y > size - 56);
                        if (!inCorner1 && !inCorner2 && !inCorner3) {
                            if (((hash ^ (x * y)) % 7) === 0 || ((x + y + hash) % 3 === 0)) {
                                ctx.fillRect(x, y, step - 2, step - 2);
                            }
                        }
                    }
                }
            }

            function drawWhiteFinder(ctx, x, y, s) {
                ctx.fillStyle = "#FFFFFF";
                ctx.fillRect(x, y, s, s);
                ctx.fillStyle = "#0F1E60";
                ctx.fillRect(x + 5, y + 5, s - 10, s - 10);
                ctx.fillStyle = "#FFFFFF";
                ctx.fillRect(x + 9, y + 9, s - 18, s - 18);
            }
        })();

        /**
         * Render and Download Boarding Pass Ticket as PNG
         * Uses a full-resolution landscape layout with room for long details.
         */
        async function downloadPassAsPng() {
            try {
                if (window.AppToast) {
                    AppToast.info('Rendering digital event ticket PNG...', 'Download Ticket', 2500);
                }

                const cardEl = document.getElementById("boardingPassElement");
                if (!cardEl) return;

                if (document.fonts) await document.fonts.ready;

                // Canonical ticket dimensions matching user template
                const cardWidth = 960;
                const scale = 2;

                const canvas = document.createElement("canvas");
                const ctx = canvas.getContext("2d");
                const eventTitle = document.getElementById("litPassEventTitle")?.innerText.trim() || "Campus Event";
                const studentName = document.getElementById("litPassStudentName")?.innerText.trim() || "Student";
                const eventDate = document.getElementById("litPassEventDate")?.innerText.trim() || "TBD";
                const eventTime = document.getElementById("litPassEventTime")?.innerText.trim() || "TBD";
                const eventVenue = document.getElementById("litPassVenue")?.innerText.trim() || "TBD";

                // Measure each field before allocating the export canvas. Growing
                // the ticket keeps long titles, names, and venues fully readable.
                function textLines(text, font, maxWidth) {
                    ctx.font = font;
                    ctx.letterSpacing = "0px";
                    const lines = [];
                    let line = "";
                    for (const word of text.split(/\s+/)) {
                        const candidate = line ? line + " " + word : word;
                        if (ctx.measureText(candidate).width <= maxWidth) {
                            line = candidate;
                            continue;
                        }
                        if (line) lines.push(line);
                        line = "";
                        for (const character of word) {
                            if (line && ctx.measureText(line + character).width > maxWidth) {
                                lines.push(line);
                                line = "";
                            }
                            line += character;
                        }
                    }
                    if (line) lines.push(line);
                    return lines;
                }

                const titleFont = "800 30px 'Plus Jakarta Sans', sans-serif";
                const nameFont = "800 20px 'Plus Jakarta Sans', sans-serif";
                const specFont = "700 13px 'Plus Jakarta Sans', sans-serif";
                const titleLines = textLines(eventTitle.toUpperCase(), titleFont, 586);
                const nameLines = textLines(studentName.toUpperCase(), nameFont, 252);
                const scheduleLines = [eventDate, eventTime, eventVenue].map(text => textLines(text, specFont, 260));
                const specY = 120 + titleLines.length * 38 + 30;
                const scheduleHeight = scheduleLines.reduce((height, lines) => height + lines.length * 19 + 8, 0);
                const cardHeight = Math.max(340, specY + Math.max(scheduleHeight, 22 + nameLines.length * 26) + 32);
                canvas.width = cardWidth * scale;
                canvas.height = cardHeight * scale;

                ctx.scale(scale, scale);
                ctx.imageSmoothingEnabled = true;
                ctx.imageSmoothingQuality = "high";

                function roundedRect(c, x, y, width, height, radius) {
                    c.beginPath();
                    c.moveTo(x + radius, y);
                    c.lineTo(x + width - radius, y);
                    c.arcTo(x + width, y, x + width, y + radius, radius);
                    c.lineTo(x + width, y + height - radius);
                    c.arcTo(x + width, y + height, x + width - radius, y + height, radius);
                    c.lineTo(x + radius, y + height);
                    c.arcTo(x, y + height, x, y + height - radius, radius);
                    c.lineTo(x, y + radius);
                    c.arcTo(x, y, x + radius, y, radius);
                    c.closePath();
                }

                // 1. Clip outer rounded bounds (r=20px)
                roundedRect(ctx, 0, 0, cardWidth, cardHeight, 20);
                ctx.save();
                ctx.clip();

                // 2. Left Ivory Section
                const leftWidth = 650;
                ctx.fillStyle = "#FAF8F5";
                ctx.fillRect(0, 0, leftWidth, cardHeight);

                // 3. Right Navy Section
                const rightWidth = cardWidth - leftWidth;
                ctx.fillStyle = "#0F1E60";
                ctx.fillRect(leftWidth, 0, rightWidth, cardHeight);

                // 4. Draw Left Section Content
                // Crest Logo
                const crestImg = cardEl.querySelector(".pass-crest-img");
                const logoSize = 44;
                const logoX = 32;
                const logoY = 26;
                if (crestImg && crestImg.complete && crestImg.naturalWidth > 0) {
                    try {
                        ctx.drawImage(crestImg, logoX, logoY, logoSize, logoSize);
                    } catch (e) {
                        console.warn("Logo draw skipped:", e);
                    }
                }

                // Portal Branding
                const textX = logoX + logoSize + 12;
                ctx.fillStyle = "#0F1E60";
                ctx.font = "800 17px 'Plus Jakarta Sans', sans-serif";
                ctx.letterSpacing = "-0.2px";
                ctx.textAlign = "left";
                ctx.textBaseline = "top";
                ctx.fillText("UNIVERSITY EVENT PORTAL", textX, logoY + 4);

                ctx.fillStyle = "#3B4A7D";
                ctx.font = "700 11px 'Plus Jakarta Sans', sans-serif";
                ctx.letterSpacing = "0.8px";
                ctx.fillText("QUEZON CITY UNIVERSITY", textX, logoY + 26);

                // Student Number (Top Right of Left Section)
                const snX = leftWidth - 36;
                ctx.textAlign = "right";
                ctx.textBaseline = "top";
                ctx.fillStyle = "#4B5E94";
                ctx.font = "700 10.5px 'Plus Jakarta Sans', sans-serif";
                ctx.letterSpacing = "0.8px";
                ctx.fillText("STUDENT NUMBER", snX, logoY + 4);

                const studentId = document.getElementById("litPassStudentId")?.innerText.trim() || "24-1611";
                ctx.fillStyle = "#0F1E60";
                ctx.font = "800 24px 'Plus Jakarta Sans', sans-serif";
                ctx.letterSpacing = "-0.5px";
                ctx.fillText(studentId, snX, logoY + 20, 180);

                // Event Title (Center)
                ctx.textAlign = "left";
                ctx.textBaseline = "top";
                ctx.fillStyle = "#0F1E60";
                ctx.font = titleFont;
                ctx.letterSpacing = "0px";
                titleLines.forEach((line, index) => ctx.fillText(line, logoX, 120 + index * 38));

                // Bottom Left Schedule Specs
                ctx.font = specFont;
                ctx.letterSpacing = "0px";
                ctx.fillStyle = "#0F1E60";
                ctx.textAlign = "left";
                ctx.textBaseline = "top";

                ctx.fillStyle = "rgba(15, 30, 96, 0.12)";
                ctx.fillRect(logoX, specY - 16, 586, 1);
                ctx.fillStyle = "#0F1E60";
                let scheduleY = specY;
                const icons = [drawCalendarIcon, drawClockIcon, drawPinIcon];
                scheduleLines.forEach((lines, index) => {
                    icons[index](ctx, logoX, scheduleY);
                    lines.forEach((line, lineIndex) => ctx.fillText(line, logoX + 26, scheduleY + lineIndex * 19));
                    scheduleY += lines.length * 19 + 8;
                });

                // Student Full Name (Bottom Right of Left Section)
                ctx.textAlign = "right";
                ctx.textBaseline = "top";
                ctx.fillStyle = "#4B5E94";
                ctx.font = "700 10.5px 'Plus Jakarta Sans', sans-serif";
                ctx.letterSpacing = "0.8px";
                ctx.fillText("STUDENT FULL NAME", snX, specY);

                ctx.fillStyle = "#0F1E60";
                ctx.font = nameFont;
                ctx.letterSpacing = "0px";
                nameLines.forEach((line, index) => ctx.fillText(line, snX, specY + 22 + index * 26));

                // 5. Draw Right Stub (White QR Code on Navy)
                const srcQrCanvas = document.getElementById("qrCanvas");
                if (srcQrCanvas) {
                    const qrSize = 200;
                    const qrX = leftWidth + Math.round((rightWidth - qrSize) / 2);
                    const qrY = Math.round((cardHeight - qrSize) / 2);
                    ctx.drawImage(srcQrCanvas, qrX, qrY, qrSize, qrSize);
                }

                // Ticket Ref code under QR
                const refCode = document.getElementById("litPassTicketRef")?.innerText.trim() || "TCK-2026-00042";
                ctx.fillStyle = "rgba(255, 255, 255, 0.75)";
                ctx.font = "700 11px 'JetBrains Mono', monospace";
                ctx.textAlign = "center";
                ctx.textBaseline = "top";
                ctx.fillText(refCode, leftWidth + (rightWidth / 2), cardHeight - 30);

                ctx.restore(); // Restore outer rounded clip

                // 6. Cut Out the 6 Circular Notches along the seam (x = leftWidth)
                ctx.save();
                ctx.globalCompositeOperation = "destination-out";
                const seamX = leftWidth;
                const notchR = 12;

                const notchPositions = Array.from({ length: 6 }, (_, index) => index * cardHeight / 5);
                for (let i = 0; i < notchPositions.length; i++) {
                    ctx.beginPath();
                    ctx.arc(seamX, notchPositions[i], notchR, 0, Math.PI * 2);
                    ctx.fill();
                }
                ctx.restore();

                // 7. Generate PNG and Download
                const pngDataUrl = canvas.toDataURL("image/png");
                const cleanRef = refCode.replace(/[^a-zA-Z0-9_-]/g, "");
                const filename = "EventTicket-" + (cleanRef || "Pass") + ".png";

                const downloadLink = document.createElement("a");
                downloadLink.download = filename;
                downloadLink.href = pngDataUrl;
                document.body.appendChild(downloadLink);
                downloadLink.click();
                document.body.removeChild(downloadLink);

                if (window.AppToast) {
                    AppToast.success('Digital event ticket PNG downloaded successfully.', 'Ticket Saved', 3500);
                }
            } catch (err) {
                console.error("Pass PNG Generation Error:", err);
                if (window.AppToast) {
                    AppToast.error('Could not generate ticket PNG: ' + err.message, 'Download Failed');
                }
            }

            function drawCalendarIcon(c, x, y) {
                c.save();
                c.strokeStyle = "#0F1E60";
                c.lineWidth = 1.8;
                c.strokeRect(x, y + 3, 16, 14);
                c.beginPath();
                c.moveTo(x + 4, y); c.lineTo(x + 4, y + 4);
                c.moveTo(x + 12, y); c.lineTo(x + 12, y + 4);
                c.moveTo(x, y + 8); c.lineTo(x + 16, y + 8);
                c.stroke();
                c.restore();
            }

            function drawClockIcon(c, x, y) {
                c.save();
                c.strokeStyle = "#0F1E60";
                c.lineWidth = 1.8;
                c.beginPath();
                c.arc(x + 8, y + 8, 7.5, 0, Math.PI * 2);
                c.moveTo(x + 8, y + 4); c.lineTo(x + 8, y + 8);
                c.lineTo(x + 12, y + 8);
                c.stroke();
                c.restore();
            }

            function drawPinIcon(c, x, y) {
                c.save();
                c.strokeStyle = "#0F1E60";
                c.lineWidth = 1.8;
                c.beginPath();
                c.arc(x + 8, y + 6, 4.5, 0, Math.PI * 2);
                c.moveTo(x + 8, y + 10.5); c.lineTo(x + 8, y + 16);
                c.stroke();
                c.restore();
            }
        }
    </script>

    <!-- Universal Toast Engine -->
    <script type="text/javascript" src="<%= ResolveUrl("~/Frontend/Assets/js/toast.js") %>"></script>
</body>
</html>
