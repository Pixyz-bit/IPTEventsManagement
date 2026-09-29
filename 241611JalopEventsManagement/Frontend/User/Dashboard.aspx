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

    <style>
        :root {
            /* Cinematic Modern Dark Palette */
            --bg-canvas: #090D16;
            --bg-surface: #101626;
            --bg-surface-elevated: #161F33;
            --bg-surface-hover: #1E293B;
            --bg-glass: rgba(16, 22, 38, 0.85);
            --bg-glass-subtle: rgba(255, 255, 255, 0.04);
            
            --border-subtle: rgba(255, 255, 255, 0.08);
            --border-medium: rgba(255, 255, 255, 0.14);
            --border-hover: rgba(255, 255, 255, 0.25);
            
            --text-primary: #FFFFFF;
            --text-secondary: #94A3B8;
            --text-muted: #64748B;
            
            --accent-gold: #FFDE59;
            --accent-gold-hover: #FACC15;
            --accent-gold-gradient: linear-gradient(135deg, #FFDE59 0%, #F59E0B 100%);
            
            --accent-emerald: #10B981;
            --accent-emerald-glow: rgba(16, 185, 129, 0.25);
            --emerald-badge-bg: rgba(16, 185, 129, 0.12);
            --emerald-badge-border: rgba(16, 185, 129, 0.3);
            --emerald-badge-text: #34D399;
            
            --accent-blue: #3B82F6;
            
            --font-sans: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            --font-mono: 'JetBrains Mono', monospace;
            
            --shadow-subtle: 0 4px 20px -2px rgba(0, 0, 0, 0.4);
            --shadow-card: 0 10px 30px -5px rgba(0, 0, 0, 0.5), 0 0 1px 1px rgba(255, 255, 255, 0.05);
            --shadow-hover: 0 20px 40px -10px rgba(0, 0, 0, 0.7), 0 0 25px rgba(59, 130, 246, 0.15);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--bg-canvas);
            color: var(--text-primary);
            font-family: var(--font-sans);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            -webkit-font-smoothing: antialiased;
            background-image: 
                radial-gradient(circle at 50% 0%, rgba(37, 99, 235, 0.08) 0%, transparent 60%),
                radial-gradient(circle at 100% 20%, rgba(245, 158, 11, 0.04) 0%, transparent 40%);
            background-attachment: fixed;
        }

        /* ─── Preview Notification Banner (when in demo mode) ─── */
        .preview-banner {
            background: rgba(245, 158, 11, 0.12);
            border-bottom: 1px solid rgba(245, 158, 11, 0.25);
            color: #FDE68A;
            padding: 0.65rem 1.75rem;
            font-size: 0.84rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            position: relative;
            z-index: 60;
            backdrop-filter: blur(8px);
        }

        .preview-banner a {
            color: #000000;
            font-family: var(--font-sans);
            font-weight: 800;
            font-size: 0.76rem;
            background: var(--accent-gold);
            padding: 0.35rem 0.85rem;
            border-radius: 9999px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            box-shadow: 0 2px 8px rgba(245, 158, 11, 0.25);
            transition: all 0.15s ease;
        }

        .preview-banner a:hover {
            background: var(--accent-gold-hover);
            transform: translateY(-1px);
        }

        /* ─── Main Portal Wrapper ─── */
        .portal-main {
            max-width: 1400px;
            margin: 0 auto;
            padding: 1.75rem 2rem 5rem 2rem;
            width: 100%;
            flex: 1;
        }

        /* ─── Toast Feedback Notification ─── */
        .toast-banner {
            padding: 0.9rem 1.4rem;
            border-radius: 12px;
            margin-bottom: 1.75rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 0.9rem;
            font-weight: 700;
            backdrop-filter: blur(12px);
        }

        .toast-success {
            background: rgba(16, 185, 129, 0.15);
            border: 1px solid rgba(16, 185, 129, 0.35);
            color: #6EE7B7;
        }

        .toast-error {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.35);
            color: #FCA5A5;
        }

        /* ════════════════════════════════════════════════════════════════
           TOP NAVIGATION BAR (MATCHING USER SPECIFICATION)
           ════════════════════════════════════════════════════════════════ */
        .portal-navbar {
            width: 100%;
            background: rgba(9, 13, 22, 0.92);
            backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--border-subtle);
            position: sticky;
            top: 0;
            z-index: 50;
            box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.5);
        }

        .navbar-inner {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0.85rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.5rem;
        }

        .nav-brand {
            display: flex;
            align-items: center;
            gap: 0.9rem;
            text-decoration: none;
            color: #FFFFFF;
        }

        .nav-logo-img {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            object-fit: cover;
            background: #FFFFFF;
            padding: 2px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.4);
        }

        .nav-brand-title {
            font-size: 1.22rem;
            font-weight: 800;
            letter-spacing: -0.02em;
            line-height: 1.15;
            color: #FFFFFF;
        }

        .nav-brand-subtitle {
            font-size: 0.78rem;
            color: rgba(255, 255, 255, 0.75);
            font-weight: 600;
            letter-spacing: 0.01em;
        }

        .nav-user-bar {
            display: flex;
            align-items: center;
            gap: 0.85rem;
        }

        .nav-user-badge {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            background: rgba(16, 22, 38, 0.75);
            border: 1px solid rgba(255, 255, 255, 0.12);
            padding: 0.35rem 0.95rem;
            border-radius: 9999px;
            color: #FFFFFF;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }

        .nav-user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, #FFFFFF 0%, #E2E8F0 100%);
            color: #0F172A;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 0.8rem;
        }

        .nav-user-info {
            display: flex;
            flex-direction: column;
            line-height: 1.2;
        }

        .nav-user-name {
            font-size: 0.82rem;
            font-weight: 700;
            color: #FFFFFF;
        }

        .nav-user-id {
            font-size: 0.68rem;
            font-family: var(--font-mono);
            color: var(--accent-gold);
            font-weight: 600;
        }

        .nav-btn-signout {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: rgba(16, 22, 38, 0.75);
            border: 1px solid rgba(255, 255, 255, 0.12);
            color: #94A3B8;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
        }

        .nav-btn-signout:hover {
            background: rgba(239, 68, 68, 0.2);
            border-color: rgba(239, 68, 68, 0.4);
            color: #F87171;
            transform: scale(1.05);
        }

        /* ════════════════════════════════════════════════════════════════
           HERO SECTION: CONSISTENT DIMENSIONS & RESPONSIVE BEHAVIOR
           ════════════════════════════════════════════════════════════════ */
        .hero-showcase-container {
            width: 100%;
            height: 480px; /* Fixed consistent desktop height */
            border: 1px solid var(--border-medium);
            border-radius: 24px;
            position: relative;
            overflow: hidden;
            background-color: #060911;
            margin-bottom: 2rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 20px 40px -15px rgba(0, 0, 0, 0.6), 0 0 1px 1px rgba(255, 255, 255, 0.05);
            box-sizing: border-box;
        }

        /* Background Photo Layer has exact 100% width and 100% height of the container */
        .hero-bg-layer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            transition: background-image 0.5s cubic-bezier(0.16, 1, 0.3, 1);
            z-index: 1;
        }

        .hero-overlay-layer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                linear-gradient(180deg, rgba(6, 9, 17, 0.6) 0%, rgba(6, 9, 17, 0.45) 45%, rgba(6, 9, 17, 0.95) 100%),
                linear-gradient(90deg, rgba(6, 9, 17, 0.85) 0%, rgba(6, 9, 17, 0.45) 55%, rgba(6, 9, 17, 0.25) 100%);
            z-index: 2;
        }

        /* Hero Content Area */
        .hero-body-content {
            position: relative;
            z-index: 10;
            padding: 3rem 2.5rem 1rem 2.5rem;
            max-width: 820px;
        }

        .hero-title {
            font-size: 3.1rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            line-height: 1.12;
            color: #FFFFFF;
            margin-bottom: 1rem;
            text-shadow: 0 4px 16px rgba(0, 0, 0, 0.5);
            max-width: 780px;
        }

        .hero-description {
            font-size: 1.08rem;
            line-height: 1.6;
            color: #CBD5E1;
            font-weight: 400;
            margin-bottom: 1.75rem;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.5);
            max-width: 680px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .hero-meta-list {
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            align-items: center;
        }

        .hero-meta-item {
            display: flex;
            align-items: center;
            gap: 0.65rem;
            font-size: 0.92rem;
            font-weight: 600;
            color: #E2E8F0;
            background: rgba(16, 22, 38, 0.5);
            backdrop-filter: blur(8px);
            padding: 0.45rem 0.9rem;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .hero-meta-item svg {
            width: 18px;
            height: 18px;
            color: var(--accent-gold);
            flex-shrink: 0;
        }

        /* Bottom Horizontal Thumbnail Carousel Rail */
        .hero-gallery-rail {
            position: relative;
            z-index: 10;
            padding: 1rem 2.25rem 1.75rem 2.25rem;
            display: flex;
            gap: 1rem;
            overflow-x: auto;
            scrollbar-width: none;
            -ms-overflow-style: none;
        }

        .hero-gallery-rail::-webkit-scrollbar {
            display: none;
        }

        .hero-thumb-card {
            flex: 0 0 190px;
            height: 105px;
            border-radius: 14px;
            border: 2px solid transparent;
            background-size: cover;
            background-position: center;
            position: relative;
            cursor: pointer;
            overflow: hidden;
            transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.4);
        }

        .hero-thumb-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 24px rgba(0, 0, 0, 0.6);
        }

        .hero-thumb-card.active-thumb {
            border-color: var(--accent-gold);
            box-shadow: 0 0 20px rgba(255, 222, 89, 0.4), 0 8px 24px rgba(0, 0, 0, 0.7);
            transform: translateY(-2px);
        }

        .thumb-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(180deg, rgba(6, 9, 17, 0.2) 0%, rgba(6, 9, 17, 0.88) 100%);
            padding: 0.75rem;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
        }

        .thumb-title {
            font-size: 0.78rem;
            font-weight: 800;
            color: #FFFFFF;
            line-height: 1.25;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .thumb-meta {
            font-size: 0.68rem;
            font-family: var(--font-mono);
            color: var(--accent-gold);
            margin-top: 0.2rem;
            font-weight: 600;
        }

        /* ─── Cohort Demographic Strip ─── */
        .student-matrix-strip {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            flex-wrap: wrap;
            padding: 0.75rem 1.4rem;
            background: rgba(255, 255, 255, 0.025);
            border: 1px solid var(--border-subtle);
            border-radius: 14px;
            margin-bottom: 2.25rem;
            font-size: 0.82rem;
        }

        .matrix-title {
            font-family: var(--font-mono);
            font-weight: 800;
            font-size: 0.74rem;
            letter-spacing: 0.05em;
            color: var(--accent-gold);
        }

        .matrix-chip {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
            padding: 0.25rem 0.75rem;
            border-radius: 8px;
            color: #CBD5E1;
            font-weight: 600;
            font-size: 0.78rem;
        }

        /* ════════════════════════════════════════════════════════════════
           TAB-LIKE TOGGLE & SECTION HEADER
           ════════════════════════════════════════════════════════════════ */
        .events-view-section {
            display: flex;
            flex-direction: column;
        }

        .section-header-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1.25rem;
            margin-bottom: 1.75rem;
        }

        .section-title-block h2 {
            font-size: 1.75rem;
            font-weight: 800;
            letter-spacing: -0.025em;
            color: #FFFFFF;
            line-height: 1.2;
        }

        .section-title-block p {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-top: 0.25rem;
        }

        /* Sleek Modern Segmented Tab Toggle */
        .tab-toggle-container {
            display: inline-flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-medium);
            border-radius: 9999px;
            padding: 4px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.3);
        }

        .tab-btn {
            background: transparent;
            border: none;
            color: var(--text-secondary);
            font-family: var(--font-sans);
            font-weight: 700;
            font-size: 0.85rem;
            padding: 0.55rem 1.25rem;
            border-radius: 9999px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 0.55rem;
            transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .tab-btn:hover:not(.active) {
            color: #FFFFFF;
            background: rgba(255, 255, 255, 0.04);
        }

        .tab-btn.active {
            background: #FFFFFF;
            color: #090D16;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.4);
        }

        .tab-count-pill {
            background: rgba(0, 0, 0, 0.12);
            color: inherit;
            font-family: var(--font-mono);
            font-size: 0.72rem;
            font-weight: 800;
            padding: 0.15rem 0.55rem;
            border-radius: 9999px;
        }

        .tab-btn:not(.active) .tab-count-pill {
            background: rgba(255, 255, 255, 0.08);
            color: var(--text-secondary);
        }

        /* Category Filter Tags */
        .category-filter-bar {
            display: flex;
            align-items: center;
            gap: 0.65rem;
            flex-wrap: wrap;
            margin-bottom: 2rem;
        }

        .filter-label {
            font-family: var(--font-mono);
            font-size: 0.76rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
            margin-right: 0.25rem;
        }

        .cat-pill {
            font-family: var(--font-sans);
            font-size: 0.8rem;
            font-weight: 700;
            padding: 0.4rem 1rem;
            border-radius: 9999px;
            border: 1px solid var(--border-subtle);
            background: rgba(255, 255, 255, 0.03);
            color: var(--text-secondary);
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            transition: all 0.2s ease;
            user-select: none;
        }

        .cat-pill:hover {
            color: #FFFFFF;
            border-color: var(--border-hover);
            background: rgba(255, 255, 255, 0.06);
            transform: translateY(-1px);
        }

        .cat-pill.active {
            background: #FFFFFF !important;
            color: #090D16 !important;
            border-color: #FFFFFF !important;
            box-shadow: 0 4px 12px rgba(255, 255, 255, 0.15);
        }

        /* ════════════════════════════════════════════════════════════════
           EVENT CARDS GRID: EXACT ELEMENT ORGANIZATION (PHOTO 2)
           STYLING: PROFESSIONAL CINEMATIC (MATCHING HERO SECTION)
           ════════════════════════════════════════════════════════════════ */
        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 2rem;
        }

        @media (max-width: 500px) {
            .events-grid {
                grid-template-columns: 1fr;
            }
        }

        .event-card {
            background-color: var(--bg-surface);
            border: 1px solid var(--border-subtle);
            border-radius: 20px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-card);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
        }

        .event-card:hover {
            transform: translateY(-5px);
            border-color: var(--border-hover);
            box-shadow: var(--shadow-hover);
        }

        /* Top Half: Promotional Banner Area (Photo 2) */
        .event-promo-banner {
            height: 160px;
            padding: 1.15rem 1.25rem;
            position: relative;
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
        }

        .event-promo-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(180deg, rgba(9, 13, 22, 0.35) 0%, rgba(9, 13, 22, 0.85) 100%);
            z-index: 1;
        }

        /* Category Tag Pill (Top-Left in Photo 2) */
        .card-tag-pill {
            position: relative;
            z-index: 2;
            display: inline-flex;
            align-items: center;
            padding: 0.32rem 0.9rem;
            border-radius: 9999px;
            border: 1px solid rgba(255, 255, 255, 0.22);
            background: rgba(9, 13, 22, 0.65);
            backdrop-filter: blur(8px);
            font-family: var(--font-sans);
            font-weight: 800;
            font-size: 0.76rem;
            color: #FFFFFF;
            letter-spacing: 0.02em;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
        }

        /* Status Badge (Top-Right in Photo 2) */
        .card-status-pill {
            position: relative;
            z-index: 2;
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            padding: 0.32rem 0.85rem;
            border-radius: 9999px;
            border: 1px solid var(--emerald-badge-border);
            background: rgba(16, 185, 129, 0.16);
            backdrop-filter: blur(8px);
            font-family: var(--font-sans);
            font-weight: 800;
            font-size: 0.74rem;
            color: var(--emerald-badge-text);
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .card-status-closed {
            border-color: rgba(239, 68, 68, 0.3);
            background: rgba(239, 68, 68, 0.16);
            color: #F87171;
        }

        .card-status-soon {
            border-color: rgba(234, 179, 8, 0.45);
            background: rgba(234, 179, 8, 0.18);
            color: #FDE047;
        }

        .status-dot-green {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background-color: var(--accent-emerald);
            display: inline-block;
            box-shadow: 0 0 8px var(--accent-emerald);
        }

        .status-dot-amber {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background-color: #FACC15;
            display: inline-block;
            box-shadow: 0 0 8px #FACC15;
        }

        /* Capacity Indicator (Bottom-Right of Banner in Photo 2) */
        .card-capacity-pill {
            position: absolute;
            z-index: 2;
            bottom: 0.9rem;
            right: 1.15rem;
            background: rgba(9, 13, 22, 0.75);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 9999px;
            padding: 0.3rem 0.8rem;
            font-family: var(--font-mono);
            font-size: 0.74rem;
            font-weight: 700;
            color: #F1F5F9;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.4);
        }

        /* Bottom Half: Event Details (Photo 2) */
        .event-card-body {
            padding: 1.45rem 1.4rem 1.35rem 1.4rem;
            display: flex;
            flex-direction: column;
            flex: 1;
            background-color: var(--bg-surface);
        }

        /* Title: Prominent, Crisp, High-Contrast */
        .card-event-name {
            font-size: 1.25rem;
            font-weight: 800;
            color: #FFFFFF;
            line-height: 1.28;
            margin-bottom: 0.95rem;
            letter-spacing: -0.015em;
            text-transform: uppercase;
        }

        /* Location Line with Pin Icon (Photo 2) */
        .card-meta-line {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            font-size: 0.84rem;
            font-weight: 500;
            color: var(--text-secondary);
            margin-bottom: 0.45rem;
            line-height: 1.4;
        }

        .card-meta-line svg {
            width: 16px;
            height: 16px;
            color: var(--accent-gold);
            flex-shrink: 0;
        }

        /* Sponsors Row (Photo 2) */
        .card-sponsors-row {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 0.45rem;
            margin-top: 0.85rem;
            margin-bottom: 1.25rem;
        }

        .sponsor-label {
            font-family: var(--font-mono);
            font-size: 0.72rem;
            font-weight: 800;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-right: 0.2rem;
        }

        .sponsor-pill {
            font-family: var(--font-sans);
            font-size: 0.74rem;
            font-weight: 700;
            border-radius: 6px;
            padding: 0.2rem 0.6rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid var(--border-subtle);
            background: rgba(255, 255, 255, 0.04);
            color: #E2E8F0;
            line-height: 1.2;
            transition: all 0.15s ease;
        }

        .sponsor-pill:hover {
            border-color: var(--border-hover);
            background: rgba(255, 255, 255, 0.08);
        }

        /* Crisp Divider Line (Photo 2) */
        .card-divider {
            border: none;
            border-top: 1px solid var(--border-subtle);
            margin-top: auto;
            margin-bottom: 1.15rem;
        }

        /* Bottom Action Row (Photo 2) */
        .card-action-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.85rem;
        }

        /* Spots Left Pill: Mint/Emerald glow (Photo 2) */
        .spots-left-hint {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            font-family: var(--font-mono);
            font-size: 0.76rem;
            font-weight: 800;
            color: var(--emerald-badge-text);
            background: var(--emerald-badge-bg);
            padding: 0.45rem 0.85rem;
            border: 1px solid var(--emerald-badge-border);
            border-radius: 8px;
            text-transform: uppercase;
            letter-spacing: 0.02em;
        }

        .spots-left-hint.closed {
            background: rgba(239, 68, 68, 0.1);
            border-color: rgba(239, 68, 68, 0.25);
            color: #F87171;
        }

        .spots-left-hint.soon {
            background: rgba(234, 179, 8, 0.12);
            border-color: rgba(234, 179, 8, 0.35);
            color: #FDE047;
        }

        .spots-left-hint svg {
            width: 14px;
            height: 14px;
            fill: currentColor;
            flex-shrink: 0;
        }

        /* Tactile Details Button: Gold Gradient with Hover Elevation (Photo 2) */
        .btn-view-details {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--accent-gold-gradient);
            color: #090D16;
            font-family: var(--font-sans);
            font-size: 0.82rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            padding: 0.65rem 1.25rem;
            border: none;
            border-radius: 8px;
            box-shadow: 0 4px 14px rgba(245, 158, 11, 0.25);
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .btn-view-details:hover {
            box-shadow: 0 6px 20px rgba(245, 158, 11, 0.45);
            transform: translateY(-2px);
        }

        .btn-view-details:active {
            transform: translateY(1px);
            box-shadow: 0 2px 6px rgba(245, 158, 11, 0.2);
        }

        /* ════════════════════════════════════════════════════════════════
           TAB 2 VIEW: MY REGISTERED EVENTS & PASSES
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

        .registered-table-wrapper {
            background: var(--bg-surface);
            border: 1px solid var(--border-subtle);
            border-radius: 18px;
            box-shadow: var(--shadow-card);
            overflow: hidden;
            margin-top: 1rem;
        }

        .registered-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .registered-table th {
            background: rgba(255, 255, 255, 0.025);
            color: var(--text-muted);
            padding: 1.1rem 1.35rem;
            font-family: var(--font-mono);
            font-size: 0.74rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            border-bottom: 1px solid var(--border-subtle);
        }

        .registered-table td {
            padding: 1.25rem 1.35rem;
            border-bottom: 1px solid var(--border-subtle);
            font-size: 0.88rem;
            color: var(--text-secondary);
        }

        .registered-table tr:last-child td {
            border-bottom: none;
        }

        .registered-table tr:hover td {
            background: rgba(255, 255, 255, 0.02);
        }

        .pass-event-title {
            font-weight: 800;
            color: #FFFFFF;
            font-size: 0.95rem;
        }

        .status-badge-reg {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            padding: 0.3rem 0.85rem;
            border-radius: 9999px;
            font-family: var(--font-mono);
            font-size: 0.72rem;
            font-weight: 800;
            text-transform: uppercase;
        }

        .status-badge-noshow {
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid var(--border-subtle);
            color: #CBD5E1;
        }

        .status-badge-present {
            background: var(--emerald-badge-bg);
            border: 1px solid var(--emerald-badge-border);
            color: var(--emerald-badge-text);
        }

        .status-badge-cancelled {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.25);
            color: #F87171;
        }

        .btn-cancel-reg {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.25);
            color: #FCA5A5;
            padding: 0.45rem 0.95rem;
            border-radius: 8px;
            font-family: var(--font-sans);
            font-size: 0.76rem;
            font-weight: 700;
            cursor: pointer;
            text-transform: uppercase;
            transition: all 0.15s ease;
        }

        .btn-cancel-reg:hover:not(:disabled) {
            background: rgba(239, 68, 68, 0.2);
            color: #FFFFFF;
            border-color: rgba(239, 68, 68, 0.4);
            transform: translateY(-1px);
        }

        .btn-cancel-reg:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

        .empty-passes-box {
            background: var(--bg-surface);
            border: 1px solid var(--border-subtle);
            border-radius: 18px;
            box-shadow: var(--shadow-card);
            padding: 3.5rem 2rem;
            text-align: center;
            margin-top: 1rem;
        }

        /* ════════════════════════════════════════════════════════════════
           MODAL: REGISTRATION & INSPECTION DIALOG
           ════════════════════════════════════════════════════════════════ */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(4, 7, 14, 0.75);
            backdrop-filter: blur(12px);
            z-index: 100;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
        }

        .modal-overlay.active {
            display: flex;
        }

        .modal-box {
            background-color: var(--bg-surface);
            border: 1px solid var(--border-medium);
            border-radius: 20px;
            width: 100%;
            max-width: 620px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.85), 0 0 1px 1px rgba(255, 255, 255, 0.1);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .modal-header {
            background: rgba(255, 255, 255, 0.03);
            border-bottom: 1px solid var(--border-subtle);
            padding: 1.25rem 1.75rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-header h4 {
            font-family: var(--font-sans);
            font-size: 1.05rem;
            font-weight: 800;
            letter-spacing: -0.01em;
            color: #FFFFFF;
        }

        .modal-close-btn {
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--text-secondary);
            cursor: pointer;
            text-decoration: none;
            transition: all 0.15s ease;
        }

        .modal-close-btn:hover {
            color: #FFFFFF;
            background: rgba(255, 255, 255, 0.12);
        }

        .modal-body {
            padding: 1.75rem;
            display: flex;
            flex-direction: column;
            gap: 1.25rem;
            max-height: 75vh;
            overflow-y: auto;
        }

        .modal-detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.85rem;
        }

        @media (max-width: 500px) {
            .modal-detail-grid {
                grid-template-columns: 1fr;
            }
        }

        .modal-meta-box {
            background-color: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border-subtle);
            border-radius: 10px;
            padding: 0.85rem;
        }

        .modal-meta-box-label {
            font-family: var(--font-mono);
            font-size: 0.68rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.25rem;
        }

        .modal-meta-box-val {
            font-size: 0.88rem;
            font-weight: 700;
            color: #FFFFFF;
            line-height: 1.3;
        }

        .modal-notice-banner {
            background-color: rgba(245, 158, 11, 0.1);
            border: 1px solid rgba(245, 158, 11, 0.25);
            padding: 0.85rem 1rem;
            border-radius: 10px;
            font-size: 0.82rem;
            font-weight: 600;
            color: #FDE68A;
            line-height: 1.45;
        }

        .modal-footer {
            background: rgba(255, 255, 255, 0.02);
            border-top: 1px solid var(--border-subtle);
            padding: 1.15rem 1.75rem;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 0.85rem;
        }

        .btn-modal-cancel {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-secondary);
            border: 1px solid var(--border-subtle);
            padding: 0.65rem 1.25rem;
            border-radius: 8px;
            font-family: var(--font-sans);
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .btn-modal-cancel:hover {
            color: #FFFFFF;
            background: rgba(255, 255, 255, 0.1);
        }

        .btn-register-action {
            background: var(--accent-gold-gradient);
            color: #090D16;
            font-family: var(--font-sans);
            font-size: 0.88rem;
            font-weight: 800;
            text-transform: uppercase;
            border: none;
            box-shadow: 0 4px 14px rgba(245, 158, 11, 0.3);
            padding: 0.65rem 1.5rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .btn-register-action:hover:not(:disabled) {
            box-shadow: 0 6px 20px rgba(245, 158, 11, 0.5);
            transform: translateY(-1px);
        }

        .btn-register-action:disabled {
            background: rgba(255, 255, 255, 0.1);
            color: var(--text-muted);
            box-shadow: none;
            cursor: not-allowed;
        }

        /* ─── Responsive Adjustments for Navbar and Consistent Hero ─── */
        @media (max-width: 1024px) {
            .hero-showcase-container {
                height: 460px; /* Tablet consistent height */
            }
            .hero-body-content {
                padding: 2.25rem 2rem 1rem 2rem;
            }
            .hero-title {
                font-size: 2.45rem;
            }
            .hero-gallery-rail {
                padding: 0.75rem 2rem 1.5rem 2rem;
            }
        }

        @media (max-width: 768px) {
            .navbar-inner {
                padding: 0.75rem 1.25rem;
            }
            .nav-brand-title {
                font-size: 1.05rem;
            }
            .nav-brand-subtitle {
                font-size: 0.7rem;
            }
            .nav-user-name, .nav-user-id {
                display: none;
            }
            .portal-main {
                padding: 1.25rem 1.25rem 4rem 1.25rem;
            }
            .hero-showcase-container {
                height: 520px; /* Mobile consistent height accommodating stacked content */
                border-radius: 18px;
            }
            .hero-body-content {
                padding: 1.75rem 1.25rem 1rem 1.25rem;
            }
            .hero-title {
                font-size: 1.85rem;
            }
            .hero-description {
                font-size: 0.92rem;
                margin-bottom: 1.25rem;
            }
            .hero-meta-list {
                gap: 0.65rem;
            }
            .hero-meta-item {
                font-size: 0.8rem;
                padding: 0.35rem 0.65rem;
            }
            .hero-gallery-rail {
                padding: 0.75rem 1.25rem 1.25rem 1.25rem;
                gap: 0.75rem;
            }
            .hero-thumb-card {
                flex: 0 0 150px;
                height: 85px;
            }
        }
    </style>
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
