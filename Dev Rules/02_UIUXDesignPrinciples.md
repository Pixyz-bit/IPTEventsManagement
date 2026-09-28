# UI/UX & Design System Principles

- **Category:** Visual Aesthetics, Layout Systems & Frontend Design Standards
- **Applies to:** ASP.NET Master Pages, Web Forms Views (`.aspx`), CSS Stylesheets, and Component Themes.

---

## 1. Design System Tokens & Color Palette

All pages and user interfaces must inherit from the established university design system. Never introduce arbitrary one-off hex colors.

```css
:root {
    /* Surfaces & Layout Canvases */
    --bg-canvas: #090d16;          /* Deep slate base canvas */
    --bg-sidebar: #0d1322;         /* Dark navy sidebar */
    --bg-card: #131b2e;            /* Elevated card surface */
    --bg-input: #1a233a;           /* Input field background */
    
    /* Borders & Dividers */
    --border-subtle: #1e293b;      /* Default panel & table border */
    --border-focus: #3b82f6;       /* Active input / focus border */
    
    /* Typography Colors */
    --text-heading: #f8fafc;       /* Titles, high-emphasis text */
    --text-body: #cbd5e1;          /* Paragraphs, descriptions */
    --text-muted: #64748b;         /* Subtitles, hints, timestamps */
    
    /* Semantic & Accent Colors */
    --brand-primary: #2563eb;      /* Institutional Sapphire Blue */
    --brand-primary-hover: #1d4ed8;
    --accent-emerald: #10b981;     /* Verified attendance, active states */
    --accent-amber: #f59e0b;       /* Warning, registration closing soon */
    --accent-rose: #f43f5e;        /* Danger, cancellation, error alerts */
    
    /* Typography Stacks */
    --font-sans: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    --font-mono: 'JetBrains Mono', monospace;
    
    /* Layout Dimensions */
    --sidebar-width: 260px;
    --topbar-height: 64px;
}
```

---

## 2. Anti-AI-Slop & Professionalism Directives

To ensure the interface reflects human craftsmanship shipped for a university product:

1. **NO Default Tailwind Indigo:** Never use `#6366f1`, `#4f46e5`, `#4338ca`, `#8b5cf6`, or `#7c3aed`. Use `--brand-primary: #2563eb` or `--accent-emerald`.
2. **NO Two-Stop Trust Gradients:** Avoid purple→blue or blue→cyan gradients on headers or hero sections. Use flat, dark surfaces with crisp 1px borders and intentional typography.
3. **NO Emojis as UI Icons:** Never use `✨`, `🚀`, `🎯`, `⚡`, `🔥`, `💡` inside headings, buttons, badges, or list items. Always use crisp, 1.6–1.8px stroke monoline SVGs with `currentColor`.
4. **NO Left-Border Accent Cards:** Do not build rounded cards with colored left borders (the generic AI tile). Use clean, uniform 1px borders (`var(--border-subtle)`).
5. **NO Filler or Generic Copy:** Never output `lorem ipsum`, `feature one`, or fabricated metrics (`"10x faster"`). Use concrete university terms: *College of Computer Studies*, *Main Campus Auditorium*, *Matriculation ID: 2024-00101*, *Max Capacity: 350 seats*.

---

## 3. Typography & Data Presentation Rules

1. **Font Hierarchy:**
   * Display Headings (`h1`, `h2`): `Plus Jakarta Sans`, 600 or 700 font-weight, tight tracking (`letter-spacing: -0.02em`).
   * Body Text: `Plus Jakarta Sans`, 400 or 500 font-weight, 1.5 line-height.
   * Monospace Tokens: Use `JetBrains Mono` for Student IDs, capacity ratios (`142 / 200`), dates, and timestamps.
2. **Status Badges & Pills:**
   * **Open:** Fresh emerald background (`#ecfdf5`), border (`#a7f3d0`), and green text (`#047857`).
   * **Soon:** Warm amber/gold background (`#fefce8`), border (`#fef08a`), and amber text (`#a16207`).
   * **Close:** Slate neutral background (`#f1f5f9`), border (`#cbd5e1`), and dark muted text (`#475569`).

---

## 4. Master Layout Architecture

1. **Unified Shell (`Admin.Master` / `User.Master`):**
   * **Sidebar:** Fixed position (`position: fixed; width: 260px; top: 0; bottom: 0;`).
   * **Header Topbar:** Sticky position (`position: sticky; top: 0; z-index: 30; backdrop-filter: blur(12px);`).
   * **Workspace Content:** Contained within `<main class="admin-workspace">` (`max-width: 1440px; margin: 0 auto;`).
2. **Responsive Breakpoints:**
   * **Desktop (> 1024px):** Full sidebar with brand text, section titles, and user profile information.
   * **Tablet / Compact (≤ 1024px):** Sidebar collapses to 72px icon-only rail; labels and profile text hidden.
   * **Mobile (≤ 640px):** Multi-column KPI cards stack into single columns.

---

## 5. Preview Mode & Zero Blank-Screen Standard

1. **Graceful Fallbacks:** Every dashboard and portal page must support visual previewing without an active database connection or authenticated session.
2. **Demonstration Data:** If the database contains 0 rows on fresh migration, bind realistic mock university records instead of rendering empty blank space.
3. **Preview Banner:** Display a top preview banner with a login shortcut when accessed without an authenticated session, avoiding abrupt redirects during UI reviews.
