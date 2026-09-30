<%@ Page Title="Event Attendance Scanner" Language="C#" MasterPageFile="~/Frontend/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AttendanceScanner.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.Admin.AttendanceScanner" EnableSessionState="ReadOnly" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Event Attendance Scanner & Gate Terminal | QCU Event Management
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Optical QR Decoding Library -->
    <script src="https://unpkg.com/html5-qrcode@2.3.8/html5-qrcode.min.js"></script>

    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/admin/attendance-scanner.css") %>" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="scanner-container">

    <!-- Context Header Banner -->
    <div class="event-context-card">
        <div class="event-context-top">
            <div class="event-title-group">
                <h1>
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2">
                        <path d="M4 7V4h3M20 7V4h-3M4 17v3h3M20 17v3h-3M9 9h6v6H9z"></path>
                    </svg>
                    <asp:Literal ID="litEventTitle" runat="server" Text="Select an Event"></asp:Literal>
                </h1>
                <div class="event-meta-chips">
                    <span class="meta-chip">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                        <!-- Strict MM/dd/yyyy date standard -->
                        <span>Date: <strong><asp:Literal ID="litEventDate" runat="server" Text="--/--/----"></asp:Literal></strong></span>
                    </span>
                    <span class="meta-chip">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                            <circle cx="12" cy="10" r="3"></circle>
                        </svg>
                        <span>Venue: <strong><asp:Literal ID="litEventVenue" runat="server" Text="--"></asp:Literal></strong></span>
                    </span>
                    <span class="meta-chip">
                        <span class="live-indicator-dot"></span>
                        <span style="color:#10b981; font-weight:600;">GATE OPERATIONS ACTIVE</span>
                    </span>
                </div>
            </div>

            <!-- Event Dropdown Switcher -->
            <div class="event-switcher">
                <label for="<%= ddlEvents.ClientID %>">Active Event:</label>
                <asp:DropDownList ID="ddlEvents" runat="server" CssClass="event-dropdown-select" AutoPostBack="true" OnSelectedIndexChanged="ddlEvents_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
        </div>

        <!-- Sub-Module Pipeline Tabs -->
        <div class="pipeline-tabs-wrapper">
            <a href="<%= ResolveUrl("~/Frontend/Admin/AdminEvents.aspx") %>" class="pipeline-tab-item">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
                <span>1. Event Matrix</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventPreRegistered.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="8.5" cy="7" r="4"></circle>
                    <polyline points="17 11 19 13 23 9"></polyline>
                </svg>
                <span>2. Pre-Registered</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/AttendanceScanner.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item active">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M4 7V4h3M20 7V4h-3M4 17v3h3M20 17v3h-3M9 9h6v6H9z"></path>
                </svg>
                <span>3. Attendance Scanner</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventAttendance.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M9 11l3 3L22 4"></path>
                    <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                </svg>
                <span>4. Event Attendance</span>
            </a>
            <a href="<%= ResolveUrl(string.Format("~/Frontend/Admin/EventAnalytics.aspx?eventId={0}", CurrentEventId)) %>" class="pipeline-tab-item">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="20" x2="18" y2="10"></line>
                    <line x1="12" y1="20" x2="12" y2="4"></line>
                    <line x1="6" y1="20" x2="6" y2="14"></line>
                </svg>
                <span>5. Event Analytics</span>
            </a>
        </div>
    </div>

    <!-- Live Gate Headcount Metrics Bar -->
    <div class="gate-metrics-bar">
        <div class="gate-stat-card">
            <div class="gate-stat-info">
                <span class="gate-stat-label">Verified Check-Ins</span>
                <span class="gate-stat-value" id="kpiVerifiedCount"><asp:Literal ID="litCheckedInCount" runat="server" Text="0"></asp:Literal></span>
                <span class="gate-stat-subtext">Students admitted through gate</span>
            </div>
            <div style="color:#10b981;">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
            </div>
        </div>

        <div class="gate-stat-card">
            <div class="gate-stat-info">
                <span class="gate-stat-label">Expected Attendees</span>
                <span class="gate-stat-value" id="kpiExpectedCount"><asp:Literal ID="litExpectedCount" runat="server" Text="0"></asp:Literal></span>
                <span class="gate-stat-subtext">Remaining in pre-registered roster</span>
            </div>
            <div style="color:#38bdf8;">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                </svg>
            </div>
        </div>

        <div class="gate-stat-card">
            <div class="gate-stat-info">
                <span class="gate-stat-label">Gate Turnout Rate</span>
                <span class="gate-stat-value" id="kpiTurnoutRate"><asp:Literal ID="litTurnoutRate" runat="server" Text="0.0%"></asp:Literal></span>
                <span class="gate-stat-subtext">Of total registered quota</span>
            </div>
            <div style="color:#fbbf24;">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                    <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                </svg>
            </div>
        </div>

        <div class="gate-stat-card">
            <div class="gate-stat-info">
                <span class="gate-stat-label">Inspecting Gate Admin</span>
                <span class="gate-stat-value" style="font-size:1.1rem; font-weight:600; text-overflow:ellipsis; overflow:hidden; white-space:nowrap; max-width:200px;">
                    <asp:Literal ID="litCurrentAdminEmail" runat="server" Text="admin@gmail.com"></asp:Literal>
                </span>
                <span class="gate-stat-subtext">Authenticated terminal credentials</span>
            </div>
            <div style="color:#818cf8;">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                </svg>
            </div>
        </div>
    </div>

    <!-- Main Operational Terminal Grid: Viewfinder vs Staging Area -->
    <div class="terminal-grid">

        <!-- Left Column: Optical Viewfinder Stream & Manual Fallback Console -->
        <div class="viewfinder-column">
            
            <!-- Camera Viewfinder Card -->
            <div class="viewfinder-card">
                <div class="card-header-bar">
                    <div class="card-header-title">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#38bdf8" stroke-width="2">
                            <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                            <circle cx="12" cy="13" r="4"></circle>
                        </svg>
                        <span>Optical QR Viewfinder Stream</span>
                    </div>
                    <select id="cameraDeviceSelect" class="camera-select-control" onchange="changeCameraDevice()">
                        <option value="">Detecting Cameras...</option>
                    </select>
                </div>

                <div class="camera-viewport-wrapper" id="cameraViewportContainer">
                    <div id="qr-reader"></div>

                    <!-- Holographic Target Overlay -->
                    <div class="scanner-hud-overlay">
                        <div class="scanner-hud-reticle">
                            <div class="scanner-laser-line"></div>
                            <div class="hud-corner hud-tl"></div>
                            <div class="hud-corner hud-tr"></div>
                            <div class="hud-corner hud-bl"></div>
                            <div class="hud-corner hud-br"></div>
                        </div>
                        <div class="scanner-hud-hint">Align attendee digital or physical QR pass in viewfinder</div>
                    </div>

                    <!-- Visual Flash Confirmation Overlay -->
                    <div id="scannerFlashOverlay" class="scanner-flash-feedback"></div>
                </div>
            </div>

            <!-- Manual Fallback Console -->
            <div class="manual-console-card">
                <div class="manual-console-title">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="2" y="4" width="20" height="16" rx="2"></rect>
                        <path d="M6 8h.01M10 8h.01M14 8h.01M18 8h.01M6 12h.01M10 12h.01M14 12h.01M18 12h.01M6 16h12"></path>
                    </svg>
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
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#38bdf8" stroke-width="2">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <circle cx="10" cy="13" r="2"></circle>
                        <path d="M14 17h-8"></path>
                    </svg>
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
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                    <span>CONFIRM & CHECK-IN</span>
                    <span class="keyboard-hint-badge">ENTER</span>
                </button>

                <button type="button" id="btnDiscardStaging" class="btn-discard-staging" onclick="discardStagedAttendee()">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                    <span>DISCARD / CLEAR</span>
                    <span class="keyboard-hint-badge">ESC</span>
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

        Html5Qrcode.getCameras().then(devices => {
            const select = document.getElementById('cameraDeviceSelect');
            select.innerHTML = '';

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
        if (selectedId) {
            startCamera(selectedId);
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
        fetch('AttendanceScanner.aspx/LookupAttendee', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            body: JSON.stringify({ eventId: activeEventId, query: query })
        })
        .then(response => response.json())
        .then(data => {
            const result = data.d;
            handleLookupResult(result);
        })
        .catch(err => {
            console.error("Lookup error:", err);
            handleLookupResult({
                Success: false,
                State: "NotFound",
                Message: "Server communication error during attendee lookup."
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
    function executeCheckInCommit() {
        if (!stagedData || !stagedData.EventRegistrationId || stagedData.State !== "ValidPending") {
            return;
        }

        const btnConfirm = document.getElementById('btnConfirmCheckIn');
        btnConfirm.disabled = true;
        btnConfirm.innerText = 'COMMITTING...';

        fetch('AttendanceScanner.aspx/CommitCheckIn', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            body: JSON.stringify({
                eventRegistrationId: stagedData.EventRegistrationId,
                verificationMethod: currentVerificationMethod
            })
        })
        .then(response => response.json())
        .then(data => {
            const res = data.d;
            if (res && res.Success) {
                // Success: Play green chime & flash
                playSuccessChime();
                triggerVisualFlash(true);

                // Update Live KPI metrics
                document.getElementById('kpiVerifiedCount').innerText = res.UpdatedCheckedInCount;
                const expEl = document.getElementById('kpiExpectedCount');
                let expCount = parseInt(expEl.innerText, 10);
                if (!isNaN(expCount) && expCount > 0) {
                    expEl.innerText = (expCount - 1).toString();
                }

                // Append attendee row to live attendance roster
                prependLiveRosterRow(res);

                // Clear Staging and notify
                discardStagedAttendee();
                document.getElementById('stagingAlertBanner').className = 'staging-alert-banner banner-valid';
                document.getElementById('stagingAlertMessage').innerText = `Checked in successfully: ${res.FullName} (${res.StudentId}) at ${res.CheckInTimestamp}`;
            } else {
                playErrorTone();
                triggerVisualFlash(false);
                alert(res.Message || 'Failed to record attendance check-in.');
            }
        })
        .catch(err => {
            console.error("Check-in commit error:", err);
            playErrorTone();
            alert('A network error occurred while committing attendance.');
        })
        .finally(() => {
            btnConfirm.innerHTML = `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><polyline points="20 6 9 17 4 12"></polyline></svg><span>CONFIRM & CHECK-IN</span><span class="keyboard-hint-badge">ENTER</span>`;
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

    // Start Scanner on Page Ready
    window.addEventListener('DOMContentLoaded', () => {
        initScanner();
    });
</script>

</asp:Content>
