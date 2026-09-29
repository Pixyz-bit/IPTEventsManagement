<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.User.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>University Event Portal | Quezon City University</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&family=JetBrains+Mono:wght@500;600;700;800&display=swap" rel="stylesheet" />

    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/user/dashboard.css") %>" />
</head>
<body>
    <form id="studentDashboardForm" runat="server">
        <!-- Preview Notification Banner (Shown when evaluating without authenticated session) -->
        <asp:Panel ID="pnlPreviewBanner" runat="server" CssClass="preview-banner" Visible="false">
            <div>
                <strong>DEMO PREVIEW:</strong> Viewing active student profile for <em>Martin Jalop (BSIT 3rd Year &bull; San Bartolome)</em>.
            </div>
            <div>
                <a href="<%= ResolveUrl("~/Frontend/Login/Login.aspx") %>">LOGIN WITH ACTIVE ACCOUNT &rarr;</a>
            </div>
        </asp:Panel>
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

                <div class="nav-user-bar">
                    <div class="nav-user-badge">
                        <div class="nav-user-avatar">
                            <asp:Literal ID="litAvatarInitials" runat="server" Text="MJ" />
                        </div>
                        <div class="nav-user-info">
                            <span class="nav-user-name"><asp:Literal ID="litStudentName" runat="server" Text="Martin Jalop" /></span>
                            <span class="nav-user-id">[ <asp:Literal ID="litStudentId" runat="server" Text="24-1611" /> ]</span>
                        </div>
                    </div>

                    <asp:LinkButton ID="btnSignOut" runat="server" CssClass="nav-btn-signout" OnClick="btnSignOut_Click" ToolTip="Sign Out" CausesValidation="false">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                            <polyline points="16 17 21 12 16 7"></polyline>
                            <line x1="21" y1="12" x2="9" y2="12"></line>
                        </svg>
                    </asp:LinkButton>
                </div>
            </div>
        </header>

        <!-- Main Workspace -->
        <main class="portal-main">
            <!-- Toast Feedback Notification -->
            <asp:Panel ID="pnlToast" runat="server" Visible="false" CssClass="toast-banner">
                <asp:Literal ID="litToastMsg" runat="server" />
            </asp:Panel>

            <!-- ══════════════════════════════════════════════════════════════
                 HERO SECTION: MATCHING PHOTO 1 (CINEMATIC GALLERY STAGE)
                 ══════════════════════════════════════════════════════════════ -->
            <section class="hero-showcase-container" id="heroGallery">
                <!-- Background Image Layer & Dark Vignette Overlay -->
                <div class="hero-bg-layer" id="heroBgImage" style="background-image: url('<%= ResolveUrl("~/Frontend/Assets/hero_cyber_ai.jpg") %>');"></div>
                <div class="hero-overlay-layer"></div>

                <!-- Main Hero Headline & Metadata (Matching Photo 1) -->
                <div class="hero-body-content">
                    <h1 class="hero-title" id="heroTitle">Cybersecurity and AI Convention</h1>
                    <p class="hero-description" id="heroDescription">
                        Flagship cybersecurity conference and defensive hacking competition with enterprise penetration testers and student defense drills.
                    </p>

                    <div class="hero-meta-list">
                        <div class="hero-meta-item">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                <circle cx="12" cy="10" r="3"></circle>
                            </svg>
                            <span id="heroVenue">QCU Auditorium</span>
                        </div>

                        <div class="hero-meta-item">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                            <span id="heroDate">Oct 09, 2026</span>
                        </div>

                        <div class="hero-meta-item">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                            <span id="heroTime">10:00 AM - 03:00 PM</span>
                        </div>
                    </div>
                </div>

                <!-- Bottom Horizontal Thumbnail Gallery Rail (Matching Photo 1) -->
                <div class="hero-gallery-rail">
                    <div class="hero-thumb-card active-thumb" id="heroThumb-0" onclick="selectHeroSlide(0)" 
                         style="background-image: url('<%= ResolveUrl("~/Frontend/Assets/hero_cyber_ai.jpg") %>');">
                        <div class="thumb-overlay">
                            <div class="thumb-title">Cybersecurity & AI Convention</div>
                            <div class="thumb-meta">Oct 09 &bull; Auditorium</div>
                        </div>
                    </div>

                    <div class="hero-thumb-card" id="heroThumb-1" onclick="selectHeroSlide(1)"
                         style="background-image: url('<%= ResolveUrl("~/Frontend/Assets/hero_cloud_lab.jpg") %>');">
                        <div class="thumb-overlay">
                            <div class="thumb-title">AI & Cloud Architecture</div>
                            <div class="thumb-meta">Oct 09 &bull; Tech Lab 3</div>
                        </div>
                    </div>

                    <div class="hero-thumb-card" id="heroThumb-2" onclick="selectHeroSlide(2)"
                         style="background-image: url('<%= ResolveUrl("~/Frontend/Assets/campus-clean.jpg") %>');">
                        <div class="thumb-overlay">
                            <div class="thumb-title">Tech & Innovation Summit</div>
                            <div class="thumb-meta">Nov 12 &bull; University Hall</div>
                        </div>
                    </div>

                    <div class="hero-thumb-card" id="heroThumb-3" onclick="selectHeroSlide(3)"
                         style="background-image: url('<%= ResolveUrl("~/Frontend/Assets/QCU Background.png") %>');">
                        <div class="thumb-overlay">
                            <div class="thumb-title">Grand Org Fair & SportsFest</div>
                            <div class="thumb-meta">Nov 20 &bull; Main Plaza</div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Student Demographic Identity Matrix Bar -->
            <div class="student-matrix-strip">
                <span class="matrix-title">COHORT MATRIX:</span>
                <span class="matrix-chip">BRANCH: <asp:Literal ID="litCampusBranch" runat="server" Text="San Bartolome" /></span>
                <span class="matrix-chip">DEPT: <asp:Literal ID="litDepartment" runat="server" Text="College of Computer Studies" /></span>
                <span class="matrix-chip">PROGRAM: <asp:Literal ID="litProgram" runat="server" Text="BSIT" /></span>
                <span class="matrix-chip">STANDING: <asp:Literal ID="litYearLevel" runat="server" Text="3rd Year" /></span>
            </div>

            <!-- ══════════════════════════════════════════════════════════════
                 VIEW ALL EVENTS & TAB-LIKE TOGGLE SECTION
                 ══════════════════════════════════════════════════════════════ -->
            <section class="events-view-section" id="events-section">
                <!-- Section Header Row & Segmented Tab Toggle -->
                <div class="section-header-row">
                    <div class="section-title-block">
                        <h2 id="viewSectionTitle">Campus Event Matrix</h2>
                        <p id="viewSectionSubtitle">Explore open registrations or inspect your booked electronic passes.</p>
                    </div>

                    <!-- Tab-like Toggle (Modern Segmented Control) -->
                    <div class="tab-toggle-container">
                        <button type="button" class="tab-btn active" id="tabCatalogBtn" onclick="switchTab('catalog')">
                            <span>All Open Events</span>
                            <span class="tab-count-pill" id="openEventsCount">4 OPEN</span>
                        </button>
                        <button type="button" class="tab-btn" id="tabRegisteredBtn" onclick="switchTab('registered')">
                            <span>My Registered Events</span>
                            <span class="tab-count-pill">MY PASSES</span>
                        </button>
                    </div>
                </div>

                <!-- ────────────────────────────────────────────────────────────
                     TAB 1 VIEW: ALL OPEN EVENTS CATALOG
                     ──────────────────────────────────────────────────────────── -->
                <div class="events-catalog-content" id="catalogContentArea">
                    <!-- Category Filter Pills Bar -->
                    <div class="category-filter-bar">
                        <span class="filter-label">Filter Tags:</span>
                        <a href="javascript:void(0)" class="cat-pill active" onclick="filterByCategory('all', this)">#All Events</a>
                        <a href="javascript:void(0)" class="cat-pill" onclick="filterByCategory('seminar', this)">#Seminar</a>
                        <a href="javascript:void(0)" class="cat-pill" onclick="filterByCategory('hackathon', this)">#Hackathon</a>
                        <a href="javascript:void(0)" class="cat-pill" onclick="filterByCategory('workshop', this)">#Workshop</a>
                        <a href="javascript:void(0)" class="cat-pill" onclick="filterByCategory('sportsfest', this)">#SportsFest</a>
                        <a href="javascript:void(0)" class="cat-pill" onclick="filterByCategory('orgfair', this)">#OrgFair</a>
                    </div>

                    <!-- ────────────────────────────────────────────────────────────
                         EVENT CARDS GRID: ORGANIZATION OF PHOTO 2 WITH CINEMATIC STYLING
                         ──────────────────────────────────────────────────────────── -->
                    <div class="events-grid" id="eventsGridContainer">
                        <asp:Repeater ID="rptEventCards" runat="server" OnItemCommand="rptEventCards_ItemCommand">
                            <ItemTemplate>
                                <div class="event-card" data-category='<%# Eval("CategoryFilterKey") %>' id='card-<%# Eval("EventId") %>'>
                                    <!-- Top Half: Promotional Banner Area (Photo 2) -->
                                    <div class="event-promo-banner" style='background-image: url("<%# Eval("BannerImageUrl") %>");'>
                                        <!-- Category Tag Pill (Top-Left in Photo 2) -->
                                        <div class="card-tag-pill">
                                            <%# Eval("CategoryTag") %>
                                        </div>

                                        <!-- Status Indicator (Top-Right in Photo 2) -->
                                        <%# Eval("RegStatusBadgeHtml") %>

                                        <!-- Capacity Indicator (Bottom-Right in Photo 2) -->
                                        <div class="card-capacity-pill">
                                            <%# Eval("CurrentRegistrations") %>/<%# Eval("MaxCapacity") %> SEATS
                                        </div>
                                    </div>

                                    <!-- Bottom Half: Event Details (Photo 2) -->
                                    <div class="event-card-body">
                                        <!-- Event Title: Prominent, Crisp, High-Contrast -->
                                        <h3 class="card-event-name"><%# Eval("Title") %></h3>
                                        
                                        <!-- Location Line with Pin Icon (Photo 2) -->
                                        <div class="card-meta-line">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                                <circle cx="12" cy="10" r="3"></circle>
                                            </svg>
                                            <span><%# Eval("VenueLocation") %></span>
                                        </div>

                                        <!-- Schedule Line with Clock Icon (Photo 2) -->
                                        <div class="card-meta-line">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                            <span><%# Eval("FormattedSchedule") %></span>
                                        </div>

                                        <!-- Sponsors Row (Photo 2) -->
                                        <div class="card-sponsors-row">
                                            <span class="sponsor-label">SPONSORS:</span>
                                            <%# Eval("SponsorBadgesHtml") %>
                                        </div>

                                        <!-- Subtle Divider Line (Photo 2) -->
                                        <hr class="card-divider" />

                                        <!-- Bottom Action Row (Photo 2) -->
                                        <div class="card-action-row">
                                            <%# Eval("RegSpotsHintHtml") %>

                                            <asp:LinkButton ID="btnViewDetails" runat="server" 
                                                CssClass="btn-view-details" 
                                                CommandName="ViewDetails" 
                                                CommandArgument='<%# Eval("EventId") %>'
                                                CausesValidation="false">
                                                <span>VIEW DETAILS &rarr;</span>
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

                <!-- ────────────────────────────────────────────────────────────
                     TAB 2 VIEW: MY REGISTERED EVENTS & PASSES
                     ──────────────────────────────────────────────────────────── -->
                <div class="registered-section-content" id="registeredContentArea">
                    <asp:Repeater ID="rptMyRegistrations" runat="server" OnItemCommand="rptMyRegistrations_ItemCommand">
                        <HeaderTemplate>
                            <div class="registered-table-wrapper">
                                <table class="registered-table">
                                    <thead>
                                        <tr>
                                            <th>Event Title</th>
                                            <th>Venue Location</th>
                                            <th>Event Date & Time</th>
                                            <th>Attendance Status</th>
                                            <th style="text-align: right;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div class="pass-event-title"><%# Eval("EventTitle") %></div>
                                </td>
                                <td><%# Eval("VenueLocation") %></td>
                                <td style="font-family: var(--font-mono); font-size: 0.82rem;"><%# Eval("EventDateFormatted") %></td>
                                <td>
                                    <span class='status-badge-reg <%# GetStatusBadgeCss(Eval("Status")?.ToString()) %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </td>
                                <td style="text-align: right; white-space: nowrap;">
                                    <a href='<%# ResolveUrl("~/Frontend/User/EventPass.aspx?regId=" + Eval("EventRegistrationId")) %>' 
                                       class="btn-view-details" 
                                       style="display: inline-flex; padding: 0.35rem 0.75rem; font-size: 0.75rem; margin-right: 0.5rem; text-decoration: none; vertical-align: middle;">
                                        VIEW PASS &rarr;
                                    </a>

                                    <asp:LinkButton ID="btnCancelRegistration" runat="server" 
                                        CssClass="btn-cancel-reg"
                                        CommandName="CancelRegistration" 
                                        CommandArgument='<%# Eval("EventRegistrationId") %>'
                                        Visible='<%# Eval("CanCancel") %>'
                                        OnClientClick="return confirm('Confirm cancellation of your attendance pass for this event?');"
                                        CausesValidation="false">
                                        CANCEL PASS
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                    </tbody>
                                </table>
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>

                    <!-- Empty State for Registered Passes -->
                    <asp:Panel ID="pnlNoRegistrations" runat="server" Visible="false" CssClass="empty-passes-box">
                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#64748B" stroke-width="1.75" style="margin-bottom: 1rem;">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                        <h4 style="font-size: 1.15rem; font-weight: 800; color: #FFFFFF; margin-bottom: 0.5rem;">No Active Event Registrations</h4>
                        <p style="color: var(--text-secondary); font-size: 0.9rem; max-width: 440px; margin: 0 auto 1.5rem auto;">
                            You have not booked electronic passes for any upcoming campus events yet. Explore open events above to register.
                        </p>
                        <button type="button" class="btn-view-details" onclick="switchTab('catalog')">
                            BROWSE OPEN EVENTS &rarr;
                        </button>
                    </asp:Panel>
                </div>
            </section>
        </main>

        <!-- ══════════════════════════════════════════════════════════════
             REGISTRATION & EVENT DETAILS MODAL DIALOG
             ══════════════════════════════════════════════════════════════ -->
        <asp:Panel ID="pnlModalDetails" runat="server" CssClass="modal-overlay" Visible="false">
            <div class="modal-box" role="dialog" aria-modal="true" aria-labelledby="modalEventTitle">
                <div class="modal-header">
                    <h4 id="modalEventTitle">Event Registration Details</h4>
                    <asp:LinkButton ID="btnCloseModal" runat="server" CssClass="modal-close-btn" OnClick="btnCloseModal_Click" CausesValidation="false">&times;</asp:LinkButton>
                </div>

                <div class="modal-body">
                    <div>
                        <h3 style="font-size: 1.35rem; font-weight: 800; color: #FFFFFF; margin-bottom: 0.5rem; text-transform: uppercase;">
                            <asp:Literal ID="litModalTitle" runat="server" />
                        </h3>
                        <p style="color: var(--text-secondary); font-size: 0.9rem; line-height: 1.55;">
                            <asp:Literal ID="litModalDescription" runat="server" />
                        </p>
                    </div>

                    <div class="modal-detail-grid">
                        <div class="modal-meta-box">
                            <div class="modal-meta-box-label">SCHEDULE & TIME</div>
                            <div class="modal-meta-box-val"><asp:Literal ID="litModalSchedule" runat="server" /></div>
                        </div>

                        <div class="modal-meta-box">
                            <div class="modal-meta-box-label">VENUE LOCATION</div>
                            <div class="modal-meta-box-val"><asp:Literal ID="litModalVenue" runat="server" /></div>
                        </div>

                        <div class="modal-meta-box">
                            <div class="modal-meta-box-label">AVAILABLE SEATS</div>
                            <div class="modal-meta-box-val"><asp:Literal ID="litModalCapacity" runat="server" /></div>
                        </div>

                        <div class="modal-meta-box">
                            <div class="modal-meta-box-label">REGISTRATION WINDOW</div>
                            <div class="modal-meta-box-val"><asp:Literal ID="litModalRegPeriod" runat="server" /></div>
                        </div>

                        <div class="modal-meta-box" style="grid-column: 1 / -1;">
                            <div class="modal-meta-box-label">OFFICIAL SPONSORS</div>
                            <div class="modal-meta-box-val"><asp:Literal ID="litModalSponsors" runat="server" Text="AWS, Microsoft" /></div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <asp:HiddenField ID="hfSelectedEventId" runat="server" />
                    <asp:Button ID="btnCancelModal" runat="server" Text="CLOSE" CssClass="btn-modal-cancel" OnClick="btnCloseModal_Click" CausesValidation="false" />
                    <asp:Button ID="btnConfirmRegistration" runat="server" Text="CONFIRM PASS REGISTRATION &rarr;" CssClass="btn-register-action" OnClick="btnConfirmRegistration_Click" />
                </div>
            </div>
        </asp:Panel>
    </form>

    <!-- Client-Side Scripting: Slide Switcher, Segmented Tabs, Category Filtering -->
    <script type="text/javascript">
        // ─── Hero Gallery Slide Carousel Data ───
        var heroSlides = [
            {
                title: "Cybersecurity and AI Convention",
                description: "Flagship cybersecurity conference and defensive hacking competition with enterprise penetration testers and student defense drills.",
                venue: "QCU Auditorium",
                date: "Oct 09, 2026",
                time: "10:00 AM - 03:00 PM",
                bgUrl: '<%= ResolveUrl("~/Frontend/Assets/hero_cyber_ai.jpg") %>'
            },
            {
                title: "AI & Cloud Architecture Workshop",
                description: "Deep dive into serverless cloud infrastructure, neural network deployments, and production container scaling with industry guest speakers.",
                venue: "QCU San Bartolome - Tech Lab 3",
                date: "Oct 09, 2026",
                time: "10:00 AM - 03:00 PM",
                bgUrl: '<%= ResolveUrl("~/Frontend/Assets/hero_cloud_lab.jpg") %>'
            },
            {
                title: "Tech & Innovation Summit",
                description: "Annual academic showcase bringing together university students and tech sponsors for student capstone demonstrations and keynote sessions.",
                venue: "QCU Main Campus - University Hall",
                date: "Nov 12, 2026",
                time: "08:30 AM - 04:30 PM",
                bgUrl: '<%= ResolveUrl("~/Frontend/Assets/campus-clean.jpg") %>'
            },
            {
                title: "Grand Org Fair & SportsFest",
                description: "Campus-wide student organization recruitment showcase, intramural games opening ceremony, and student creative exhibition.",
                venue: "QCU Main Plaza & Athletic Grounds",
                date: "Nov 20, 2026",
                time: "08:00 AM - 06:00 PM",
                bgUrl: '<%= ResolveUrl("~/Frontend/Assets/QCU Background.png") %>'
            }
        ];

        function selectHeroSlide(index) {
            if (index < 0 || index >= heroSlides.Length) {
                if (index < 0 || index >= heroSlides.length) return;
            }
            var data = heroSlides[index];

            var bg = document.getElementById("heroBgImage");
            if (bg) bg.style.backgroundImage = "url('" + data.bgUrl + "')";

            var t = document.getElementById("heroTitle");
            if (t) t.textContent = data.title;

            var d = document.getElementById("heroDescription");
            if (d) d.textContent = data.description;

            var v = document.getElementById("heroVenue");
            if (v) v.textContent = data.venue;

            var dt = document.getElementById("heroDate");
            if (dt) dt.textContent = data.date;

            var tm = document.getElementById("heroTime");
            if (tm) tm.textContent = data.time;

            for (var i = 0; i < heroSlides.length; i++) {
                var thumb = document.getElementById("heroThumb-" + i);
                if (thumb) {
                    if (i === index) {
                        thumb.classList.add("active-thumb");
                    } else {
                        thumb.classList.remove("active-thumb");
                    }
                }
            }
        }

        // ─── Segmented Tab Switcher ───
        function switchTab(viewName) {
            var catalogArea = document.getElementById("catalogContentArea");
            var registeredArea = document.getElementById("registeredContentArea");
            var tabCatalogBtn = document.getElementById("tabCatalogBtn");
            var tabRegisteredBtn = document.getElementById("tabRegisteredBtn");
            var titleElem = document.getElementById("viewSectionTitle");
            var subtitleElem = document.getElementById("viewSectionSubtitle");

            if (viewName === "registered") {
                if (catalogArea) catalogArea.classList.add("hidden-view");
                if (registeredArea) registeredArea.classList.add("active-view");

                if (tabCatalogBtn) tabCatalogBtn.classList.remove("active");
                if (tabRegisteredBtn) tabRegisteredBtn.classList.add("active");

                if (titleElem) titleElem.textContent = "My Registered Events & Passes";
                if (subtitleElem) subtitleElem.textContent = "Inspect your enrolled passes and verified event schedules.";
            } else {
                if (catalogArea) catalogArea.classList.remove("hidden-view");
                if (registeredArea) registeredArea.classList.remove("active-view");

                if (tabCatalogBtn) tabCatalogBtn.classList.add("active");
                if (tabRegisteredBtn) tabRegisteredBtn.classList.remove("active");

                if (titleElem) titleElem.textContent = "Campus Event Matrix";
                if (subtitleElem) subtitleElem.textContent = "Explore open registrations or inspect your booked electronic passes.";
            }
        }

        // ─── Category Filter Pills ───
        function filterByCategory(categoryKey, pillElem) {
            var pills = document.querySelectorAll(".cat-pill");
            pills.forEach(function (p) { p.classList.remove("active"); });
            if (pillElem) pillElem.classList.add("active");

            var cards = document.querySelectorAll(".event-card");
            var visibleCount = 0;

            cards.forEach(function (card) {
                var cardCat = card.getAttribute("data-category") || "";
                if (categoryKey === "all" || cardCat.toLowerCase() === categoryKey.toLowerCase()) {
                    card.style.display = "flex";
                    visibleCount++;
                } else {
                    card.style.display = "none";
                }
            });

            var countElem = document.getElementById("openEventsCount");
            if (countElem) {
                countElem.textContent = visibleCount + " OPEN";
            }
        }
    </script>
</body>
</html>
