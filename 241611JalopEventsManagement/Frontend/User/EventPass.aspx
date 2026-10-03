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
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/user/event-pass.css") %>?v=<%= DateTime.UtcNow.Ticks %>" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Top Standalone Navigation Bar -->
        <header class="portal-navbar">
            <div class="navbar-inner">
                <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>" class="nav-brand">
                    <img src="<%= ResolveUrl("~/Frontend/Assets/QCU Logo.png") %>" alt="University Emblem" class="nav-logo-img" />
                    <div>
                        <div class="nav-brand-title">University Event Pass</div>
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
                        <!-- Top Row: Brand Lockup -->
                        <div class="ticket-top-row">
                            <div class="ticket-brand-lockup">
                                <img src="<%= ResolveUrl("~/Frontend/Assets/QCU Logo.png") %>" alt="QCU Emblem" class="ticket-crest-img pass-crest-img" />
                                <div class="ticket-issuer-text">
                                    <h4>University Event Pass</h4>
                                    <span>Quezon City University</span>
                                </div>
                            </div>
                        </div>

                        <!-- Middle: Event Details Container (Vertically Centered) -->
                        <div class="ticket-mid-block">
                            <!-- Middle: Event Headline -->
                            <div class="ticket-headline-block">
                                <h1 class="ticket-event-title" id="litPassEventTitle"><asp:Literal ID="litPassEventTitle" runat="server" Text="HACKATHON 2026" /></h1>
                            </div>

                            <!-- Schedule Specs (below ticket-event-title) -->
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
                        </div>

                        <!-- Bottom Row: Student Number (Left) + Student Full Name (Right) Side-by-Side -->
                        <div class="ticket-bottom-row">
                            <div class="ticket-student-number-block">
                                <span class="ticket-meta-label">STUDENT NUMBER</span>
                                <span class="ticket-student-number-val" id="litPassStudentId"><asp:Literal ID="litPassStudentId" runat="server" Text="24-1611" /></span>
                            </div>

                            <div class="ticket-student-name-block">
                                <span class="ticket-meta-label">STUDENT FULL NAME</span>
                                <span class="ticket-student-name-val" id="litPassStudentName"><asp:Literal ID="litPassStudentName" runat="server" Text="ARLAN MARTIN N. JALOP" /></span>
                            </div>
                        </div>
                    </div>

                    <!-- Perforation Notch Line (Horizontal Seam with Left & Right Cutout Notches) -->
                    <div class="ticket-perforation-divider">
                        <div class="ticket-notch-hole ticket-notch-left"></div>
                        <div class="ticket-perforation-dash"></div>
                        <div class="ticket-notch-hole ticket-notch-right"></div>
                    </div>

                    <!-- Bottom Navy Section (QR Stub) -->
                    <div class="ticket-right-stub">
                        <div class="ticket-qr-container">
                            <canvas id="qrCanvas"></canvas>
                            <span class="ticket-stub-ref" id="litPassTicketRef"><asp:Literal ID="litPassTicketRef" runat="server" Text="TCK-2026-00042" /></span>
                            <span class="ticket-stub-instruction">PRESENT THIS PASS AT ENTRANCE SCANNER</span>
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
                    <span>Return to Dashboard</span>
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
         * High-Resolution Event Pass Generator (Vertical Mobile Pass)
         * 1. Primary: html-to-image DOM rasterizer capturing the exact rendered DOM node (#boardingPassElement)
         * 2. Fallback: High-precision 2x Retina canvas generator with exact SVG vector path icons
         */
        async function downloadPassAsPng() {
            const button = document.getElementById("btnDownloadPass");
            if (!button || button.disabled) return;

            button.disabled = true;
            button.setAttribute("aria-busy", "true");

            try {
                if (window.AppToast) AppToast.info('Preparing your event pass...', 'Download Ticket', 2000);

                if (document.fonts) {
                    await document.fonts.ready;
                }

                const crestImg = document.querySelector(".ticket-crest-img");
                if (crestImg && crestImg.decode) {
                    try { await crestImg.decode(); } catch (e) { /* non-blocking */ }
                }

                const node = document.getElementById("boardingPassElement");
                const ticketRef = document.getElementById("litPassTicketRef")?.innerText.trim() || "TCK-PASS";
                const cleanRef = ticketRef.replace(/[^a-zA-Z0-9_-]/g, "");
                const fileName = "EventTicket-" + (cleanRef || "Pass") + ".png";

                let dataUrl = null;

                // 1. Primary High-Fidelity Capture: Directly rasterize the live rendered DOM element
                if (window.htmlToImage && typeof window.htmlToImage.toPng === 'function' && node) {
                    try {
                        dataUrl = await window.htmlToImage.toPng(node, {
                            pixelRatio: 2,
                            cacheBust: true,
                            style: {
                                margin: '0',
                                transform: 'none'
                            }
                        });
                    } catch (domErr) {
                        console.warn("DOM image generator fallback to canvas:", domErr);
                    }
                }

                // 2. High-Precision Vector Canvas Fallback
                if (!dataUrl) {
                    dataUrl = await renderPassToCanvasDataUrl();
                }

                // Trigger direct file download
                const link = document.createElement("a");
                link.download = fileName;
                link.href = dataUrl;
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);

                if (window.AppToast) AppToast.success('Your event pass has been downloaded.', 'Ticket Saved', 3500);
            } catch (err) {
                console.error("Pass download error:", err);
                if (window.AppToast) AppToast.error('Could not download your pass. Please try again.', 'Download Failed');
            } finally {
                button.disabled = false;
                button.removeAttribute("aria-busy");
            }
        }

        async function renderPassToCanvasDataUrl() {
            const studentId = document.getElementById("litPassStudentId")?.innerText.trim() || "24-1611";
            const eventTitle = document.getElementById("litPassEventTitle")?.innerText.trim() || "EVENT PASS";
            const eventDate = document.getElementById("litPassEventDate")?.innerText.trim() || "";
            const eventTime = document.getElementById("litPassEventTime")?.innerText.trim() || "";
            const eventVenue = document.getElementById("litPassVenue")?.innerText.trim() || "";
            const studentName = document.getElementById("litPassStudentName")?.innerText.trim() || "STUDENT NAME";
            const ticketRef = document.getElementById("litPassTicketRef")?.innerText.trim() || "TCK-PASS";
            const qrCanvas = document.getElementById("qrCanvas");
            const crestImg = document.querySelector(".ticket-crest-img");

            const cardWidth = 360;
            const topBodyHeight = 355;
            const bottomStubHeight = 245;
            const cardHeight = topBodyHeight + bottomStubHeight;
            const dpr = 2;

            const canvas = document.createElement("canvas");
            canvas.width = cardWidth * dpr;
            canvas.height = cardHeight * dpr;
            const ctx = canvas.getContext("2d");
            ctx.scale(dpr, dpr);

            // 1. Outer Rounded Card Clip (radius = 20px)
            ctx.save();
            roundRect(ctx, 0, 0, cardWidth, cardHeight, 20);
            ctx.clip();

            // 2. Backgrounds
            ctx.fillStyle = "#FAF8F5";
            ctx.fillRect(0, 0, cardWidth, topBodyHeight);

            ctx.fillStyle = "#0F1E60";
            ctx.fillRect(0, topBodyHeight, cardWidth, bottomStubHeight);

            // 3. Brand Lockup
            const logoSize = 32;
            const logoX = 22;
            const logoY = 24;
            if (crestImg && crestImg.complete && crestImg.naturalWidth > 0) {
                try {
                    ctx.drawImage(crestImg, logoX, logoY, logoSize, logoSize);
                } catch (e) {
                    console.warn("Emblem draw skipped:", e);
                }
            }

            const brandTextX = logoX + logoSize + 8;
            ctx.textAlign = "left";
            ctx.textBaseline = "top";
            ctx.fillStyle = "#0F1E60";
            ctx.font = "800 10.5px 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif";
            ctx.fillText("UNIVERSITY EVENT PASS", brandTextX, logoY + 2);

            ctx.fillStyle = "#3B4A7D";
            ctx.font = "700 8px 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif";
            ctx.fillText("QUEZON CITY UNIVERSITY", brandTextX, logoY + 16);

            // 4. Middle Content Container (Vertically Centered with proper spacing)
            const titleX = 22;
            const titleMaxW = cardWidth - 44;
            ctx.textAlign = "left";
            ctx.textBaseline = "top";
            ctx.fillStyle = "#0F1E60";

            let titleFontSize = 18;
            ctx.font = "800 " + titleFontSize + "px 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif";
            let titleLines = wrapCanvasText(ctx, eventTitle, titleMaxW);
            if (titleLines.length > 2) {
                titleFontSize = 15;
                ctx.font = "800 " + titleFontSize + "px 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif";
                titleLines = wrapCanvasText(ctx, eventTitle, titleMaxW);
            }

            const titleLineHeight = titleFontSize + 5;
            const titleLineCount = Math.min(titleLines.length, 2);
            const titleBlockHeight = titleLineCount * titleLineHeight;
            const titleToSpecsGap = 20; // 1.25rem spacing
            const specsBlockHeight = 58;
            const totalMidHeight = titleBlockHeight + titleToSpecsGap + specsBlockHeight;

            const midAreaTop = logoY + logoSize + 10;
            const dividerY = 252;
            const midAreaBottom = dividerY - 12;
            const availableMidHeight = Math.max(0, midAreaBottom - midAreaTop);
            const midStartY = Math.round(midAreaTop + Math.max(0, (availableMidHeight - totalMidHeight) / 2));

            const titleY = midStartY;
            titleLines.slice(0, 2).forEach((line, idx) => {
                ctx.fillText(line, titleX, titleY + (idx * titleLineHeight));
            });

            // 5. Schedule Specs with Exact SVG Vectors
            const specsStartY = titleY + titleBlockHeight + titleToSpecsGap;
            ctx.fillStyle = "#0F1E60";
            ctx.font = "700 11px 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif";
            ctx.textAlign = "left";
            ctx.textBaseline = "middle";

            const specY1 = specsStartY + 7;
            const specY2 = specY1 + 22;
            const specY3 = specY2 + 22;

            drawCalendarIcon(ctx, 22, specY1 - 7);
            ctx.fillText(eventDate, 44, specY1);

            drawClockIcon(ctx, 22, specY2 - 7);
            ctx.fillText(eventTime, 44, specY2);

            drawPinIcon(ctx, 22, specY3 - 7);
            ctx.fillText(eventVenue, 44, specY3);

            // 6. Divider Line
            ctx.fillStyle = "rgba(15, 30, 96, 0.12)";
            ctx.fillRect(22, dividerY, cardWidth - 44, 1);

            // 7. Bottom Row
            const bottomRowY = dividerY + 14;

            // Left: Student Number
            ctx.textAlign = "left";
            ctx.textBaseline = "top";
            ctx.fillStyle = "#4B5E94";
            ctx.font = "700 9px 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif";
            ctx.fillText("STUDENT NUMBER", 22, bottomRowY);

            ctx.fillStyle = "#0F1E60";
            ctx.font = "800 18px 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif";
            ctx.fillText(studentId, 22, bottomRowY + 15);

            // Right: Student Name
            const nameX = cardWidth - 22;
            ctx.textAlign = "right";
            ctx.textBaseline = "top";
            ctx.fillStyle = "#4B5E94";
            ctx.font = "700 9px 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif";
            ctx.fillText("STUDENT FULL NAME", nameX, bottomRowY);

            let nameFontSize = 14;
            ctx.font = "800 " + nameFontSize + "px 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif";
            let nameLines = wrapCanvasText(ctx, studentName.toUpperCase(), 160);
            if (nameLines.length > 2) {
                nameFontSize = 12.5;
                ctx.font = "800 " + nameFontSize + "px 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif";
                nameLines = wrapCanvasText(ctx, studentName.toUpperCase(), 160);
            }

            const nameLineSpacing = nameFontSize + 2;
            ctx.fillStyle = "#0F1E60";
            ctx.font = "800 " + nameFontSize + "px 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif";
            nameLines.slice(0, 2).forEach((line, idx) => {
                ctx.fillText(line, nameX, bottomRowY + 15 + (idx * nameLineSpacing));
            });

            // 8. Bottom Navy Stub
            const seamY = topBodyHeight;
            const qrSize = 130;
            const qrX = (cardWidth - qrSize) / 2;
            const qrY = seamY + 18;
            if (qrCanvas && qrCanvas.width > 0) {
                ctx.drawImage(qrCanvas, qrX, qrY, qrSize, qrSize);
            }

            ctx.fillStyle = "rgba(255, 255, 255, 0.88)";
            ctx.font = "700 11px 'JetBrains Mono', monospace";
            ctx.textAlign = "center";
            ctx.textBaseline = "top";
            ctx.fillText(ticketRef, cardWidth / 2, qrY + qrSize + 12);

            ctx.fillStyle = "rgba(255, 255, 255, 0.52)";
            ctx.font = "700 7.5px 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif";
            ctx.fillText("PRESENT THIS PASS AT ENTRANCE SCANNER", cardWidth / 2, qrY + qrSize + 30);

            ctx.restore();

            // 9. Horizontal Perforation Seam Cutouts & Dashed Line
            ctx.save();
            ctx.strokeStyle = "rgba(15, 30, 96, 0.22)";
            ctx.lineWidth = 1.5;
            ctx.setLineDash([4, 4]);
            ctx.beginPath();
            ctx.moveTo(16, seamY);
            ctx.lineTo(cardWidth - 16, seamY);
            ctx.stroke();

            ctx.globalCompositeOperation = "destination-out";
            const notchRadius = 13;
            ctx.beginPath();
            ctx.arc(0, seamY, notchRadius, 0, Math.PI * 2);
            ctx.fill();
            ctx.beginPath();
            ctx.arc(cardWidth, seamY, notchRadius, 0, Math.PI * 2);
            ctx.fill();
            ctx.restore();

            return canvas.toDataURL("image/png");
        }

        function roundRect(c, x, y, w, h, r) {
            c.beginPath();
            c.moveTo(x + r, y);
            c.lineTo(x + w - r, y);
            c.quadraticCurveTo(x + w, y, x + w, y + r);
            c.lineTo(x + w, y + h - r);
            c.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
            c.lineTo(x + r, y + h);
            c.quadraticCurveTo(x, y + h, x, y + h - r);
            c.lineTo(x, y + r);
            c.quadraticCurveTo(x, y, x + r, y);
            c.closePath();
        }

        function wrapCanvasText(c, text, maxW) {
            if (!text) return [];
            const words = text.split(/\s+/);
            const lines = [];
            let current = "";
            for (let i = 0; i < words.length; i++) {
                const test = current ? (current + " " + words[i]) : words[i];
                if (c.measureText(test).width <= maxW) {
                    current = test;
                } else {
                    if (current) lines.push(current);
                    current = words[i];
                }
            }
            if (current) lines.push(current);
            return lines;
        }

        function drawCalendarIcon(c, x, y) {
            c.save();
            c.translate(x, y);
            c.scale(14 / 24, 14 / 24);
            c.strokeStyle = "#0F1E60";
            c.lineWidth = 2.2;
            c.lineCap = "round";
            c.lineJoin = "round";
            roundRect(c, 3, 4, 18, 18, 2);
            c.stroke();
            c.beginPath();
            c.moveTo(16, 2); c.lineTo(16, 6);
            c.moveTo(8, 2); c.lineTo(8, 6);
            c.moveTo(3, 10); c.lineTo(21, 10);
            c.stroke();
            c.restore();
        }

        function drawClockIcon(c, x, y) {
            c.save();
            c.translate(x, y);
            c.scale(14 / 24, 14 / 24);
            c.strokeStyle = "#0F1E60";
            c.lineWidth = 2.2;
            c.lineCap = "round";
            c.lineJoin = "round";
            c.beginPath();
            c.arc(12, 12, 10, 0, Math.PI * 2);
            c.moveTo(12, 6); c.lineTo(12, 12);
            c.lineTo(16, 14);
            c.stroke();
            c.restore();
        }

        function drawPinIcon(c, x, y) {
            c.save();
            c.translate(x, y);
            c.scale(14 / 24, 14 / 24);
            c.strokeStyle = "#0F1E60";
            c.lineWidth = 2.2;
            c.lineCap = "round";
            c.lineJoin = "round";
            if (typeof Path2D !== 'undefined') {
                c.stroke(new Path2D("M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"));
            } else {
                c.beginPath();
                c.arc(12, 10, 9, Math.PI * 0.8, Math.PI * 0.2);
                c.lineTo(12, 23);
                c.closePath();
                c.stroke();
            }
            c.beginPath();
            c.arc(12, 10, 3, 0, Math.PI * 2);
            c.stroke();
            c.restore();
        }
    </script>

    <!-- Vendor Libraries -->
    <script type="text/javascript" src="<%= ResolveUrl("~/Frontend/Assets/js/vendor/html-to-image-1.11.13.js") %>"></script>

    <!-- Universal Toast Engine -->
    <script type="text/javascript" src="<%= ResolveUrl("~/Frontend/Assets/js/toast.js") %>"></script>
</body>
</html>
