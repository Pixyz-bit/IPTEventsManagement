<%@ Page Title="Event Attendance Scanner" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AttendanceScanner.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.AttendanceScanner" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Event Attendance Scanner & Gate Terminal | QCU Event Management
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Optical QR Decoding Library -->
    <script src="https://unpkg.com/html5-qrcode@2.3.8/html5-qrcode.min.js"></script>

    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/attendance-scanner.css") %>?v=<%= DateTime.UtcNow.Ticks %>" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="scanner-container">

    <!-- Breadcrumb Global Trail -->
    <nav class="breadcrumb-nav" aria-label="Breadcrumb">
        <ol class="breadcrumb-list">
            <li class="breadcrumb-item">
                <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="3" width="7" height="7" rx="1.5"></rect>
                        <rect x="14" y="3" width="7" height="7" rx="1.5"></rect>
                        <rect x="14" y="14" width="7" height="7" rx="1.5"></rect>
                        <rect x="3" y="14" width="7" height="7" rx="1.5"></rect>
                    </svg>
                    <span>Admin Console</span>
                </a>
            </li>
            <li class="breadcrumb-separator">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </li>
            <li class="breadcrumb-item">
                <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>">
                    <span>Campus Events Matrix</span>
                </a>
            </li>
            <li class="breadcrumb-separator">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                <span>Gate Attendance Scanner</span>
            </li>
        </ol>
    </nav>

    <!-- Context Header Banner -->
    <div class="event-context-card">
        <div class="event-context-top">
            <div class="event-title-group">
                <h1>
                    <asp:Literal ID="litEventTitle" runat="server" Text="Select an Event"></asp:Literal>
                </h1>
                <div class="event-meta-chips">
                    <span class="meta-chip">
                        <span>Date: <strong><asp:Literal ID="litEventDate" runat="server" Text="--/--/----"></asp:Literal></strong></span>
                    </span>
                    <span class="meta-chip">
                        <span>Venue: <strong><asp:Literal ID="litEventVenue" runat="server" Text="--"></asp:Literal></strong></span>
                    </span>
                    <span class="meta-chip">
                        <span>Capacity: <strong><asp:Literal ID="litEventCapacitySummary" runat="server" Text="0 / 0"></asp:Literal></strong></span>
                    </span>
                </div>
            </div>

            <!-- Event Selector Switcher -->
            <div class="event-switcher">
                <label for="<%= ddlEvents.ClientID %>">Active Event:</label>
                <asp:DropDownList ID="ddlEvents" runat="server" CssClass="event-dropdown-select" AutoPostBack="true" OnSelectedIndexChanged="ddlEvents_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
        </div>

        <!-- Sub-Module Pipeline Progression Tabs -->
        <div class="pipeline-tabs-wrapper">
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventDetails.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <span>Event Details</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventPreRegistered.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <span>Pre-Registered</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/AttendanceScanner.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item active">
                <span>Attendance Scanner</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventAttendance.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <span>Event Attendance</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventAnalytics.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <span>Event Analytics</span>
            </a>
        </div>
    </div>

    <!-- Hidden State Holders for Legacy References -->
    <asp:PlaceHolder ID="phGateMetricsHidden" runat="server" Visible="false">
        <span id="kpiVerifiedCount"><asp:Literal ID="litCheckedInCount" runat="server" Text="0"></asp:Literal></span>
        <span id="kpiExpectedCount"><asp:Literal ID="litExpectedCount" runat="server" Text="0"></asp:Literal></span>
        <span id="kpiTurnoutRate"><asp:Literal ID="litTurnoutRate" runat="server" Text="0.0%"></asp:Literal></span>
        <asp:Literal ID="litCurrentAdminEmail" runat="server" Text="admin@gmail.com"></asp:Literal>
    </asp:PlaceHolder>

    <!-- Main Operational Terminal Grid: Viewfinder vs Staging Area -->
    <div class="terminal-grid">

        <!-- Left Column: Optical Viewfinder Stream & Manual Fallback Console -->
        <div class="viewfinder-column">
            
            <!-- Camera Viewfinder Card -->
            <div class="viewfinder-card">
                <div class="card-header-bar">
                    <div class="card-header-title">
                        <span>QR Code Scanner</span>
                    </div>
                    <div style="display:flex; align-items:center; gap:0.85rem;">
                        <select id="cameraDeviceSelect" class="camera-select-control" onchange="changeCameraDevice()">
                            <option value="">Scanner is Off</option>
                        </select>
                        <div class="camera-toggle-group">
                            <span id="lblCameraToggleText" class="camera-toggle-title">Scanner OFF</span>
                            <button type="button" id="btnToggleCamera" class="btn-scanner-toggle is-inactive" onclick="toggleCameraPower()" role="switch" aria-checked="false" title="Toggle Optical Scanner Stream">
                                <span class="toggle-thumb"></span>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="camera-viewport-wrapper" id="cameraViewportContainer">
                    <div id="qr-reader"></div>

                    <!-- Holographic Target Overlay -->
                    <div class="scanner-hud-overlay" style="display:none;">
                        <div class="scanner-hud-reticle">
                            <div class="scanner-laser-line"></div>
                            <div class="hud-corner hud-tl"></div>
                            <div class="hud-corner hud-tr"></div>
                            <div class="hud-corner hud-bl"></div>
                            <div class="hud-corner hud-br"></div>
                        </div>
                        <div class="scanner-hud-hint">Align attendee digital or physical QR pass in viewfinder</div>
                    </div>

                    <!-- Suspended/Paused Overlay when toggled OFF -->
                    <div id="scannerOffOverlay" class="scanner-paused-overlay">
                        <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" stroke-width="2">
                            <line x1="1" y1="1" x2="23" y2="23"></line>
                            <path d="M21 21H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h3m3-3h6l2 3h4a2 2 0 0 1 2 2v9.34"></path>
                            <circle cx="12" cy="13" r="4"></circle>
                        </svg>
                        <span style="font-weight:700; font-size:0.95rem; color:#f1f5f9; margin-top:0.5rem;">Optical Scanner Suspended</span>
                        <span style="font-size:0.75rem; color:#94a3b8;">Scanner stream is toggled OFF. Click toggle switch to turn ON or use manual lookup.</span>
                    </div>

                    <!-- Visual Flash Confirmation Overlay -->
                    <div id="scannerFlashOverlay" class="scanner-flash-feedback"></div>
                </div>
            </div>

            <!-- Manual Fallback Console -->
            <div class="manual-console-card">
                <div class="manual-console-title">
                    <span>Manual Fallback Console</span>
                </div>
                <div class="manual-input-row">
                    <input type="text" id="txtManualInput" class="manual-input-box" 
                           placeholder="Enter Student ID (e.g. 2024-00101) or Ticket Ref (e.g. TCK-0001-00005)..." 
                           onkeydown="handleManualInputKeydown(event)" />
                    <button type="button" class="btn-manual-stage" onclick="stageManualLookup()">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                        <span>Stage Lookup</span>
                    </button>
                </div>
                <div style="font-size:0.75rem; color:var(--text-muted);">
                    Use when a physical ticket is torn/unreadable or the camera stream is unavailable.
                </div>
            </div>

        </div>

        <!-- Right Column: Auto-Populating Verification Panel (Staging Area) -->
        <div class="staging-card">
            <div class="staging-header-bar">
                <div class="staging-title">
                    <span>Verification Panel (Staging Area)</span>
                </div>
                <div id="stagingStatusBadge" class="staging-status-badge badge-awaiting">
                    <span>AWAITING SCAN</span>
                </div>
            </div>

            <!-- Staging Notification Banner -->
            <div class="staging-body">
                <div id="stagingAlertBanner" class="staging-alert-banner banner-idle">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    <span id="stagingAlertMessage">Ready for attendee. Scan QR pass or perform manual lookup to inspect profile.</span>
                </div>

                <!-- Attendee Staged Profile Details -->
                <div class="staged-attendee-card">
                    <div class="attendee-avatar-lg" id="stagedAvatarInitials">--</div>
                    <div class="attendee-title-meta">
                        <h3 id="stagedFullName">Awaiting Attendee Scan</h3>
                        <span class="ticket-ref-display" id="stagedTicketRef">TCK-0000-00000</span>
                    </div>
                </div>

                <!-- Read-Only Inspection Grid -->
                <div class="staging-fields-grid">
                    <div class="stage-field-item">
                        <span class="stage-field-label">Student ID</span>
                        <span class="stage-field-value" id="stagedStudentId">--</span>
                    </div>
                    <div class="stage-field-item">
                        <span class="stage-field-label">Campus Branch</span>
                        <span class="stage-field-value" id="stagedBranch">--</span>
                    </div>
                    <div class="stage-field-item" style="grid-column: span 2;">
                        <span class="stage-field-label">Institutional Email</span>
                        <span class="stage-field-value" id="stagedEmail">--</span>
                    </div>
                    <div class="stage-field-item" style="grid-column: span 2;">
                        <span class="stage-field-label">Academic Department</span>
                        <span class="stage-field-value" id="stagedDepartment">--</span>
                    </div>
                    <div class="stage-field-item" style="grid-column: span 2;">
                        <span class="stage-field-label">Program / Course</span>
                        <span class="stage-field-value" id="stagedCourse">--</span>
                    </div>
                    <div class="stage-field-item">
                        <span class="stage-field-label">Year Level & Section</span>
                        <span class="stage-field-value" id="stagedYearSection">--</span>
                    </div>
                    <div class="stage-field-item">
                        <span class="stage-field-label">Registration State</span>
                        <span class="stage-field-value" id="stagedRegistrationState">--</span>
                    </div>
                </div>
            </div>

            <!-- Operator Confirmation Controls (Mandatory Inspection Gate: No Auto Check-In) -->
            <div class="staging-actions-container">
                <button type="button" id="btnConfirmCheckIn" class="btn-confirm-checkin" disabled onclick="executeCheckInCommit()">
                    <span>CONFIRM</span>
                </button>

                <button type="button" id="btnDiscardStaging" class="btn-discard-staging" onclick="discardStagedAttendee()">
                    <span>DISCARD</span>
                </button>
            </div>
        </div>

    </div>

    <!-- Live Checked-In Attendance Roster is displayed on EventAttendance.aspx per requirement -->

</div>

<script type="text/javascript">
    // Current Operational State
    const activeEventId = <%= CurrentEventId %>;
    const currentAdminUser = "<%= CurrentAdminEmail %>";
    let stagedData = null;
    let isProcessingScan = false;
    let html5QrScanner = null;
    let currentVerificationMethod = "Optical QR Scan";

    // =========================================================================
    // Web Audio API Synthesizer (Zero External Dependencies)
    // =========================================================================
    let audioCtx = null;
    function getAudioContext() {
        if (!audioCtx) {
            audioCtx = new (window.AudioContext || window.webkitAudioContext)();
        }
        if (audioCtx.state === 'suspended') {
            audioCtx.resume();
        }
        return audioCtx;
    }

    function playScanBeep() {
        try {
            const ctx = getAudioContext();
            const osc = ctx.createOscillator();
            const gain = ctx.createGain();
            osc.type = 'sine';
            osc.frequency.setValueAtTime(880, ctx.currentTime);
            gain.gain.setValueAtTime(0.12, ctx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.12);
            osc.connect(gain);
            gain.connect(ctx.destination);
            osc.start();
            osc.stop(ctx.currentTime + 0.12);
        } catch (e) { console.warn("Audio feedback error:", e); }
    }

    function playSuccessChime() {
        try {
            const ctx = getAudioContext();
            // Ascending triad: C5 (523.25Hz), E5 (659.25Hz), G5 (783.99Hz)
            [523.25, 659.25, 783.99].forEach((freq, idx) => {
                const osc = ctx.createOscillator();
                const gain = ctx.createGain();
                osc.type = 'triangle';
                const startTime = ctx.currentTime + (idx * 0.08);
                osc.frequency.setValueAtTime(freq, startTime);
                gain.gain.setValueAtTime(0.18, startTime);
                gain.gain.exponentialRampToValueAtTime(0.001, startTime + 0.22);
                osc.connect(gain);
                gain.connect(ctx.destination);
                osc.start(startTime);
                osc.stop(startTime + 0.22);
            });
        } catch (e) { console.warn("Audio feedback error:", e); }
    }

    function playErrorTone() {
        try {
            const ctx = getAudioContext();
            const osc = ctx.createOscillator();
            const gain = ctx.createGain();
            osc.type = 'sawtooth';
            osc.frequency.setValueAtTime(240, ctx.currentTime);
            osc.frequency.setValueAtTime(170, ctx.currentTime + 0.14);
            gain.gain.setValueAtTime(0.18, ctx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.32);
            osc.connect(gain);
            gain.connect(ctx.destination);
            osc.start();
            osc.stop(ctx.currentTime + 0.32);
        } catch (e) { console.warn("Audio feedback error:", e); }
    }

    function triggerVisualFlash(isSuccess) {
        const overlay = document.getElementById('scannerFlashOverlay');
        overlay.className = 'scanner-flash-feedback ' + (isSuccess ? 'scanner-flash-success' : 'scanner-flash-error');
        overlay.style.opacity = '1';
        setTimeout(() => { overlay.style.opacity = '0'; }, 300);
    }

    // =========================================================================
    // Optical QR Camera Viewfinder Stream Initialization
    // =========================================================================
    function initScanner() {
        if (typeof Html5Qrcode === "undefined") {
            console.warn("Html5Qrcode library not yet loaded, retrying in 300ms...");
            setTimeout(initScanner, 300);
            return;
        }

        const select = document.getElementById('cameraDeviceSelect');
        if (select) select.innerHTML = '<option value="">Detecting Cameras...</option>';

        Html5Qrcode.getCameras().then(devices => {
            if (select) select.innerHTML = '';

            if (devices && devices.length > 0) {
                devices.forEach((dev, idx) => {
                    const opt = document.createElement('option');
                    opt.value = dev.id;
                    opt.text = dev.label || ('Camera ' + (idx + 1));
                    select.appendChild(opt);
                });

                startCamera(devices[0].id);
            } else {
                select.innerHTML = '<option value="">No Camera Found</option>';
            }
        }).catch(err => {
            console.warn("Camera enumeration error:", err);
            const select = document.getElementById('cameraDeviceSelect');
            select.innerHTML = '<option value="">Camera Blocked / Unavailable</option>';
        });
    }

    function startCamera(cameraId) {
        if (html5QrScanner) {
            html5QrScanner.stop().then(() => {
                mountCamera(cameraId);
            }).catch(() => {
                mountCamera(cameraId);
            });
        } else {
            mountCamera(cameraId);
        }
    }

    function mountCamera(cameraId) {
        html5QrScanner = new Html5Qrcode("qr-reader");
        const config = {
            fps: 15,
            qrbox: { width: 220, height: 220 },
            aspectRatio: 1.0
        };

        html5QrScanner.start(
            cameraId,
            config,
            onScanSuccess,
            onScanFailure
        ).catch(err => {
            console.warn("Camera start error:", err);
        });
    }

    function changeCameraDevice() {
        const selectedId = document.getElementById('cameraDeviceSelect').value;
        if (selectedId && isCameraActive) {
            startCamera(selectedId);
        }
    }

    let isCameraActive = false;

    function toggleCameraPower() {
        const btn = document.getElementById('btnToggleCamera');
        const lbl = document.getElementById('lblCameraToggleText');
        const overlay = document.getElementById('scannerOffOverlay');
        const hud = document.querySelector('.scanner-hud-overlay');

        if (isCameraActive) {
            // Turn OFF
            if (html5QrScanner) {
                html5QrScanner.stop().then(() => {
                    isCameraActive = false;
                    btn.className = 'btn-scanner-toggle is-inactive';
                    btn.setAttribute('aria-checked', 'false');
                    lbl.innerText = 'Scanner OFF';
                    if (overlay) overlay.style.display = 'flex';
                    if (hud) hud.style.display = 'none';
                }).catch(err => {
                    console.warn("Camera stop error:", err);
                    isCameraActive = false;
                    btn.className = 'btn-scanner-toggle is-inactive';
                    btn.setAttribute('aria-checked', 'false');
                    lbl.innerText = 'Scanner OFF';
                    if (overlay) overlay.style.display = 'flex';
                    if (hud) hud.style.display = 'none';
                });
            } else {
                isCameraActive = false;
                btn.className = 'btn-scanner-toggle is-inactive';
                btn.setAttribute('aria-checked', 'false');
                lbl.innerText = 'Scanner OFF';
                if (overlay) overlay.style.display = 'flex';
                if (hud) hud.style.display = 'none';
            }
        } else {
            // Turn ON
            const selectedId = document.getElementById('cameraDeviceSelect').value;
            if (selectedId) {
                startCamera(selectedId);
                isCameraActive = true;
                btn.className = 'btn-scanner-toggle is-active';
                btn.setAttribute('aria-checked', 'true');
                lbl.innerText = 'Scanner ON';
                if (overlay) overlay.style.display = 'none';
                if (hud) hud.style.display = 'flex';
            } else {
                initScanner();
                isCameraActive = true;
                btn.className = 'btn-scanner-toggle is-active';
                btn.setAttribute('aria-checked', 'true');
                lbl.innerText = 'Scanner ON';
                if (overlay) overlay.style.display = 'none';
                if (hud) hud.style.display = 'flex';
            }
        }
    }

    function onScanSuccess(decodedText, decodedResult) {
        if (isProcessingScan) return;
        isProcessingScan = true;
        currentVerificationMethod = "Optical QR Scan";
        playScanBeep();
        stageLookupQuery(decodedText);
    }

    function onScanFailure(error) {
        // Continuous scan tick; silent ignore
    }

    // =========================================================================
    // Manual Fallback Lookup Handler
    // =========================================================================
    function handleManualInputKeydown(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            stageManualLookup();
        }
    }

    function stageManualLookup() {
        const input = document.getElementById('txtManualInput');
        const query = (input.value || '').trim();
        if (!query) {
            alert('Please enter a Student ID number or Ticket Reference.');
            input.focus();
            return;
        }
        currentVerificationMethod = "Manual Fallback Console";
        playScanBeep();
        stageLookupQuery(query);
    }

    // =========================================================================
    // Pre-Commit State Validation & Staging Query (AJAX WebMethod)
    // =========================================================================
    function stageLookupQuery(query) {
        // Immediately disable confirm button and clear previous staging data to prevent hardware scanner Enter race condition
        const btnConfirm = document.getElementById('btnConfirmCheckIn');
        if (btnConfirm) {
            btnConfirm.disabled = true;
        }
        stagedData = null;

        const endpoint = '<%= ResolveUrl("~/Frontend/Admin/AttendanceScanner.aspx") %>/LookupAttendee';
        fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            body: JSON.stringify({ eventId: activeEventId, query: query })
        })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => {
                    throw new Error(`Server returned HTTP ${response.status}: ${text ? text.substring(0, 100) : ''}`);
                });
            }
            return response.json();
        })
        .then(data => {
            const result = data.d;
            handleLookupResult(result);
        })
        .catch(err => {
            console.error("Lookup error:", err);
            handleLookupResult({
                Success: false,
                State: "NotFound",
                Message: "Server communication error during attendee lookup: " + (err.message || err)
            });
        })
        .finally(() => {
            setTimeout(() => { isProcessingScan = false; }, 800);
        });
    }

    function handleLookupResult(res) {
        stagedData = res;
        const statusBadge = document.getElementById('stagingStatusBadge');
        const alertBanner = document.getElementById('stagingAlertBanner');
        const alertMessage = document.getElementById('stagingAlertMessage');
        const btnConfirm = document.getElementById('btnConfirmCheckIn');

        if (!res || !res.Success || res.State === "NotFound") {
            playErrorTone();
            triggerVisualFlash(false);
            statusBadge.className = 'staging-status-badge badge-danger-invalid';
            statusBadge.innerText = 'INVALID TICKET';
            alertBanner.className = 'staging-alert-banner banner-invalid';
            alertMessage.innerText = res.Message || 'No matching attendee registration found in the system.';
            clearStagedFields();
            btnConfirm.disabled = true;
            if (window.showToast) {
                window.showToast(res ? res.Message : 'No matching registration found.', 'error', 'Ticket Not Found');
            }
            return;
        }

        // Populate Attendee Details
        populateStagedFields(res);

        if (res.State === "ValidPending") {
            // State 1: Valid Ticket / Pending Admin Confirmation
            statusBadge.className = 'staging-status-badge badge-staged-valid';
            statusBadge.innerText = 'PENDING INSPECTION';
            alertBanner.className = 'staging-alert-banner banner-valid';
            alertMessage.innerText = 'Valid Ticket pass detected. Inspect student University ID card before confirming check-in.';
            btnConfirm.disabled = false;
            if (window.showToast) {
                window.showToast(`Attendee <strong>${res.FullName}</strong> staged. Confirm check-in to admit.`, 'info', 'Ticket Staged');
            }
        }
        else if (res.State === "DuplicateWarning") {
            // State 2: Duplicate Check-In Warning
            playErrorTone();
            triggerVisualFlash(false);
            statusBadge.className = 'staging-status-badge badge-warning-duplicate';
            statusBadge.innerText = 'DUPLICATE CHECK-IN';
            alertBanner.className = 'staging-alert-banner banner-duplicate';
            alertMessage.innerText = res.Message || 'Warning: This ticket pass was already used for attendance check-in.';
            btnConfirm.disabled = true;
            if (window.showToast) {
                window.showToast(res.Message || 'Ticket already checked in.', 'warning', 'Duplicate Check-In');
            }
        }
        else if (res.State === "WrongEventWarning") {
            // State 3: Wrong Event Warning
            playErrorTone();
            triggerVisualFlash(false);
            statusBadge.className = 'staging-status-badge badge-danger-invalid';
            statusBadge.innerText = 'WRONG EVENT';
            alertBanner.className = 'staging-alert-banner banner-invalid';
            alertMessage.innerText = res.Message || 'Warning: This ticket pass belongs to another event.';
            btnConfirm.disabled = true;
            if (window.showToast) {
                window.showToast(res.Message || 'Ticket belongs to another event.', 'error', 'Wrong Event');
            }
        }
        else if (res.State === "CancelledWarning") {
            // State 4: Cancelled Warning
            playErrorTone();
            triggerVisualFlash(false);
            statusBadge.className = 'staging-status-badge badge-danger-invalid';
            statusBadge.innerText = 'REVOKED PASS';
            alertBanner.className = 'staging-alert-banner banner-invalid';
            alertMessage.innerText = res.Message || 'Warning: This registration pass was revoked / cancelled.';
            btnConfirm.disabled = true;
        }
    }

    function populateStagedFields(d) {
        document.getElementById('stagedStudentId').innerText = d.StudentId || '--';
        document.getElementById('stagedFullName').innerText = d.FullName || 'Student Attendee';
        document.getElementById('stagedTicketRef').innerText = d.TicketReference || '--';
        document.getElementById('stagedBranch').innerText = d.Branch || 'Main Campus';
        document.getElementById('stagedEmail').innerText = d.Email || 'No institutional email';
        document.getElementById('stagedDepartment').innerText = d.Department || '--';
        document.getElementById('stagedCourse').innerText = d.Course || '--';
        document.getElementById('stagedYearSection').innerText = 'Year ' + (d.YearLevel || 1) + ' - ' + (d.Section || '--');
        document.getElementById('stagedRegistrationState').innerText = d.State || 'Pending Review';

        // Avatar Initials
        let initials = 'ST';
        if (d.FullName) {
            const parts = d.FullName.trim().split(' ');
            if (parts.length >= 2) {
                initials = (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
            } else if (parts.length === 1 && parts[0].length > 0) {
                initials = parts[0][0].toUpperCase();
            }
        }
        document.getElementById('stagedAvatarInitials').innerText = initials;
    }

    function clearStagedFields() {
        document.getElementById('stagedStudentId').innerText = '--';
        document.getElementById('stagedFullName').innerText = 'Awaiting Attendee Scan';
        document.getElementById('stagedTicketRef').innerText = 'TCK-0000-00000';
        document.getElementById('stagedBranch').innerText = '--';
        document.getElementById('stagedEmail').innerText = '--';
        document.getElementById('stagedDepartment').innerText = '--';
        document.getElementById('stagedCourse').innerText = '--';
        document.getElementById('stagedYearSection').innerText = '--';
        document.getElementById('stagedRegistrationState').innerText = '--';
        document.getElementById('stagedAvatarInitials').innerText = '--';
    }

    // =========================================================================
    // Final Database Commit (Explicit Operator Action Only)
    // =========================================================================
    let isCommitting = false;

    function executeCheckInCommit() {
        if (isCommitting) return;
        if (!stagedData || !stagedData.EventRegistrationId || stagedData.State !== "ValidPending") {
            return;
        }

        isCommitting = true;
        const btnConfirm = document.getElementById('btnConfirmCheckIn');
        if (btnConfirm) {
            btnConfirm.disabled = true;
            btnConfirm.innerText = 'COMMITTING...';
        }

        const endpoint = '<%= ResolveUrl("~/Frontend/Admin/AttendanceScanner.aspx") %>/CommitCheckIn';
        fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            body: JSON.stringify({
                eventRegistrationId: stagedData.EventRegistrationId,
                verificationMethod: currentVerificationMethod
            })
        })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => {
                    throw new Error(`Server returned HTTP ${response.status}: ${text ? text.substring(0, 120) : ''}`);
                });
            }
            return response.json();
        })
        .then(data => {
            const res = data.d;
            if (res && res.Success) {
                // Success: Play green chime & flash
                playSuccessChime();
                triggerVisualFlash(true);

                // Update Live KPI metrics
                const kpiVerified = document.getElementById('kpiVerifiedCount');
                if (kpiVerified) kpiVerified.innerText = res.UpdatedCheckedInCount;
                const expEl = document.getElementById('kpiExpectedCount');
                if (expEl) {
                    let expCount = parseInt(expEl.innerText, 10);
                    if (!isNaN(expCount) && expCount > 0) {
                        expEl.innerText = (expCount - 1).toString();
                    }
                }

                // Append attendee row to live attendance roster
                prependLiveRosterRow(res);

                // Clear Staging and notify
                discardStagedAttendee();
                document.getElementById('stagingAlertBanner').className = 'staging-alert-banner banner-valid';
                document.getElementById('stagingAlertMessage').innerText = `Checked in successfully: ${res.FullName} (${res.StudentId}) at ${res.CheckInTimestamp}`;
                if (window.showToast) {
                    window.showToast(`Checked in: <strong>${res.FullName}</strong> (${res.StudentId})`, 'success', 'Admission Confirmed');
                }
            } else {
                playErrorTone();
                triggerVisualFlash(false);
                const refusalMsg = res && res.Message ? res.Message : 'Failed to record attendance check-in.';
                if (window.showToast) {
                    window.showToast(refusalMsg, 'error', 'Check-In Refused');
                } else {
                    alert(refusalMsg);
                }
            }
        })
        .catch(err => {
            console.error("Check-in commit error:", err);
            playErrorTone();
            const errMsg = err && err.message ? err.message : 'A network error occurred while committing attendance.';
            if (window.showToast) {
                window.showToast(errMsg, 'error', 'Network Error');
            } else {
                alert(errMsg);
            }
        })
        .finally(() => {
            isCommitting = false;
            if (btnConfirm) {
                btnConfirm.innerHTML = `<span>CONFIRM & CHECK-IN</span><span class="keyboard-hint-badge">ENTER</span>`;
            }
        });
    }

    function prependLiveRosterRow(row) {
        const tbody = document.getElementById('tbodyLiveRoster');
        if (!tbody) return;
        const emptyPanel = document.getElementById('pnlEmptyLiveRoster');
        if (emptyPanel) {
            emptyPanel.style.display = 'none';
        }

        const tr = document.createElement('tr');
        tr.style.backgroundColor = 'rgba(16, 185, 129, 0.08)';
        tr.innerHTML = `
            <td>
                <span class="timestamp-badge">${row.CheckInTimestamp}</span>
            </td>
            <td>
                <span style="font-family:'Courier New', monospace; font-weight:700; color:#38bdf8;">${row.TicketReference}</span>
            </td>
            <td><strong>${row.StudentId}</strong></td>
            <td>${row.FullName}</td>
            <td>${row.CourseAndYear}</td>
            <td>
                <span class="method-pill">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#38bdf8" stroke-width="2">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                    <span>${row.VerificationMethod}</span>
                </span>
            </td>
            <td><span style="color:var(--text-muted);">${row.AdminUser}</span></td>
        `;

        if (tbody.firstChild) {
            tbody.insertBefore(tr, tbody.firstChild);
        } else {
            tbody.appendChild(tr);
        }

        setTimeout(() => { tr.style.backgroundColor = ''; }, 2500);
    }

    function discardStagedAttendee() {
        stagedData = null;
        clearStagedFields();
        document.getElementById('txtManualInput').value = '';
        document.getElementById('btnConfirmCheckIn').disabled = true;
        document.getElementById('stagingStatusBadge').className = 'staging-status-badge badge-awaiting';
        document.getElementById('stagingStatusBadge').innerText = 'AWAITING SCAN';
        document.getElementById('stagingAlertBanner').className = 'staging-alert-banner banner-idle';
        document.getElementById('stagingAlertMessage').innerText = 'Ready for attendee. Scan QR pass or perform manual lookup.';
    }

    // =========================================================================
    // Keyboard Shortcuts: Enter/Space (Confirm), Esc (Discard)
    // =========================================================================
    document.addEventListener('keydown', function (e) {
        // If typing in input box, ignore global space
        if (e.target && e.target.id === 'txtManualInput') {
            return;
        }

        if (e.key === 'Enter' || e.code === 'Space') {
            const btnConfirm = document.getElementById('btnConfirmCheckIn');
            if (btnConfirm && !btnConfirm.disabled) {
                e.preventDefault();
                executeCheckInCommit();
            }
        } else if (e.key === 'Escape') {
            e.preventDefault();
            discardStagedAttendee();
        }
    });

    // Scanner is OFF by default; do not auto-start camera on DOMContentLoaded
    window.addEventListener('DOMContentLoaded', () => {
        // Initial state is scanner OFF. Camera will initialize when user clicks the toggle switch.
    });
</script>

</asp:Content>
