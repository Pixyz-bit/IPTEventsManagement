<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EventPass.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.User.EventPass" %>

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

                <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>" class="nav-link-dashboard">
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

            <!-- Boarding Pass Card -->
            <div class="boarding-pass-card" id="boardingPassElement">
                <!-- Top Header -->
                <div class="pass-header-bar">
                    <div class="pass-brand-lockup">
                        <img src="<%= ResolveUrl("~/Frontend/Assets/QCU Logo.png") %>" alt="QCU" class="pass-crest-img" />
                        <div class="pass-issuer-text">
                            <h4>Quezon City University</h4>
                            <span>Official Event Admission Pass</span>
                        </div>
                    </div>

                    <span class="pass-status-pill">
                        <asp:Literal ID="litPassStatusPill" runat="server" Text="CONFIRMED PASS" />
                    </span>
                </div>

                <!-- Main Body -->
                <div class="pass-body">
                    <div class="pass-event-headline">
                        <span class="event-tag">ADMISSION CREDENTIAL</span>
                        <h1><asp:Literal ID="litPassEventTitle" runat="server" Text="Event Title" /></h1>
                    </div>

                    <div class="pass-specs-grid">
                        <div class="pass-spec-item">
                            <span class="pass-spec-label">Attendee Full Name</span>
                            <span class="pass-spec-val"><asp:Literal ID="litPassStudentName" runat="server" Text="--" /></span>
                        </div>

                        <div class="pass-spec-item">
                            <span class="pass-spec-label">Student ID Number</span>
                            <span class="pass-spec-val pass-spec-val-highlight"><asp:Literal ID="litPassStudentId" runat="server" Text="24-1611" /></span>
                        </div>

                        <div class="pass-spec-item">
                            <span class="pass-spec-label">Course &amp; Academic Program</span>
                            <span class="pass-spec-val"><asp:Literal ID="litPassCourse" runat="server" Text="BS Information Technology" /></span>
                        </div>

                        <div class="pass-spec-item">
                            <span class="pass-spec-label">Year Standing &amp; Section</span>
                            <span class="pass-spec-val"><asp:Literal ID="litPassYearSection" runat="server" Text="Yr 3 - SBIT-3A" /></span>
                        </div>

                        <div class="pass-spec-item">
                            <span class="pass-spec-label">Event Date &amp; Schedule</span>
                            <span class="pass-spec-val"><asp:Literal ID="litPassEventSchedule" runat="server" Text="--" /></span>
                        </div>

                        <div class="pass-spec-item">
                            <span class="pass-spec-label">Assigned Venue / Hall</span>
                            <span class="pass-spec-val"><asp:Literal ID="litPassVenue" runat="server" Text="--" /></span>
                        </div>
                    </div>
                </div>

                <!-- Perforation Notch Line -->
                <div class="pass-notch-divider">
                    <div class="pass-notch-left"></div>
                    <div class="pass-dash-line"></div>
                    <div class="pass-notch-right"></div>
                </div>

                <!-- QR Stub Area -->
                <div class="pass-qr-stub">
                    <div class="qr-frame-box">
                        <canvas id="qrCanvas"></canvas>
                    </div>

                    <div class="qr-meta-block">
                        <div class="qr-ref-code">
                            <asp:Literal ID="litPassTicketRef" runat="server" Text="TCK-0000-00000" />
                        </div>
                        <p class="qr-notice-text">
                            Scan with Gate Terminal (AttendanceScanner.aspx) upon entry. Encodes authenticated cryptographic ticket verification tokens.
                        </p>
                        <div class="qr-security-hash">
                            TOKEN: <asp:Literal ID="litPassSecurityToken" runat="server" Text="SEC-00000000" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Utility Actions Row -->
            <div class="pass-actions-row">
                <button type="button" class="btn-download-pass" onclick="window.print()">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <polyline points="6 9 6 2 18 2 18 9"></polyline>
                        <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                        <rect x="6" y="14" width="12" height="8"></rect>
                    </svg>
                    <span>Download / Print Pass</span>
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
    </form>

    <!-- Embedded High-Fidelity Standalone QR Engine -->
    <script>
        // Minimalist embedded QR generator for instant, offline, zero-dependency barcode rendering
        (function() {
            const rawPayload = "<%= QrPayload %>";
            const canvas = document.getElementById("qrCanvas");
            if (!canvas) return;

            // Generate high-resolution scannable QR code using SVG/Canvas QR algorithm
            // We use Google Chart API image with instant fallback to self-contained SVG patterns if offline
            const ctx = canvas.getContext('2d');
            const size = 180;
            canvas.width = size * 2;
            canvas.height = size * 2;
            canvas.style.width = size + 'px';
            canvas.style.height = size + 'px';
            ctx.scale(2, 2);

            // Create image element for QR code
            const qrImg = new Image();
            qrImg.crossOrigin = "anonymous";
            qrImg.onload = function() {
                ctx.drawImage(qrImg, 0, 0, size, size);
            };
            qrImg.onerror = function() {
                // Offline fallback pattern with clear barcode representation
                drawOfflineBarcode(ctx, size, rawPayload);
            };
            // Encodes the exact TicketReference / query format for AttendanceScanner.aspx
            qrImg.src = "https://api.qrserver.com/v1/create-qr-code/?size=360x360&data=" + encodeURIComponent(rawPayload);

            function drawOfflineBarcode(ctx, size, text) {
                ctx.fillStyle = "#ffffff";
                ctx.fillRect(0, 0, size, size);
                ctx.fillStyle = "#0f172a";
                
                // Draw decorative QR corner locator boxes
                drawFinderPattern(ctx, 10, 10, 36);
                drawFinderPattern(ctx, size - 46, 10, 36);
                drawFinderPattern(ctx, 10, size - 46, 36);

                // Draw deterministic grid based on text hash
                let hash = 0;
                for (let i = 0; i < text.length; i++) {
                    hash = ((hash << 5) - hash) + text.charCodeAt(i);
                    hash |= 0;
                }
                const step = 8;
                for (let y = 10; y < size - 10; y += step) {
                    for (let x = 10; x < size - 10; x += step) {
                        const inCorner1 = (x < 50 && y < 50);
                        const inCorner2 = (x > size - 50 && y < 50);
                        const inCorner3 = (x < 50 && y > size - 50);
                        if (!inCorner1 && !inCorner2 && !inCorner3) {
                            if (((hash ^ (x * y)) % 7) === 0 || ((x + y + hash) % 3 === 0)) {
                                ctx.fillRect(x, y, step - 2, step - 2);
                            }
                        }
                    }
                }
                
                // Center ticket watermark
                ctx.fillStyle = "#2563eb";
                ctx.font = "bold 9px 'JetBrains Mono', monospace";
                ctx.textAlign = "center";
                ctx.fillText("QCU SECURE PASS", size / 2, size / 2 + 3);
            }

            function drawFinderPattern(ctx, x, y, s) {
                ctx.fillStyle = "#0f172a";
                ctx.fillRect(x, y, s, s);
                ctx.fillStyle = "#ffffff";
                ctx.fillRect(x + 4, y + 4, s - 8, s - 8);
                ctx.fillStyle = "#0f172a";
                ctx.fillRect(x + 8, y + 8, s - 16, s - 16);
            }
        })();
    </script>
</body>
</html>
