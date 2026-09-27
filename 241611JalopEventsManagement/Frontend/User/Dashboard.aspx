<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="_241611JalopEventsManagement.Frontend.User.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>QCU Campus Events | Student Portal</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@600;700;800;900&family=JetBrains+Mono:wght@600;700;800&display=swap" rel="stylesheet" />

    <style>
        :root {
            /* User Restricted Palette */
            --nb-black: #000000;
            --nb-canvas: #FAF7EE;
            --nb-card-bg: #FFFFFF;
            --nb-surface-subtle: #FFFDF7;
            --nb-yellow: #FFDE59;
            --nb-yellow-hover: #FACC15;
            --nb-lime: #A6F4C5;
            --nb-lime-hover: #86EFAC;
            --nb-border: 2px solid #000000;
            --nb-border-sm: 1.5px solid #000000;
            --font-sans: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            --font-mono: 'JetBrains Mono', monospace;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--nb-canvas);
            color: var(--nb-black);
            font-family: var(--font-sans);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            -webkit-font-smoothing: antialiased;
            background-image: 
                radial-gradient(rgba(0, 0, 0, 0.12) 1.25px, transparent 1.25px),
                radial-gradient(rgba(0, 0, 0, 0.05) 1.25px, var(--nb-canvas) 1.25px);
            background-size: 24px 24px;
            background-position: 0 0, 12px 12px;
        }

        /* ─── Top Navigation Bar (Flat, no small shadows) ─── */
        .portal-nav {
            background-color: #FFFFFF;
            border-bottom: var(--nb-border);
            position: sticky;
            top: 0;
            z-index: 50;
        }

        .nav-inner {
            max-width: 1360px;
            margin: 0 auto;
            padding: 0 1.5rem;
            height: 72px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.5rem;
        }

        .nav-brand {
            display: flex;
            align-items: center;
            gap: 0.85rem;
            text-decoration: none;
            color: var(--nb-black);
        }

        .nav-logo-img {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            object-fit: cover;
            border: var(--nb-border);
            background: #FFFFFF;
            padding: 2px;
        }

        .nav-brand-title {
            font-size: 1.2rem;
            font-weight: 900;
            color: var(--nb-black);
            letter-spacing: -0.03em;
            line-height: 1.1;
            text-transform: uppercase;
        }

        .nav-brand-badge {
            display: inline-block;
            font-family: var(--font-mono);
            font-size: 0.68rem;
            background-color: var(--nb-yellow);
            color: #000000;
            font-weight: 800;
            padding: 0.1rem 0.45rem;
            border: 1.5px solid #000000;
            border-radius: 4px;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .nav-center-menu {
            display: flex;
            align-items: center;
            gap: 0.65rem;
            list-style: none;
        }

        .nav-menu-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            padding: 0.45rem 0.95rem;
            background-color: #FFFFFF;
            border: var(--nb-border);
            border-radius: 8px;
            font-family: var(--font-mono);
            font-size: 0.8rem;
            font-weight: 800;
            color: #000000;
            text-decoration: none;
            cursor: pointer;
            text-transform: uppercase;
            transition: background-color 0.1s ease;
        }

        .nav-menu-btn:hover {
            background-color: var(--nb-canvas);
        }

        .nav-menu-btn.active {
            background-color: var(--nb-yellow);
        }

        /* ─── Student Profile Chip in Navbar (Flat, no shadow) ─── */
        .nav-user-chip {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.3rem 0.6rem 0.3rem 0.4rem;
            background-color: #FFFFFF;
            border: var(--nb-border);
            border-radius: 10px;
        }

        .user-avatar-circle {
            width: 34px;
            height: 34px;
            background-color: var(--nb-yellow);
            color: #000000;
            font-weight: 900;
            font-size: 0.85rem;
            border-radius: 6px;
            border: 1.5px solid #000000;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .user-details {
            display: flex;
            flex-direction: column;
            line-height: 1.15;
        }

        .user-fullname {
            font-size: 0.82rem;
            font-weight: 800;
            color: #000000;
            text-transform: uppercase;
        }

        .user-meta {
            font-size: 0.68rem;
            color: #000000;
            font-family: var(--font-mono);
            font-weight: 700;
        }

        .btn-signout {
            background: var(--nb-canvas);
            border: 1.5px solid #000000;
            color: #000000;
            cursor: pointer;
            padding: 0.35rem;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.1s ease;
        }

        .btn-signout:hover {
            background-color: var(--nb-yellow);
        }

        /* ─── Preview Notification Banner (Flat) ─── */
        .preview-banner {
            background-color: var(--nb-yellow);
            border-bottom: var(--nb-border);
            color: #000000;
            padding: 0.6rem 1.5rem;
            font-size: 0.82rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .preview-banner a {
            color: #000000;
            font-family: var(--font-mono);
            font-weight: 800;
            background: #FFFFFF;
            padding: 0.2rem 0.6rem;
            border: 1.5px solid #000000;
            border-radius: 6px;
            text-decoration: none;
            display: inline-block;
        }

        /* ─── Main Content Canvas ─── */
        .portal-main {
            max-width: 1360px;
            margin: 0 auto;
            padding: 2rem 1.5rem 4.5rem 1.5rem;
            width: 100%;
            flex: 1;
        }

        /* ─── Toast Feedback Notification (Only structural 3px shadow) ─── */
        .toast-banner {
            padding: 0.85rem 1.15rem;
            border: var(--nb-border);
            border-radius: 10px;
            margin-bottom: 1.75rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 0.88rem;
            font-weight: 800;
            box-shadow: 3px 3px 0px #000000;
        }

        .toast-success {
            background-color: var(--nb-lime);
            color: #000000;
        }

        .toast-error {
            background-color: var(--nb-surface-subtle);
            color: #000000;
        }

        /* ════════════════════════════════════════════════════════════════
           HERO SECTION: EDITORIAL CAMPUS GALLERY
           ════════════════════════════════════════════════════════════════ */
        .hero-gallery-section {
            margin-bottom: 2.75rem;
        }

        .gallery-top-badge-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 0.85rem;
            flex-wrap: wrap;
            gap: 0.75rem;
        }

        .ticker-pill-main {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background-color: #000000;
            color: #FFFFFF;
            padding: 0.3rem 0.85rem;
            border-radius: 9999px;
            font-family: var(--font-mono);
            font-size: 0.74rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .ticker-pill-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background-color: var(--nb-lime);
        }

        .gallery-controls-nav {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .gallery-nav-btn {
            background-color: #FFFFFF;
            border: var(--nb-border);
            border-radius: 6px;
            padding: 0.3rem 0.75rem;
            font-family: var(--font-mono);
            font-size: 0.74rem;
            font-weight: 800;
            cursor: pointer;
            text-transform: uppercase;
            transition: background-color 0.1s ease;
        }

        .gallery-nav-btn:hover {
            background-color: var(--nb-yellow);
        }

        /* ─── Hero Spotlight Card (Container has 4px 4px 0px #000) ─── */
        .hero-spotlight-card {
            background: #FFFFFF;
            border: var(--nb-border);
            border-radius: 16px;
            box-shadow: 4px 4px 0px #000000;
            overflow: hidden;
            display: grid;
            grid-template-columns: 1.15fr 1fr;
            margin-bottom: 1.25rem;
            position: relative;
        }

        @media (max-width: 900px) {
            .hero-spotlight-card {
                grid-template-columns: 1fr;
            }
        }

        .spotlight-banner-area {
            background-color: var(--nb-yellow);
            border-right: var(--nb-border);
            padding: 2rem 2rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            min-height: 300px;
            transition: background-color 0.2s ease;
        }

        @media (max-width: 900px) {
            .spotlight-banner-area {
                border-right: none;
                border-bottom: var(--nb-border);
                min-height: auto;
            }
        }

        .spotlight-top-tags {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.75rem;
            flex-wrap: wrap;
            margin-bottom: 1.25rem;
        }

        .spotlight-category-badge {
            background-color: #FFFFFF;
            border: var(--nb-border);
            border-radius: 9999px;
            padding: 0.3rem 0.85rem;
            font-family: var(--font-mono);
            font-size: 0.78rem;
            font-weight: 800;
            text-transform: uppercase;
        }

        .spotlight-live-tag {
            background-color: #000000;
            color: #FFFFFF;
            border-radius: 9999px;
            padding: 0.3rem 0.75rem;
            font-family: var(--font-mono);
            font-size: 0.7rem;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .spotlight-center-art {
            margin: auto 0;
            text-align: left;
        }

        .spotlight-subheading {
            font-family: var(--font-mono);
            font-size: 0.78rem;
            font-weight: 800;
            color: #000000;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.35rem;
        }

        .spotlight-title {
            font-size: 2.15rem;
            font-weight: 900;
            letter-spacing: -0.03em;
            line-height: 1.1;
            color: var(--nb-black);
            margin-bottom: 0.65rem;
            text-transform: uppercase;
        }

        .spotlight-bottom-chips {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            flex-wrap: wrap;
            margin-top: 1rem;
        }

        .spotlight-chip {
            background-color: #FFFFFF;
            border: 1.5px solid #000000;
            border-radius: 6px;
            padding: 0.2rem 0.55rem;
            font-family: var(--font-mono);
            font-size: 0.7rem;
            font-weight: 700;
            color: #000000;
        }

        /* ─── Right Details Area in Spotlight ─── */
        .spotlight-details-area {
            padding: 2rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            background-color: #FFFFFF;
        }

        .spotlight-desc {
            font-size: 0.92rem;
            color: #000000;
            line-height: 1.55;
            margin-bottom: 1.25rem;
            font-weight: 500;
        }

        .spotlight-meta-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
        }

        .meta-box {
            background-color: var(--nb-surface-subtle);
            border: 1.5px solid #000000;
            border-radius: 8px;
            padding: 0.65rem 0.8rem;
        }

        .meta-box-label {
            font-family: var(--font-mono);
            font-size: 0.66rem;
            font-weight: 800;
            color: #000000;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-bottom: 0.15rem;
        }

        .meta-box-val {
            font-size: 0.85rem;
            font-weight: 800;
            color: var(--nb-black);
            line-height: 1.25;
        }

        .spotlight-actions-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            flex-wrap: wrap;
            padding-top: 1rem;
            border-top: 1.5px dashed #000000;
        }

        .spotlight-capacity-pill {
            background-color: var(--nb-lime);
            border: 1.5px solid #000000;
            border-radius: 9999px;
            padding: 0.3rem 0.75rem;
            font-family: var(--font-mono);
            font-size: 0.75rem;
            font-weight: 800;
        }

        /* ─── Tactile Button Interactions (Box shadow strictly on action buttons) ─── */
        .btn-tactile-action {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background-color: var(--nb-yellow);
            color: #000000;
            font-family: var(--font-sans);
            font-size: 0.88rem;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            padding: 0.75rem 1.35rem;
            border: var(--nb-border);
            border-radius: 8px;
            box-shadow: 3px 3px 0px #000000;
            cursor: pointer;
            text-decoration: none;
            transition: transform 0.08s ease, box-shadow 0.08s ease, background-color 0.1s ease;
        }

        .btn-tactile-action:hover {
            background-color: var(--nb-yellow-hover);
        }

        .btn-tactile-action:active {
            transform: translate(3px, 3px);
            box-shadow: 0px 0px 0px #000000;
        }

        /* ─── Gallery Thumbnail Selector Rail (Flat, no shadow on cards) ─── */
        .gallery-rail-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 0.85rem;
        }

        @media (max-width: 992px) {
            .gallery-rail-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 550px) {
            .gallery-rail-grid {
                grid-template-columns: 1fr;
            }
        }

        .gallery-thumb-card {
            background: #FFFFFF;
            border: var(--nb-border);
            border-radius: 12px;
            padding: 0.85rem;
            cursor: pointer;
            transition: background-color 0.12s ease;
        }

        .gallery-thumb-card:hover {
            background-color: var(--nb-canvas);
        }

        .gallery-thumb-card.active-slide {
            background-color: var(--nb-yellow);
        }

        .gallery-thumb-badge {
            font-family: var(--font-mono);
            font-size: 0.66rem;
            font-weight: 800;
            padding: 0.12rem 0.45rem;
            border-radius: 9999px;
            border: 1.5px solid #000000;
            display: inline-block;
            margin-bottom: 0.4rem;
            background: #FFFFFF;
        }

        .gallery-thumb-title {
            font-size: 0.84rem;
            font-weight: 800;
            line-height: 1.25;
            color: #000000;
            margin-bottom: 0.25rem;
            text-transform: uppercase;
        }

        .gallery-thumb-meta {
            font-family: var(--font-mono);
            font-size: 0.68rem;
            color: #000000;
            font-weight: 700;
        }

        /* ─── Demographic Identity Matrix Strip (Flat) ─── */
        .student-matrix-strip {
            margin-top: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.55rem;
            flex-wrap: wrap;
            background: #FFFFFF;
            border: var(--nb-border);
            border-radius: 12px;
            padding: 0.65rem 0.85rem;
        }

        .matrix-title {
            font-family: var(--font-mono);
            font-size: 0.72rem;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            background-color: #000000;
            color: #FFFFFF;
            padding: 0.2rem 0.55rem;
            border-radius: 4px;
        }

        .matrix-chip {
            background-color: var(--nb-surface-subtle);
            border: 1.5px solid #000000;
            border-radius: 5px;
            padding: 0.2rem 0.55rem;
            font-family: var(--font-mono);
            font-size: 0.72rem;
            font-weight: 700;
            color: #000000;
        }

        /* ════════════════════════════════════════════════════════════════
           TAB-LIKE TOGGLE & EVENT DISCOVERY SECTION
           ════════════════════════════════════════════════════════════════ */
        .events-view-section {
            margin-top: 3rem;
        }

        .section-header-row {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 1.25rem;
            flex-wrap: wrap;
            margin-bottom: 1.25rem;
        }

        .section-title-block h2 {
            font-size: 1.85rem;
            font-weight: 900;
            color: var(--nb-black);
            letter-spacing: -0.03em;
            text-transform: uppercase;
            line-height: 1.1;
            margin-bottom: 0.25rem;
        }

        .section-title-block p {
            font-family: var(--font-mono);
            font-size: 0.82rem;
            color: #000000;
            font-weight: 700;
        }

        /* ─── Segmented Tab-Like Toggle (Container has 3px 3px 0px #000) ─── */
        .tab-toggle-container {
            display: inline-flex;
            background: #FFFFFF;
            border: var(--nb-border);
            border-radius: 10px;
            padding: 4px;
            box-shadow: 3px 3px 0px #000000;
            gap: 4px;
        }

        .tab-btn {
            background: transparent;
            border: 1.5px solid transparent;
            border-radius: 6px;
            padding: 0.55rem 1.2rem;
            font-family: var(--font-sans);
            font-size: 0.85rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            color: #000000;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-color 0.1s ease;
        }

        .tab-btn:hover {
            background-color: var(--nb-canvas);
        }

        .tab-btn.active {
            background-color: var(--nb-yellow);
            border: 1.5px solid #000000;
        }

        .tab-count-pill {
            background-color: #000000;
            color: #FFFFFF;
            font-family: var(--font-mono);
            font-size: 0.7rem;
            font-weight: 800;
            padding: 0.12rem 0.45rem;
            border-radius: 9999px;
        }

        /* ─── Category Filter Pills Bar (Flat, no shadows) ─── */
        .category-filter-bar {
            display: flex;
            align-items: center;
            gap: 0.55rem;
            flex-wrap: wrap;
            margin-bottom: 1.75rem;
            padding: 0.65rem 0.85rem;
            background: #FFFFFF;
            border: var(--nb-border);
            border-radius: 12px;
        }

        .filter-label {
            font-family: var(--font-mono);
            font-size: 0.74rem;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: #000000;
            margin-right: 0.2rem;
        }

        /* Contrasting Category Pills (Flat, clean borders) */
        .cat-pill {
            font-family: var(--font-mono);
            font-size: 0.75rem;
            font-weight: 800;
            padding: 0.3rem 0.85rem;
            border-radius: 9999px;
            border: 1.5px solid #000000;
            cursor: pointer;
            text-decoration: none;
            color: #000000;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            transition: background-color 0.08s ease;
            user-select: none;
        }

        .cat-pill:hover {
            opacity: 0.9;
        }

        .cat-pill.active {
            background-color: #000000 !important;
            color: #FFFFFF !important;
        }

        .cat-pill-all { background-color: var(--nb-surface-subtle); }
        .cat-pill-lime { background-color: var(--nb-lime); }
        .cat-pill-yellow { background-color: var(--nb-yellow); }
        .cat-pill-neutral { background-color: #FFFFFF; }

        /* ─── Event Cards Grid (Only card shell has 4px 4px 0px #000) ─── */
        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
            gap: 1.5rem;
        }

        @media (max-width: 480px) {
            .events-grid {
                grid-template-columns: 1fr;
            }
        }

        .event-card {
            background-color: var(--nb-card-bg);
            border: var(--nb-border);
            border-radius: 16px;
            box-shadow: 4px 4px 0px #000000;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        /* Card Banner Area */
        .event-promo-banner {
            height: 135px;
            padding: 0.95rem 1.15rem;
            position: relative;
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            border-bottom: var(--nb-border);
        }

        .banner-lime { background-color: var(--nb-lime); }
        .banner-yellow { background-color: var(--nb-yellow); }
        .banner-warm { background-color: var(--nb-canvas); }

        /* Status Badge on Top-Right (Flat, no shadow) */
        .badge-status {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.25rem 0.65rem;
            border-radius: 9999px;
            font-family: var(--font-mono);
            font-size: 0.7rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            border: 1.5px solid #000000;
        }

        .badge-status-open {
            background-color: #FFFFFF;
            color: #000000;
        }

        .badge-status-closed {
            background-color: #000000;
            color: #FFFFFF;
        }

        .badge-pulse-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background-color: #16a34a;
            display: inline-block;
        }

        /* Capacity Pill Bottom-Right (Flat, no shadow) */
        .capacity-pill {
            position: absolute;
            bottom: 0.75rem;
            right: 1.15rem;
            background-color: #FFFFFF;
            border: 1.5px solid #000000;
            border-radius: 9999px;
            padding: 0.25rem 0.65rem;
            font-family: var(--font-mono);
            font-size: 0.72rem;
            font-weight: 800;
            color: #000000;
        }

        /* ─── Card Body ─── */
        .event-card-body {
            padding: 1.35rem 1.25rem;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .card-event-name {
            font-size: 1.2rem;
            font-weight: 900;
            color: var(--nb-black);
            line-height: 1.3;
            margin-bottom: 0.75rem;
            letter-spacing: -0.02em;
            text-transform: uppercase;
        }

        .card-meta-line {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-family: var(--font-mono);
            font-size: 0.76rem;
            font-weight: 700;
            color: #000000;
            margin-bottom: 0.35rem;
            line-height: 1.4;
        }

        .card-meta-line svg {
            width: 15px;
            height: 15px;
            color: #000000;
            flex-shrink: 0;
        }

        /* Sponsors Section */
        .card-sponsors-row {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 0.4rem;
            margin-top: 0.85rem;
            margin-bottom: 1rem;
        }

        .sponsor-label {
            font-family: var(--font-mono);
            font-size: 0.68rem;
            font-weight: 800;
            color: #000000;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            margin-right: 0.15rem;
        }

        /* Sponsor Badges (Flat, no shadow) */
        .sponsor-pill {
            font-family: var(--font-mono);
            font-size: 0.7rem;
            font-weight: 800;
            border-radius: 5px;
            padding: 0.15rem 0.5rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1.5px solid #000000;
            background-color: var(--nb-surface-subtle);
            color: #000000;
            line-height: 1.2;
        }

        .card-divider {
            border: none;
            border-top: 1.5px solid #000000;
            margin-top: auto;
            margin-bottom: 0.95rem;
        }

        .card-action-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.75rem;
        }

        .spots-left-hint {
            font-family: var(--font-mono);
            font-size: 0.74rem;
            font-weight: 800;
            color: #000000;
            background: var(--nb-lime);
            padding: 0.2rem 0.55rem;
            border: 1.5px solid #000000;
            border-radius: 5px;
        }

        .spots-left-hint.closed {
            background: #FFFFFF;
            color: #000000;
        }

        /* Tactile Details Button (Box shadow on action button) */
        .btn-view-details {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            background-color: var(--nb-yellow);
            color: #000000;
            font-family: var(--font-sans);
            font-size: 0.82rem;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            padding: 0.55rem 1.05rem;
            border: var(--nb-border);
            border-radius: 6px;
            box-shadow: 3px 3px 0px #000000;
            text-decoration: none;
            cursor: pointer;
            transition: transform 0.08s ease, box-shadow 0.08s ease, background-color 0.1s ease;
        }

        .btn-view-details:hover {
            background-color: var(--nb-yellow-hover);
        }

        .btn-view-details:active {
            transform: translate(3px, 3px);
            box-shadow: 0px 0px 0px #000000;
        }

        /* ════════════════════════════════════════════════════════════════
           MY REGISTERED EVENTS & SCHEDULE VIEW (TAB 2)
           ════════════════════════════════════════════════════════════════ */
        .registered-section-content {
            display: none;
        }

        .registered-section-content.active-view {
            display: block;
        }

        .events-catalog-content {
            display: block;
        }

        .events-catalog-content.hidden-view {
            display: none;
        }

        /* ─── Pass Table (Container has 4px 4px 0px #000) ─── */
        .registered-table-wrapper {
            background: #FFFFFF;
            border: var(--nb-border);
            border-radius: 14px;
            box-shadow: 4px 4px 0px #000000;
            overflow: hidden;
            margin-top: 0.75rem;
        }

        .registered-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .registered-table th {
            background-color: #000000;
            color: #FFFFFF;
            padding: 1rem 1.15rem;
            font-family: var(--font-mono);
            font-size: 0.76rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-bottom: var(--nb-border);
        }

        .registered-table td {
            padding: 1rem 1.15rem;
            font-size: 0.88rem;
            border-bottom: 1.5px solid #000000;
            color: #000000;
            vertical-align: middle;
        }

        .registered-table tr:last-child td {
            border-bottom: none;
        }

        .registered-table tr:nth-child(even) {
            background-color: var(--nb-surface-subtle);
        }

        /* Attendance status badge (Flat, no shadow) */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.25rem 0.7rem;
            border-radius: 9999px;
            font-family: var(--font-mono);
            font-size: 0.72rem;
            font-weight: 800;
            text-transform: uppercase;
            border: 1.5px solid #000000;
        }

        .status-badge-noshow {
            background-color: #FFFFFF;
            color: #000000;
        }

        .status-badge-present {
            background-color: var(--nb-lime);
            color: #000000;
        }

        .status-badge-cancelled {
            background-color: var(--nb-canvas);
            color: #000000;
        }

        /* Tactile Cancel Button */
        .btn-cancel-reg {
            background-color: #FFFFFF;
            color: #000000;
            border: 1.5px solid #000000;
            padding: 0.4rem 0.85rem;
            border-radius: 6px;
            font-family: var(--font-mono);
            font-size: 0.74rem;
            font-weight: 800;
            cursor: pointer;
            text-transform: uppercase;
            transition: background-color 0.1s ease;
        }

        .btn-cancel-reg:hover:not(:disabled) {
            background-color: var(--nb-yellow);
        }

        .btn-cancel-reg:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            border-color: #000000;
        }

        .empty-passes-box {
            background: #FFFFFF;
            border: var(--nb-border);
            border-radius: 14px;
            box-shadow: 4px 4px 0px #000000;
            padding: 2.75rem 2rem;
            text-align: center;
            margin-top: 0.75rem;
        }

        /* ════════════════════════════════════════════════════════════════
           MODAL: REGISTRATION DIALOG (Box shadow on modal: 6px 6px 0px #000)
           ════════════════════════════════════════════════════════════════ */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.6);
            z-index: 100;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
        }

        .modal-overlay.active {
            display: flex;
        }

        .modal-box {
            background-color: #FFFFFF;
            border: var(--nb-border);
            border-radius: 16px;
            width: 100%;
            max-width: 620px;
            box-shadow: 6px 6px 0px #000000;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .modal-header {
            background-color: var(--nb-yellow);
            color: #000000;
            border-bottom: var(--nb-border);
            padding: 0.85rem 1.35rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-header h4 {
            font-family: var(--font-mono);
            font-size: 0.9rem;
            font-weight: 900;
            letter-spacing: 0.04em;
            text-transform: uppercase;
        }

        .modal-close-btn {
            background: #FFFFFF;
            border: 1.5px solid #000000;
            border-radius: 6px;
            width: 28px;
            height: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.15rem;
            font-weight: 900;
            color: #000000;
            line-height: 1;
            cursor: pointer;
            text-decoration: none;
        }

        .modal-close-btn:hover {
            background: var(--nb-canvas);
        }

        .modal-body {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 1.15rem;
            max-height: 75vh;
            overflow-y: auto;
        }

        .modal-detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.75rem;
        }

        @media (max-width: 500px) {
            .modal-detail-grid {
                grid-template-columns: 1fr;
            }
        }

        .modal-meta-box {
            background-color: var(--nb-surface-subtle);
            border: 1.5px solid #000000;
            border-radius: 8px;
            padding: 0.7rem;
        }

        .modal-meta-box-label {
            font-family: var(--font-mono);
            font-size: 0.66rem;
            font-weight: 800;
            color: #000000;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-bottom: 0.15rem;
        }

        .modal-meta-box-val {
            font-size: 0.85rem;
            font-weight: 800;
            color: #000000;
            line-height: 1.25;
        }

        .modal-notice-banner {
            background-color: var(--nb-canvas);
            border: 1.5px solid #000000;
            padding: 0.75rem 0.9rem;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 700;
            color: #000000;
            line-height: 1.4;
        }

        .modal-footer {
            background-color: var(--nb-surface-subtle);
            border-top: var(--nb-border);
            padding: 1rem 1.35rem;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 0.75rem;
        }

        .btn-modal-cancel {
            background-color: #FFFFFF;
            color: #000000;
            border: 1.5px solid #000000;
            padding: 0.65rem 1.15rem;
            border-radius: 6px;
            font-family: var(--font-sans);
            font-size: 0.85rem;
            font-weight: 800;
            text-transform: uppercase;
            cursor: pointer;
        }

        .btn-register-action {
            background-color: var(--nb-lime);
            color: #000000;
            font-family: var(--font-sans);
            font-size: 0.88rem;
            font-weight: 900;
            text-transform: uppercase;
            border: var(--nb-border);
            box-shadow: 3px 3px 0px #000000;
            padding: 0.65rem 1.35rem;
            border-radius: 6px;
            cursor: pointer;
            transition: transform 0.08s ease, box-shadow 0.08s ease;
        }

        .btn-register-action:hover:not(:disabled) {
            background-color: var(--nb-lime-hover);
        }

        .btn-register-action:active:not(:disabled) {
            transform: translate(3px, 3px);
            box-shadow: 0px 0px 0px #000000;
        }

        .btn-register-action:disabled {
            background-color: #FFFFFF;
            color: #000000;
            opacity: 0.5;
            cursor: not-allowed;
            box-shadow: none;
        }

        /* Responsive Layouts */
        @media (max-width: 768px) {
            .nav-inner {
                height: auto;
                padding: 1rem;
                flex-direction: column;
                align-items: stretch;
                gap: 1rem;
            }
            .nav-center-menu {
                justify-content: center;
                flex-wrap: wrap;
            }
            .nav-user-chip {
                justify-content: space-between;
            }
            .section-header-row {
                flex-direction: column;
                align-items: flex-start;
            }
            .tab-toggle-container {
                width: 100%;
            }
            .tab-btn {
                flex: 1;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <form id="studentDashboardForm" runat="server">
        <!-- Top Navigation -->
        <header class="portal-nav">
            <div class="nav-inner">
                <a href="<%= ResolveUrl("~/Frontend/User/Dashboard.aspx") %>" class="nav-brand">
                    <img src="<%= ResolveUrl("~/Frontend/Assets/QCU Logo.png") %>" alt="QCU Seal" class="nav-logo-img" />
                    <div>
                        <div class="nav-brand-title">QCU EVENTS</div>
                        <span class="nav-brand-badge">STUDENT PORTAL</span>
                    </div>
                </a>

                <div class="nav-center-menu">
                    <a href="javascript:void(0)" onclick="switchTab('catalog')" class="nav-menu-btn active" id="navBtnCatalog">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                        <span>Browse Events</span>
                    </a>
                    <a href="javascript:void(0)" onclick="switchTab('registered')" class="nav-menu-btn" id="navBtnRegistered">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                        </svg>
                        <span>My Passes</span>
                    </a>
                </div>

                <div class="nav-user-chip">
                    <div class="user-avatar-circle">
                        <asp:Literal ID="litAvatarInitials" runat="server" Text="MJ" />
                    </div>
                    <div class="user-details">
                        <span class="user-fullname"><asp:Literal ID="litStudentName" runat="server" Text="Martin Jalop" /></span>
                        <span class="user-meta">[ <asp:Literal ID="litStudentId" runat="server" Text="2024-00101" /> ]</span>
                    </div>
                    <asp:LinkButton ID="btnSignOut" runat="server" CssClass="btn-signout" OnClick="btnSignOut_Click" ToolTip="Sign Out" CausesValidation="false">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                            <polyline points="16 17 21 12 16 7"></polyline>
                            <line x1="21" y1="12" x2="9" y2="12"></line>
                        </svg>
                    </asp:LinkButton>
                </div>
            </div>
        </header>

        <!-- Preview Notification Banner -->
        <asp:Panel ID="pnlPreviewBanner" runat="server" CssClass="preview-banner" Visible="false">
            <div>
                <strong>DEMO PREVIEW:</strong> Viewing active student profile for <em>Martin Jalop (BSIT 3rd Year &bull; San Bartolome)</em>.
            </div>
            <div>
                <a href="<%= ResolveUrl("~/Frontend/Login/Login.aspx") %>">LOGIN WITH ACTIVE ACCOUNT →</a>
            </div>
        </asp:Panel>

        <!-- Main Workspace -->
        <main class="portal-main">
            <!-- Toast Feedback Notification -->
            <asp:Panel ID="pnlToast" runat="server" Visible="false" CssClass="toast-banner">
                <asp:Literal ID="litToastMsg" runat="server" />
            </asp:Panel>

            <!-- ══════════════════════════════════════════════════════════════
                 HERO SECTION: EDITORIAL CAMPUS GALLERY
                 ══════════════════════════════════════════════════════════════ -->
            <section class="hero-gallery-section" id="gallery-hero">
                <div class="gallery-top-badge-row">
                    <div class="ticker-pill-main">
                        <span class="ticker-pill-dot"></span>
                        <span>FEATURED CAMPUS EXHIBITION</span>
                    </div>
                    <div class="gallery-controls-nav">
                        <button type="button" class="gallery-nav-btn" onclick="prevSlide()">← PREV</button>
                        <button type="button" class="gallery-nav-btn" onclick="nextSlide()">NEXT →</button>
                    </div>
                </div>

                <!-- Main Hero Spotlight Stage Card (4px 4px 0px #000 shadow) -->
                <div class="hero-spotlight-card" id="spotlightCard">
                    <!-- Left Banner Artwork -->
                    <div class="spotlight-banner-area" id="spotlightBannerArea">
                        <div class="spotlight-top-tags">
                            <span class="spotlight-category-badge" id="spotlightBadge">#Hackathon</span>
                            <span class="spotlight-live-tag">● FEATURED NOW</span>
                        </div>

                        <div class="spotlight-center-art">
                            <div class="spotlight-subheading" id="spotlightDateTag">OCT 24, 2026 // 09:00 AM - 04:00 PM</div>
                            <h1 class="spotlight-title" id="spotlightTitle">National Cybersecurity Forum</h1>
                        </div>

                        <div class="spotlight-bottom-chips">
                            <span class="spotlight-chip" id="spotlightVenue">📍 University Gymnasium</span>
                            <span class="spotlight-chip">QCU Tech Division</span>
                        </div>
                    </div>

                    <!-- Right Details Content Area -->
                    <div class="spotlight-details-area">
                        <div>
                            <p class="spotlight-desc" id="spotlightDesc">
                                Flagship academic conference and offensive security competition bringing together students, industry tech mentors, and enterprise partners for live defensive cyber drills.
                            </p>

                            <div class="spotlight-meta-grid">
                                <div class="meta-box">
                                    <div class="meta-box-label">Target Audience</div>
                                    <div class="meta-box-val">College of Computer Studies</div>
                                </div>
                                <div class="meta-box">
                                    <div class="meta-box-label">Seat Availability</div>
                                    <div class="meta-box-val" id="spotlightSeats">86 / 100 Seats Booked</div>
                                </div>
                                <div class="meta-box">
                                    <div class="meta-box-label">Registration Window</div>
                                    <div class="meta-box-val">Open until Event Eve</div>
                                </div>
                                <div class="meta-box">
                                    <div class="meta-box-label">Official Sponsors</div>
                                    <div class="meta-box-val" id="spotlightSponsors">Microsoft, LESIT</div>
                                </div>
                            </div>
                        </div>

                        <div class="spotlight-actions-bar">
                            <div class="spotlight-capacity-pill" id="spotlightRemaining">
                                ⚡ 14 SPOTS LEFT
                            </div>

                            <a href="#events-section" class="btn-tactile-action" onclick="focusAndInspectCard(102)">
                                <span>INSPECT & RESERVE →</span>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Gallery Thumbnail Selector Rail (Flat, no card shadows) -->
                <div class="gallery-rail-grid">
                    <div class="gallery-thumb-card active-slide" id="thumb-0" onclick="selectSlide(0)">
                        <span class="gallery-thumb-badge">#Hackathon</span>
                        <div class="gallery-thumb-title">Cybersecurity Forum</div>
                        <div class="gallery-thumb-meta">Oct 24 &bull; Gymnasium</div>
                    </div>

                    <div class="gallery-thumb-card" id="thumb-1" onclick="selectSlide(1)">
                        <span class="gallery-thumb-badge">#Workshop</span>
                        <div class="gallery-thumb-title">AI & Cloud Architecture</div>
                        <div class="gallery-thumb-meta">Oct 09 &bull; Tech Lab 3</div>
                    </div>

                    <div class="gallery-thumb-card" id="thumb-2" onclick="selectSlide(2)">
                        <span class="gallery-thumb-badge">#Seminar</span>
                        <div class="gallery-thumb-title">Tech & Innovation Summit</div>
                        <div class="gallery-thumb-meta">Nov 12 &bull; University Hall</div>
                    </div>

                    <div class="gallery-thumb-card" id="thumb-3" onclick="selectSlide(3)">
                        <span class="gallery-thumb-badge">#SportsFest</span>
                        <div class="gallery-thumb-title">Org Fair & SportsFest</div>
                        <div class="gallery-thumb-meta">Nov 20 &bull; Main Plaza</div>
                    </div>
                </div>

                <!-- Student Demographic Identity Matrix Bar -->
                <div class="student-matrix-strip">
                    <span class="matrix-title">COHORT MATRIX:</span>
                    <span class="matrix-chip">BRANCH: <asp:Literal ID="litCampusBranch" runat="server" Text="San Bartolome" /></span>
                    <span class="matrix-chip">DEPT: <asp:Literal ID="litDepartment" runat="server" Text="College of Computer Studies" /></span>
                    <span class="matrix-chip">PROGRAM: <asp:Literal ID="litProgram" runat="server" Text="BSIT" /></span>
                    <span class="matrix-chip">STANDING: <asp:Literal ID="litYearLevel" runat="server" Text="3rd Year" /></span>
                </div>
            </section>

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

                    <!-- Tab-like Toggle (3px 3px 0px #000 shadow) -->
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
                    <!-- Category Filter Pills Bar (Flat, clean borders) -->
                    <div class="category-filter-bar">
                        <span class="filter-label">Filter Tags:</span>
                        <a href="javascript:void(0)" class="cat-pill cat-pill-all active" onclick="filterByCategory('all', this)">#All Events</a>
                        <a href="javascript:void(0)" class="cat-pill cat-pill-yellow" onclick="filterByCategory('seminar', this)">#Seminar</a>
                        <a href="javascript:void(0)" class="cat-pill cat-pill-lime" onclick="filterByCategory('hackathon', this)">#Hackathon</a>
                        <a href="javascript:void(0)" class="cat-pill cat-pill-yellow" onclick="filterByCategory('workshop', this)">#Workshop</a>
                        <a href="javascript:void(0)" class="cat-pill cat-pill-neutral" onclick="filterByCategory('sportsfest', this)">#SportsFest</a>
                        <a href="javascript:void(0)" class="cat-pill cat-pill-lime" onclick="filterByCategory('orgfair', this)">#OrgFair</a>
                    </div>

                    <!-- Raw Geometric Event Cards Grid (Cards have 4px 4px 0px #000 shadow) -->
                    <div class="events-grid" id="eventsGridContainer">
                        <asp:Repeater ID="rptEventCards" runat="server" OnItemCommand="rptEventCards_ItemCommand">
                            <ItemTemplate>
                                <div class="event-card" data-category='<%# Eval("CategoryFilterKey") %>' id='card-<%# Eval("EventId") %>'>
                                    <!-- Top Half: Promotional Banner Area -->
                                    <div class='event-promo-banner <%# Eval("BannerClass") %>'>
                                        <!-- Category Pill Badge Top-Left -->
                                        <span class='cat-pill <%# Eval("CategoryColorClass") %>'>
                                            <%# Eval("CategoryTag") %>
                                        </span>

                                        <!-- Status Indicator Top-Right -->
                                        <%# Convert.ToBoolean(Eval("IsRegistrationOpen")) 
                                            ? "<span class=\"badge-status badge-status-open\"><span class=\"badge-pulse-dot\"></span> OPEN</span>" 
                                            : "<span class=\"badge-status badge-status-closed\">CLOSED</span>" %>

                                        <!-- Bottom-Right Capacity Indicator -->
                                        <div class="capacity-pill">
                                            <span><%# Eval("CurrentRegistrations") %>/<%# Eval("MaxCapacity") %> SEATS</span>
                                        </div>
                                    </div>

                                    <!-- Bottom Half: Event Details & Sponsors -->
                                    <div class="event-card-body">
                                        <h3 class="card-event-name"><%# Eval("Title") %></h3>
                                        
                                        <div class="card-meta-line">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                                <circle cx="12" cy="10" r="3"></circle>
                                            </svg>
                                            <span><%# Eval("VenueLocation") %></span>
                                        </div>

                                        <div class="card-meta-line">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                            <span><%# Eval("FormattedSchedule") %></span>
                                        </div>

                                        <!-- Sponsors Row -->
                                        <div class="card-sponsors-row">
                                            <span class="sponsor-label">Sponsors:</span>
                                            <%# Eval("SponsorBadgesHtml") %>
                                        </div>

                                        <!-- Divider Line -->
                                        <hr class="card-divider" />

                                        <!-- Bottom Action Row with Tactile Button -->
                                        <div class="card-action-row">
                                            <span class='<%# Convert.ToBoolean(Eval("IsRegistrationOpen")) ? "spots-left-hint" : "spots-left-hint closed" %>'>
                                                <%# Convert.ToBoolean(Eval("IsRegistrationOpen")) ? "⚡ " + Eval("RemainingCapacity") + " SPOTS LEFT" : "REGISTRATION CLOSED" %>
                                            </span>

                                            <asp:LinkButton ID="btnViewDetails" runat="server" 
                                                CssClass="btn-view-details" 
                                                CommandName="ViewDetails" 
                                                CommandArgument='<%# Eval("EventId") %>'
                                                CausesValidation="false">
                                                <span>View Details →</span>
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

                <!-- ────────────────────────────────────────────────────────────
                     TAB 2 VIEW: MY REGISTERED EVENTS & ELECTRONIC PASSES
                     ──────────────────────────────────────────────────────────── -->
                <div class="registered-section-content" id="registeredContentArea">
                    <asp:Panel ID="pnlNoRegistrations" runat="server" Visible="false" CssClass="empty-passes-box">
                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#000000" stroke-width="2" style="margin-bottom: 0.65rem;">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                        <h3 style="font-size: 1.25rem; font-weight: 900; margin-bottom: 0.35rem; text-transform: uppercase;">NO ACTIVE PASSES YET</h3>
                        <p style="font-family: var(--font-mono); font-size: 0.82rem; color: #000000; margin-bottom: 1.25rem;">
                            You have not enrolled in any upcoming campus events yet. Browse open events to reserve your electronic seat.
                        </p>
                        <button type="button" class="btn-tactile-action" onclick="switchTab('catalog')">
                            BROWSE OPEN CAMPUS EVENTS →
                        </button>
                    </asp:Panel>

                    <div class="registered-table-wrapper">
                        <asp:Repeater ID="rptMyRegistrations" runat="server" OnItemCommand="rptMyRegistrations_ItemCommand">
                            <HeaderTemplate>
                                <table class="registered-table">
                                    <thead>
                                        <tr>
                                            <th>EVENT TITLE</th>
                                            <th>VENUE LOCATION</th>
                                            <th>EVENT DATE & TIME</th>
                                            <th>ATTENDANCE STATUS</th>
                                            <th>ACTIONS</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><strong style="text-transform: uppercase;"><%# Eval("EventTitle") %></strong></td>
                                    <td><%# Eval("VenueLocation") %></td>
                                    <td><span style="font-family: var(--font-mono); font-weight: 700;"><%# Eval("EventDateFormatted") %></span></td>
                                    <td>
                                        <%# GetStatusBadgeHtml(Eval("Status")?.ToString()) %>
                                    </td>
                                    <td>
                                        <asp:Button ID="btnCancelReg" runat="server" 
                                            Text="Cancel Pass" 
                                            CssClass="btn-cancel-reg" 
                                            CommandName="CancelRegistration" 
                                            CommandArgument='<%# Eval("EventRegistrationId") %>'
                                            Enabled='<%# Convert.ToBoolean(Eval("CanCancel")) %>'
                                            OnClientClick="return confirm('Cancel this registration? Your seat will be released back to the event capacity.');" />
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                    </tbody>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </section>
        </main>

        <!-- ══════════════════════════════════════════════════════════════
             MODAL: EVENT DETAILS & REGISTRATION CONFIRMATION
             ══════════════════════════════════════════════════════════════ -->
        <asp:Panel ID="pnlModalDetails" runat="server" CssClass="modal-overlay" Visible="false">
            <div class="modal-box">
                <div class="modal-header">
                    <h4>[ EVENT ITINERARY & RESERVATION ]</h4>
                    <asp:LinkButton ID="btnCloseModal" runat="server" CssClass="modal-close-btn" OnClick="btnCloseModal_Click" CausesValidation="false">&times;</asp:LinkButton>
                </div>

                <div class="modal-body">
                    <div>
                        <h3 style="font-size: 1.35rem; font-weight: 900; color: #000000; margin-bottom: 0.45rem; text-transform: uppercase;">
                            <asp:Literal ID="litModalTitle" runat="server" />
                        </h3>
                        <p style="font-size: 0.9rem; color: #000000; line-height: 1.5; font-weight: 500;">
                            <asp:Literal ID="litModalDescription" runat="server" />
                        </p>
                    </div>

                    <div class="modal-detail-grid">
                        <div class="modal-meta-box">
                            <div class="modal-meta-box-label">📍 Venue Location</div>
                            <div class="modal-meta-box-val"><asp:Literal ID="litModalVenue" runat="server" /></div>
                        </div>

                        <div class="modal-meta-box">
                            <div class="modal-meta-box-label">📅 Schedule Time</div>
                            <div class="modal-meta-box-val"><asp:Literal ID="litModalSchedule" runat="server" /></div>
                        </div>

                        <div class="modal-meta-box">
                            <div class="modal-meta-box-label">👤 Seat Availability</div>
                            <div class="modal-meta-box-val"><asp:Literal ID="litModalCapacity" runat="server" /></div>
                        </div>

                        <div class="modal-meta-box">
                            <div class="modal-meta-box-label">⏱ Registration Window</div>
                            <div class="modal-meta-box-val"><asp:Literal ID="litModalRegPeriod" runat="server" /></div>
                        </div>
                    </div>

                    <!-- Sponsors display inside modal -->
                    <div>
                        <div class="modal-meta-box-label" style="margin-bottom: 0.4rem;">Official Event Sponsors:</div>
                        <div class="card-sponsors-row">
                            <asp:Literal ID="litModalSponsors" runat="server" />
                        </div>
                    </div>

                    <div class="modal-notice-banner">
                        <strong>ATTENDANCE NOTICE:</strong> Default status upon reservation is <em>NoShow</em> until verified via electronic attendance check-in on event day. Reservations can be cancelled anytime prior to registration close.
                    </div>
                </div>

                <div class="modal-footer">
                    <asp:HiddenField ID="hfSelectedEventId" runat="server" />
                    <asp:Button ID="btnCancelModal" runat="server" Text="Close Window" CssClass="btn-modal-cancel" OnClick="btnCloseModal_Click" CausesValidation="false" />
                    <asp:Button ID="btnConfirmRegistration" runat="server" Text="Confirm Registration →" CssClass="btn-register-action" OnClick="btnConfirmRegistration_Click" />
                </div>
            </div>
        </asp:Panel>
    </form>

    <!-- Client-Side Script for Disciplined Palette & Interactions -->
    <script type="text/javascript">
        // Gallery exhibition data restricted to yellow (#FFDE59), lime (#A6F4C5), warm canvas (#FAF7EE)
        var gallerySlides = [
            {
                id: 102,
                title: "National Cybersecurity & Hacking Forum",
                category: "#Hackathon",
                bgClass: "#FFDE59",
                date: "OCT 24, 2026 // 09:00 AM - 04:00 PM",
                venue: "📍 Main Campus - University Gymnasium",
                desc: "Flagship cybersecurity conference and defensive hacking competition with enterprise penetration testers and student defense drills.",
                seats: "86 / 100 Seats Booked",
                remaining: "⚡ 14 SPOTS LEFT",
                sponsors: "Microsoft, LESIT"
            },
            {
                id: 101,
                title: "AI & Cloud Architecture Workshop",
                category: "#Workshop",
                bgClass: "#A6F4C5",
                date: "OCT 09, 2026 // 10:00 AM - 03:00 PM",
                venue: "📍 QCU San Bartolome - Tech Lab 3",
                desc: "Deep dive into serverless cloud infrastructure, neural network deployments, and production container scaling with industry guest speakers.",
                seats: "42 / 50 Seats Booked",
                remaining: "⚡ 8 SPOTS LEFT",
                sponsors: "AWS, Google"
            },
            {
                id: 103,
                title: "Annual Tech & Innovation Summit",
                category: "#Seminar",
                bgClass: "#FFDE59",
                date: "NOV 12, 2026 // 08:30 AM - 04:30 PM",
                venue: "📍 QCU Main Campus - University Hall",
                desc: "Flagship university conference gathering faculty, researchers, and student engineering developers to demonstrate emerging hardware and AI inventions.",
                seats: "142 / 200 Seats Booked",
                remaining: "⚡ 58 SPOTS LEFT",
                sponsors: "AWS, Microsoft"
            },
            {
                id: 104,
                title: "Grand Org Fair & SportsFest Kickoff",
                category: "#SportsFest",
                bgClass: "#FAF7EE",
                date: "NOV 20, 2026 // 08:00 AM - 06:00 PM",
                venue: "📍 QCU Main Plaza & Athletic Grounds",
                desc: "Annual student organization recruitment showcase, intramural games opening ceremony, and campus-wide creative exhibition with live performances.",
                seats: "210 / 350 Seats Booked",
                remaining: "⚡ 140 SPOTS LEFT",
                sponsors: "LESIT, Google"
            }
        ];

        var currentSlideIndex = 0;

        function selectSlide(index) {
            currentSlideIndex = index;
            var item = gallerySlides[index];

            document.getElementById('spotlightBannerArea').style.backgroundColor = item.bgClass;
            document.getElementById('spotlightBadge').textContent = item.category;
            document.getElementById('spotlightDateTag').textContent = item.date;
            document.getElementById('spotlightTitle').textContent = item.title;
            document.getElementById('spotlightVenue').textContent = item.venue;
            document.getElementById('spotlightDesc').textContent = item.desc;
            document.getElementById('spotlightSeats').textContent = item.seats;
            document.getElementById('spotlightRemaining').textContent = item.remaining;
            document.getElementById('spotlightSponsors').textContent = item.sponsors;

            for (var i = 0; i < gallerySlides.length; i++) {
                var thumb = document.getElementById('thumb-' + i);
                if (thumb) {
                    if (i === index) {
                        thumb.classList.add('active-slide');
                    } else {
                        thumb.classList.remove('active-slide');
                    }
                }
            }
        }

        function nextSlide() {
            var next = (currentSlideIndex + 1) % gallerySlides.length;
            selectSlide(next);
        }

        function prevSlide() {
            var prev = (currentSlideIndex - 1 + gallerySlides.length) % gallerySlides.length;
            selectSlide(prev);
        }

        function focusAndInspectCard(eventId) {
            switchTab('catalog');
            var card = document.getElementById('card-' + eventId);
            if (card) {
                card.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }

        // Tab Switching between "All Open Events" and "My Registered Events"
        function switchTab(tabKey) {
            var catalogArea = document.getElementById('catalogContentArea');
            var registeredArea = document.getElementById('registeredContentArea');
            var tabCatalogBtn = document.getElementById('tabCatalogBtn');
            var tabRegisteredBtn = document.getElementById('tabRegisteredBtn');
            var navBtnCatalog = document.getElementById('navBtnCatalog');
            var navBtnRegistered = document.getElementById('navBtnRegistered');
            var title = document.getElementById('viewSectionTitle');
            var subtitle = document.getElementById('viewSectionSubtitle');

            if (tabKey === 'registered') {
                catalogArea.classList.add('hidden-view');
                registeredArea.classList.add('active-view');
                tabCatalogBtn.classList.remove('active');
                tabRegisteredBtn.classList.add('active');
                if (navBtnCatalog) navBtnCatalog.classList.remove('active');
                if (navBtnRegistered) navBtnRegistered.classList.add('active');
                if (title) title.textContent = "My Registered Events & Passes";
                if (subtitle) subtitle.textContent = "Inspect your enrolled passes and verified event schedules.";
            } else {
                catalogArea.classList.remove('hidden-view');
                registeredArea.classList.remove('active-view');
                tabCatalogBtn.classList.add('active');
                tabRegisteredBtn.classList.remove('active');
                if (navBtnCatalog) navBtnCatalog.classList.add('active');
                if (navBtnRegistered) navBtnRegistered.classList.remove('active');
                if (title) title.textContent = "Campus Event Matrix";
                if (subtitle) subtitle.textContent = "Explore open registrations or inspect your booked electronic passes.";
            }
        }

        // Category Filter Function
        function filterByCategory(category, pillEl) {
            var pills = document.querySelectorAll('.cat-pill');
            pills.forEach(function(p) { p.classList.remove('active'); });
            if (pillEl) pillEl.classList.add('active');

            var cards = document.querySelectorAll('.events-grid .event-card');
            cards.forEach(function(card) {
                var cardCat = card.getAttribute('data-category');
                if (category === 'all' || cardCat === category) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        // Handle URL Hash on load
        window.addEventListener('DOMContentLoaded', function() {
            if (window.location.hash === '#my-registrations') {
                switchTab('registered');
            }
        });
    </script>
</body>
</html>
