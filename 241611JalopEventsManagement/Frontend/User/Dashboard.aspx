<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.User.Dashboard" EnableSessionState="ReadOnly" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <link rel="icon" type="image/png" href="<%= ResolveUrl("~/Frontend/Assets/QCU%20Logo.png") %>" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>University Event Portal | Quezon City University</title>
    
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/fonts.css?v=20261007") %>" />

    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/user/dashboard.css?v=" + DateTime.Now.Ticks) %>" />
    <link rel="stylesheet" href="<%= ResolveUrl("~/Frontend/Assets/css/toast.css") %>" />
</head>
<body>
    <form id="studentDashboardForm" runat="server">
        <!-- Top Standalone Navigation Bar -->
        <header class="portal-navbar" id="portalNavbar">
            <div class="navbar-inner">
                <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>" class="nav-brand">
                    <img src="<%= ResolveUrl("~/Frontend/Assets/QCU Logo.png") %>" alt="University Emblem" class="nav-logo-img" />
                    <div>
                        <div class="nav-brand-title">University Event Portal</div>
                        <div class="nav-brand-subtitle">Quezon City University</div>
                    </div>
                </a>

                <div class="nav-user-bar">
                    <a href="<%= ResolveUrl("~/Frontend/User/StudentProfile.aspx") %>" class="nav-user-badge" title="Manage Account Settings" style="text-decoration:none; color:inherit; cursor:pointer;">
                        <div class="nav-user-avatar">
                            <asp:Literal ID="litAvatarInitials" runat="server" Text="ST" />
                        </div>
                        <div class="nav-user-info">
                            <span class="nav-user-name"><asp:Literal ID="litStudentName" runat="server" Text="Student" /></span>
                            <span class="nav-user-id">[ <asp:Literal ID="litStudentId" runat="server" Text="" /> ]</span>
                        </div>
                    </a>

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

        <!-- ══════════════════════════════════════════════════════════════
             HERO SECTION: FULL VIEWPORT HERO SHOWCASE
             ══════════════════════════════════════════════════════════════ -->
        <!-- ══════════════════════════════════════════════════════════════
             HERO SECTION: FULL VIEWPORT HERO SHOWCASE (DYNAMICALLY BOUND)
             ══════════════════════════════════════════════════════════════ -->
        <section class="hero-showcase-container" id="heroGallery" style="<%= HeroSlidesJson == "[]" ? "display:none;" : "" %>">
            <!-- Background Image Layer & Dark Vignette Overlay -->
            <div class="hero-bg-layer" id="heroBgImage"></div>
            <div class="hero-overlay-layer"></div>

            <!-- Main Hero Headline & Metadata -->
            <div class="hero-body-content" id="heroBodyContent">
                <h1 class="hero-title" id="heroTitle">--</h1>
                <p class="hero-description" id="heroDescription">--</p>

                <div class="hero-meta-list">
                    <div class="hero-meta-item">
                        <svg class="hero-meta-icon" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
                        </svg>
                        <span id="heroVenue">--</span>
                    </div>

                    <div class="hero-meta-item">
                        <svg class="hero-meta-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                            <path d="M8 14h.01M12 14h.01M16 14h.01M8 18h.01M12 18h.01M16 18h.01" stroke-width="2.8"></path>
                        </svg>
                        <span id="heroDate">--</span>
                    </div>

                    <div class="hero-meta-item">
                        <svg class="hero-meta-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="10"></circle>
                            <polyline points="12 6 12 12 16 12"></polyline>
                        </svg>
                        <span id="heroTime">--</span>
                    </div>
                </div>

                <div style="margin-top:1.5rem; display:flex; align-items:center; gap:1rem;">
                    <a id="heroActionBtn" href="#events-section" class="btn-hero-action">
                        <span>VIEW EVENT &amp; REGISTER</span>
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                        </svg>
                    </a>
                </div>
            </div>

            <!-- Hero Carousel Bottom Bar Controls -->
            <div class="hero-carousel-controls">
                <div class="hero-carousel-dots" id="heroCarouselDots"></div>
                <div class="hero-carousel-nav-arrows">
                    <button type="button" class="hero-arrow-btn" onclick="prevHeroSlide()" aria-label="Previous Slide">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <polyline points="15 18 9 12 15 6"></polyline>
                        </svg>
                    </button>
                    <button type="button" class="hero-arrow-btn" onclick="nextHeroSlide()" aria-label="Next Slide">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </button>
                </div>
            </div>
        </section>

        <!-- Main Workspace -->
        <main class="portal-main">
            <!-- Toast Feedback Notification -->
            <asp:Panel ID="pnlToast" runat="server" Visible="false" CssClass="toast-banner">
                <asp:Literal ID="litToastMsg" runat="server" />
            </asp:Panel>

            <!-- Student Demographic Identity Hidden PlaceHolder -->
            <asp:PlaceHolder ID="phStudentCohort" runat="server" Visible="false">
                <asp:Literal ID="litCampusBranch" runat="server" />
                <asp:Literal ID="litDepartment" runat="server" />
                <asp:Literal ID="litProgram" runat="server" />
                <asp:Literal ID="litYearLevel" runat="server" />
            </asp:PlaceHolder>

            <!-- ══════════════════════════════════════════════════════════════
                 VIEW ALL EVENTS & TAB-LIKE TOGGLE SECTION
                 ══════════════════════════════════════════════════════════════ -->
            <section class="events-view-section" id="events-section">
                <!-- Section Header Row & Segmented Tab Toggle -->
                <div class="section-header-row">
                    <div class="section-title-block">
                        <h2 id="viewSectionTitle">Campus Events</h2>
                        <p id="viewSectionSubtitle">Explore open registrations or inspect your booked electronic passes.</p>
                    </div>

                    <!-- Tab-like Toggle (Modern Segmented Control) -->
                    <div class="tab-toggle-container">
                        <button type="button" class="tab-btn active" id="tabCatalogBtn" onclick="switchTab('catalog')">
                            <span>Available Events</span>
                        </button>
                        <button type="button" class="tab-btn" id="tabRegisteredBtn" onclick="switchTab('registered')">
                            <span>My Registered Events</span>
                        </button>
                    </div>
                </div>

                <!-- ────────────────────────────────────────────────────────────
                     TAB 1 VIEW: ALL OPEN EVENTS CATALOG
                     ──────────────────────────────────────────────────────────── -->
                <div class="events-catalog-content" id="catalogContentArea">
                    <asp:Panel ID="pnlNoEligibleEvents" runat="server" Visible="false" CssClass="empty-passes-box">
                        <h3>No eligible events available</h3>
                        <p>Return later for events open to your campus and academic group.</p>
                    </asp:Panel>
                    <!-- ────────────────────────────────────────────────────────────
                         EVENT CARDS GRID: ORGANIZATION OF PHOTO 2 WITH CINEMATIC STYLING
                         ──────────────────────────────────────────────────────────── -->
                    <div class="events-grid" id="eventsGridContainer">
                        <asp:Repeater ID="rptEventCards" runat="server" OnItemCommand="rptEventCards_ItemCommand">
                            <ItemTemplate>
                                <div class="event-card" data-category='<%# Eval("CategoryFilterKey") %>' id='card-<%# Eval("EventId") %>'>
                                    <!-- Top Half: Promotional Banner Area -->
                                    <div class="event-promo-banner" style='background-image: url("<%# Eval("BannerImageUrl") %>");'>
                                        <!-- Status Indicator (Top-Left of Banner) -->
                                        <%# Eval("RegStatusBadgeHtml") %>
                                    </div>

                                    <!-- Bottom Half: Event Details -->
                                    <div class="event-card-body">
                                        <!-- Event Title: Prominent, Crisp, High-Contrast -->
                                        <h3 class="card-event-name"><%# Eval("Title") %></h3>
                                        
                                        <!-- Location Line with Pin Icon -->
                                        <div class="card-meta-line">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                                <circle cx="12" cy="10" r="3"></circle>
                                            </svg>
                                            <span><%# Eval("VenueLocation") %></span>
                                        </div>

                                        <!-- Date Line with Calendar Icon -->
                                        <div class="card-meta-line">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                                <line x1="3" y1="10" x2="21" y2="10"></line>
                                            </svg>
                                            <span><%# Eval("FormattedDate") %></span>
                                        </div>

                                        <!-- Time Line with Clock Icon -->
                                        <div class="card-meta-line">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                            <span><%# Eval("FormattedTime") %></span>
                                        </div>

                                        <!-- Sponsors Row -->
                                        <div class="card-sponsors-row">
                                            <span class="sponsor-label">SPONSORS:</span>
                                            <%# Eval("SponsorBadgesHtml") %>
                                        </div>

                                        <!-- Bottom Action Row -->
                                        <div class="card-action-row">
                                            <button type="button" class="btn-view-details" onclick='openEventDetailsModal(<%# Eval("EventId") %>)'>
                                                <span>VIEW DETAILS &rarr;</span>
                                            </button>
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
                            <div class="events-grid registered-cards-grid">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="event-card registered-pass-card" id='reg-card-<%# Eval("EventRegistrationId") %>'>
                                <!-- Top Half: Promotional Banner Area (Identical to event-card) -->
                                <div class="event-promo-banner" style='background-image: url("<%# Eval("BannerImageUrl") %>");'>
                                    <!-- Status Indicator (Top-Left of Banner) -->
                                    <%# Eval("RegStatusBadgeHtml") %>
                                </div>

                                <!-- Bottom Half: Event Details (Identical to event-card) -->
                                <div class="event-card-body">
                                    <!-- Event Title: Prominent, Crisp, High-Contrast -->
                                    <h3 class="card-event-name"><%# Eval("EventTitle") %></h3>

                                    <!-- Location Line with Pin Icon -->
                                    <div class="card-meta-line">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                            <circle cx="12" cy="10" r="3"></circle>
                                        </svg>
                                        <span><%# Eval("VenueLocation") %></span>
                                    </div>

                                    <!-- Date Line with Calendar Icon -->
                                    <div class="card-meta-line">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                        </svg>
                                        <span><%# Eval("FormattedDate") %></span>
                                    </div>

                                    <!-- Time Line with Clock Icon -->
                                    <div class="card-meta-line">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 12 16 14"></polyline>
                                        </svg>
                                        <span><%# Eval("FormattedTime") %></span>
                                    </div>


                                    <!-- Bottom Action Row: Aligned Right with View Pass and Cancel Option -->
                                    <div class="card-action-row pass-card-action-row">
                                        <asp:LinkButton ID="btnCancelRegistration" runat="server" 
                                            CssClass="btn-pass-cancel"
                                            CommandName="CancelRegistration" 
                                            CommandArgument='<%# Eval("EventRegistrationId") %>'
                                            Visible='<%# Eval("CanCancel") %>'
                                            OnClientClick="return confirm('Confirm cancellation of your attendance pass for this event?');"
                                            CausesValidation="false"
                                            ToolTip="Release reserved seat registration">
                                            <span>Cancel Pass</span>
                                        </asp:LinkButton>

                                        <a href='<%# ResolveUrl("~/Frontend/User/EventPass.aspx?regId=" + Eval("EventRegistrationId")) %>' class="btn-view-details">
                                            <span>VIEW PASS &amp; QR &rarr;</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
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

        <!-- Hidden controls retained invisibly for designer & code-behind compatibility -->
        <asp:PlaceHolder ID="phModalHidden" runat="server" Visible="false">
            <asp:Panel ID="pnlModalDetails" runat="server">
                <asp:LinkButton ID="btnCloseModal" runat="server" />
                <asp:Literal ID="litModalTitle" runat="server" />
                <asp:Literal ID="litModalDescription" runat="server" />
                <asp:Literal ID="litModalSchedule" runat="server" />
                <asp:Literal ID="litModalVenue" runat="server" />
                <asp:Literal ID="litModalCapacity" runat="server" />
                <asp:Literal ID="litModalRegPeriod" runat="server" />
                <asp:Literal ID="litModalSponsors" runat="server" />
                <asp:HiddenField ID="hfSelectedEventId" runat="server" />
                <asp:Button ID="btnCancelModal" runat="server" />
                <asp:Button ID="btnConfirmRegistration" runat="server" />
            </asp:Panel>
        </asp:PlaceHolder>

        <!-- ══════════════════════════════════════════════════════════════
             EVENT DETAILS INTERACTIVE MODAL DIALOG
             ══════════════════════════════════════════════════════════════ -->
        <div id="modalEventDetails" class="event-modal-backdrop" onclick="handleModalBackdropClick(event)">
            <div class="event-modal-dialog" role="dialog" aria-modal="true" aria-labelledby="modalEventTitle">
                <!-- Banner Header with gradient overlay -->
                <div class="modal-banner-header" id="modalBannerHeader">
                    <div class="modal-banner-gradient"></div>

                    <!-- Close Button (Top-Right) -->
                    <button type="button" class="modal-close-btn" onclick="closeEventDetailsModal()" aria-label="Close Modal" title="Close details">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                    </button>

                    <!-- Status Badge (Top-Left) -->
                    <div id="modalRegStatusBadge" class="modal-status-badge-container"></div>

                    <!-- Capacity Indicator (Bottom-Right) -->
                    <div class="modal-capacity-pill" id="modalCapacityBadge">
                        <svg class="capacity-pill-icon" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                        </svg>
                        <span id="modalCapacityBadgeText">-- SEATS</span>
                    </div>
                </div>

                <!-- Modal Body Content -->
                <div class="modal-body-content">
                    <div>
                        <h2 class="modal-event-title" id="modalEventTitle">--</h2>
                    </div>

                    <!-- 4-item grid of specifications -->
                    <div class="modal-specs-grid">
                        <div class="modal-spec-card">
                            <div class="modal-spec-label">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>Date &amp; Schedule</span>
                            </div>
                            <div class="modal-spec-val" id="modalEventDate">--</div>
                            <div class="modal-spec-sub" id="modalEventTime">--</div>
                        </div>

                        <div class="modal-spec-card">
                            <div class="modal-spec-label">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                    <circle cx="12" cy="10" r="3"></circle>
                                </svg>
                                <span>Location &amp; Venue</span>
                            </div>
                            <div class="modal-spec-val" id="modalEventVenue">--</div>
                            <div class="modal-spec-sub">Quezon City University</div>
                        </div>

                        <div class="modal-spec-card">
                            <div class="modal-spec-label">
                                <svg viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                                </svg>
                                <span>Live Capacity</span>
                            </div>
                            <div class="modal-spec-val" id="modalEventSeats">--</div>
                            <div class="modal-capacity-progress">
                                <div class="modal-capacity-bar" id="modalCapacityBar" style="width: 0%;"></div>
                            </div>
                        </div>

                        <div class="modal-spec-card">
                            <div class="modal-spec-label">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polyline points="12 6 12 12 16 14"></polyline>
                                </svg>
                                <span>Registration Window</span>
                            </div>
                            <div class="modal-spec-val" id="modalRegPeriod">--</div>
                            <div class="modal-spec-sub" id="modalRegStatusText">Open for Enrolled Students</div>
                        </div>
                    </div>

                    <!-- Event Description Block -->
                    <div class="modal-desc-block">
                        <div class="modal-desc-heading">About This Campus Event</div>
                        <p class="modal-desc-text" id="modalEventDescription">--</p>
                    </div>

                    <!-- Sponsors Block -->
                    <div class="modal-sponsors-block" id="modalSponsorsArea">
                        <span class="modal-sponsors-label">PARTNERS &amp; SPONSORS:</span>
                        <div id="modalSponsorsBadges" style="display:inline-flex; flex-wrap:wrap; gap:0.4rem;"></div>
                    </div>
                </div>

                <!-- Modal Footer -->
                <div class="modal-footer-actions">
                    <button type="button" class="btn-modal-cancel" onclick="closeEventDetailsModal()">Close</button>
                    <a id="modalRegisterBtn" href="#" class="btn-modal-register">
                        <span>Register to this event</span>
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                        </svg>
                    </a>
                </div>
            </div>
        </div>

        <!-- Enterprise Floating Lower-Right Toast Container -->
        <div id="appToastContainer" class="app-toast-container" aria-live="polite" aria-atomic="true"></div>
    </form>

    <!-- Client-Side Scripting: Auto Slide Carousel, Event Details Modal, Tabs, Category Filtering -->
    <script type="text/javascript">
        // ─── Data Bound from Server ───
        var heroSlides = <%= HeroSlidesJson %>;
        var eventsCatalog = <%= EventsCatalogJson %>;

        var currentSlideIndex = 0;
        var slideTimer = null;
        var SLIDE_DURATION = 5000; // 5 seconds per slide

        function escapeHtml(str) {
            if (!str) return '';
            return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
        }

        // ─── Auto Slide Carousel Controls ───
        function renderHeroDots() {
            var dotsContainer = document.getElementById("heroCarouselDots");
            if (!dotsContainer || !heroSlides || heroSlides.length === 0) return;
            dotsContainer.innerHTML = "";

            for (var i = 0; i < heroSlides.length; i++) {
                var btn = document.createElement("button");
                btn.type = "button";
                btn.className = "hero-dot-btn" + (i === currentSlideIndex ? " active" : "");
                btn.id = "heroDot-" + i;
                btn.setAttribute("aria-label", "Go to slide " + (i + 1));
                btn.setAttribute("onclick", "goToHeroSlide(" + i + ")");
                dotsContainer.appendChild(btn);
            }
        }

        function updateHeroDots(index) {
            for (var i = 0; i < heroSlides.length; i++) {
                var dot = document.getElementById("heroDot-" + i);
                if (dot) {
                    if (i === index) {
                        dot.classList.add("active");
                    } else {
                        dot.classList.remove("active");
                    }
                }
            }
        }

        function selectHeroSlide(index) {
            if (!heroSlides || heroSlides.length === 0) return;
            if (index < 0) index = heroSlides.length - 1;
            if (index >= heroSlides.length) index = 0;

            currentSlideIndex = index;
            var data = heroSlides[index];

            var bg = document.getElementById("heroBgImage");
            if (bg) {
                bg.style.backgroundImage = "url('" + data.bgUrl + "')";
            }

            var bodyContent = document.getElementById("heroBodyContent");
            if (bodyContent) {
                bodyContent.classList.add("slide-transitioning");
                setTimeout(function () {
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

                    var btn = document.getElementById("heroActionBtn");
                    if (btn) {
                        var heroEvent = eventsCatalog.find(function (event) { return event.id == data.id; });
                        setRegistrationLinkAvailability(btn, heroEvent);
                    }

                    bodyContent.classList.remove("slide-transitioning");
                }, 150);
            }

            updateHeroDots(index);
        }

        function nextHeroSlide() {
            var nextIdx = (currentSlideIndex + 1) % (heroSlides.length || 1);
            selectHeroSlide(nextIdx);
            restartAutoSlide();
        }

        function prevHeroSlide() {
            var prevIdx = (currentSlideIndex - 1 + (heroSlides.length || 1)) % (heroSlides.length || 1);
            selectHeroSlide(prevIdx);
            restartAutoSlide();
        }

        function goToHeroSlide(index) {
            selectHeroSlide(index);
            restartAutoSlide();
        }

        function startAutoSlide() {
            stopAutoSlide();
            if (heroSlides && heroSlides.length > 1) {
                slideTimer = setInterval(function () {
                    var nextIdx = (currentSlideIndex + 1) % heroSlides.length;
                    selectHeroSlide(nextIdx);
                }, SLIDE_DURATION);
            }
        }

        function stopAutoSlide() {
            if (slideTimer) {
                clearInterval(slideTimer);
                slideTimer = null;
            }
        }

        function restartAutoSlide() {
            stopAutoSlide();
            startAutoSlide();
        }

        // ─── Event Details Modal Logic ───
        function setRegistrationLinkAvailability(link, event) {
            var isOpen = event && event.isRegistrationOpen === true;
            link.style.display = isOpen ? "" : "none";
            if (isOpen) {
                link.href = event.regUrl;
            } else {
                link.removeAttribute("href");
            }
        }

        function openEventDetailsModal(eventId) {
            var ev = null;
            if (eventsCatalog && eventsCatalog.length > 0) {
                for (var i = 0; i < eventsCatalog.length; i++) {
                    if (eventsCatalog[i].id == eventId) {
                        ev = eventsCatalog[i];
                        break;
                    }
                }
            }

            if (!ev) {
                // Redirect directly to registration page as seamless fallback
                window.location.href = '<%= ResolveUrl("~/Frontend/User/EventRegistration.aspx?eventId=") %>' + eventId;
                return;
            }

            // Populate Banner
            var bannerHeader = document.getElementById("modalBannerHeader");
            if (bannerHeader) {
                bannerHeader.style.backgroundImage = "url('" + (ev.bannerUrl || '<%= ResolveUrl("~/Frontend/Assets/hero_cyber_ai.jpg") %>') + "')";
            }

            // Status Badge & Capacity Pill
            var regBadge = document.getElementById("modalRegStatusBadge");
            if (regBadge) {
                regBadge.innerHTML = ev.regStatusBadgeHtml || '<span class="status-badge-open">OPEN</span>';
            }

            var capPill = document.getElementById("modalCapacityBadgeText");
            if (capPill) {
                capPill.textContent = (ev.currentRegistrations || 0) + "/" + (ev.capacity || 0) + " SEATS";
            }

            // Title & Specs
            var title = document.getElementById("modalEventTitle");
            if (title) title.textContent = ev.title;

            var dt = document.getElementById("modalEventDate");
            if (dt) dt.textContent = ev.dateFormatted || ev.schedule || "TBA";

            var tm = document.getElementById("modalEventTime");
            if (tm) tm.textContent = ev.timeFormatted || "";

            var venue = document.getElementById("modalEventVenue");
            if (venue) venue.textContent = ev.venue || "Campus Venue";

            var seats = document.getElementById("modalEventSeats");
            if (seats) {
                var remaining = ev.remainingSpots != null ? ev.remainingSpots : Math.max(0, (ev.capacity || 0) - (ev.currentRegistrations || 0));
                seats.textContent = remaining + " Spots Remaining (" + (ev.currentRegistrations || 0) + " Filled)";
            }

            var capBar = document.getElementById("modalCapacityBar");
            if (capBar) {
                var percent = ev.capacity > 0 ? Math.min(100, Math.round(((ev.currentRegistrations || 0) / ev.capacity) * 100)) : 0;
                capBar.style.width = percent + "%";
            }

            var regPeriod = document.getElementById("modalRegPeriod");
            if (regPeriod) {
                regPeriod.textContent = (ev.regStart && ev.regEnd) ? (ev.regStart + " - " + ev.regEnd) : "Registration Open";
            }

            // Description
            var desc = document.getElementById("modalEventDescription");
            if (desc) {
                desc.textContent = ev.description || "Join us for this exciting campus activity. Register to confirm your seat and receive your digital QR pass.";
            }

            // Sponsors Badges
            var sponsorsBadges = document.getElementById("modalSponsorsBadges");
            if (sponsorsBadges) {
                sponsorsBadges.innerHTML = "";
                if (ev.sponsors && ev.sponsors.length > 0) {
                    for (var s = 0; s < ev.sponsors.length; s++) {
                        var span = document.createElement("span");
                        span.className = "sponsor-badge";
                        span.textContent = ev.sponsors[s];
                        sponsorsBadges.appendChild(span);
                    }
                } else {
                    var span = document.createElement("span");
                    span.className = "sponsor-badge";
                    span.textContent = "Quezon City University";
                    sponsorsBadges.appendChild(span);
                }
            }

            // Only open events expose navigation to the registration wizard.
            var regBtn = document.getElementById("modalRegisterBtn");
            if (regBtn) {
                setRegistrationLinkAvailability(regBtn, ev);
                regBtn.closest(".modal-footer-actions").style.display = ev.isRegistrationOpen ? "" : "none";
            }

            // Show Modal
            var modal = document.getElementById("modalEventDetails");
            if (modal) {
                modal.classList.add("active");
                document.body.style.overflow = "hidden";
            }
        }

        function closeEventDetailsModal() {
            var modal = document.getElementById("modalEventDetails");
            if (modal) {
                modal.classList.remove("active");
                document.body.style.overflow = "";
            }
        }

        function handleModalBackdropClick(e) {
            if (e.target && e.target.id === "modalEventDetails") {
                closeEventDetailsModal();
            }
        }

        document.addEventListener("keydown", function (e) {
            if (e.key === "Escape" || e.keyCode === 27) {
                closeEventDetailsModal();
            }
        });

        // ─── DOM Ready Initializations ───
        document.addEventListener("DOMContentLoaded", function () {
            renderHeroDots();
            selectHeroSlide(0);
            startAutoSlide();

            // Hover pause listeners on hero
            var heroEl = document.getElementById("heroGallery");
            if (heroEl) {
                heroEl.addEventListener("mouseenter", stopAutoSlide);
                heroEl.addEventListener("mouseleave", startAutoSlide);
            }
        });

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

        // ─── Dynamic Header Transparency on Hero Section ───
        function handleNavbarScroll() {
            var navbar = document.getElementById("portalNavbar");
            var hero = document.getElementById("heroGallery");
            if (!navbar) return;

            if (!hero) {
                navbar.classList.add("nav-scrolled");
                return;
            }

            var heroRect = hero.getBoundingClientRect();
            if (heroRect.bottom <= 70) {
                navbar.classList.add("nav-scrolled");
            } else {
                navbar.classList.remove("nav-scrolled");
            }
        }

        window.addEventListener("scroll", handleNavbarScroll, { passive: true });
        window.addEventListener("resize", handleNavbarScroll);
        document.addEventListener("DOMContentLoaded", handleNavbarScroll);
        handleNavbarScroll();
    </script>

    <!-- Universal Toast Engine -->
    <script type="text/javascript" src="<%= ResolveUrl("~/Frontend/Assets/js/toast.js") %>"></script>
</body>
</html>
