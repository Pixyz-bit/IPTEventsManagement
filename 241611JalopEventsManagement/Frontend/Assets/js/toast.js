/**
 * ════════════════════════════════════════════════════════════════
 * ENTERPRISE FLOATING TOAST NOTIFICATION ENGINE
 * Floating in Lower-Right Viewport with Auto-Dismiss & Smooth State
 * ════════════════════════════════════════════════════════════════
 */
(function (window, document) {
    'use strict';

    var ICONS = {
        success: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>',
        error: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>',
        warning: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>',
        info: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>'
    };

    var DEFAULT_TITLES = {
        success: 'Success',
        error: 'Action Failed',
        warning: 'Notice',
        info: 'Information'
    };

    function getOrCreateContainer() {
        var container = document.getElementById('appToastContainer');
        if (!container) {
            container = document.createElement('div');
            container.id = 'appToastContainer';
            container.className = 'app-toast-container';
            container.setAttribute('aria-live', 'polite');
            container.setAttribute('aria-atomic', 'true');
            document.body.appendChild(container);
        }
        return container;
    }

    var AppToast = {
        show: function (options) {
            if (!options) return null;
            if (typeof options === 'string') {
                options = { message: options };
            }

            var type = (options.type || 'info').toLowerCase();
            if (type === 'danger') type = 'error';
            if (!ICONS[type]) type = 'info';

            var message = options.message || '';
            var title = options.title || DEFAULT_TITLES[type] || 'Notice';
            var duration = typeof options.duration === 'number' ? options.duration : 5000;

            var container = getOrCreateContainer();

            var toast = document.createElement('div');
            toast.className = 'app-toast toast-' + type;
            toast.setAttribute('role', 'alert');

            // Icon Badge
            var iconBadge = document.createElement('div');
            iconBadge.className = 'toast-icon-badge';
            iconBadge.innerHTML = ICONS[type] || ICONS.info;
            toast.appendChild(iconBadge);

            // Content Block
            var contentBlock = document.createElement('div');
            contentBlock.className = 'toast-content';

            if (title) {
                var titleEl = document.createElement('div');
                titleEl.className = 'toast-title';
                titleEl.textContent = title;
                contentBlock.appendChild(titleEl);
            }

            var msgEl = document.createElement('div');
            msgEl.className = 'toast-message';
            // Allow basic safe HTML or plain text
            msgEl.innerHTML = message;
            contentBlock.appendChild(msgEl);
            toast.appendChild(contentBlock);

            // Close Button
            var closeBtn = document.createElement('button');
            closeBtn.type = 'button';
            closeBtn.className = 'toast-close-btn';
            closeBtn.setAttribute('aria-label', 'Close toast');
            closeBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>';
            toast.appendChild(closeBtn);

            // Progress Track & Bar
            var progressTrack = null;
            var progressBar = null;
            if (duration > 0) {
                progressTrack = document.createElement('div');
                progressTrack.className = 'toast-progress-track';
                progressBar = document.createElement('div');
                progressBar.className = 'toast-progress-bar';
                progressBar.style.width = '100%';
                progressTrack.appendChild(progressBar);
                toast.appendChild(progressTrack);
            }

            container.appendChild(toast);

            // Auto-Dismiss Timer Logic with Hover Pause
            var remainingTime = duration;
            var startTime = Date.now();
            var timerId = null;
            var isDismissed = false;

            function dismiss() {
                if (isDismissed) return;
                isDismissed = true;
                if (timerId) clearTimeout(timerId);

                toast.classList.add('toast-dismissing');
                setTimeout(function () {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 320);
            }

            function startTimer() {
                if (duration <= 0) return;
                startTime = Date.now();
                if (progressBar) {
                    progressBar.style.transition = 'width ' + remainingTime + 'ms linear';
                    progressBar.style.width = '0%';
                }
                timerId = setTimeout(dismiss, remainingTime);
            }

            function pauseTimer() {
                if (duration <= 0 || isDismissed) return;
                clearTimeout(timerId);
                var elapsed = Date.now() - startTime;
                remainingTime = Math.max(0, remainingTime - elapsed);
                if (progressBar) {
                    var computedWidth = window.getComputedStyle(progressBar).width;
                    progressBar.style.transition = 'none';
                    progressBar.style.width = computedWidth;
                }
            }

            function resumeTimer() {
                if (duration <= 0 || isDismissed) return;
                startTimer();
            }

            closeBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                dismiss();
            });

            toast.addEventListener('mouseenter', pauseTimer);
            toast.addEventListener('mouseleave', resumeTimer);

            startTimer();

            return {
                dismiss: dismiss,
                element: toast
            };
        },

        success: function (message, title, duration) {
            return this.show({ type: 'success', message: message, title: title || 'Success', duration: duration });
        },

        error: function (message, title, duration) {
            return this.show({ type: 'error', message: message, title: title || 'Action Failed', duration: duration });
        },

        warning: function (message, title, duration) {
            return this.show({ type: 'warning', message: message, title: title || 'Notice', duration: duration });
        },

        info: function (message, title, duration) {
            return this.show({ type: 'info', message: message, title: title || 'Information', duration: duration });
        }
    };

    // Global Alias for cross-page compatibility
    window.AppToast = AppToast;
    window.showToast = function (message, type, title, duration) {
        return AppToast.show({
            message: message,
            type: type || 'info',
            title: title,
            duration: duration
        });
    };

    /**
     * Auto-Harvesting Engine:
     * Scans for server-rendered postback alerts and seamlessly converts
     * them into lower-right floating toasts while hiding the raw markup.
     */
    function harvestServerAlerts() {
        var selectors = [
            '.feedback-alert',
            '.alert-toast',
            '.toast-banner',
            '.error-alert-banner',
            '.alert-banner',
            '[id*="pnlNotification"]',
            '[id*="pnlAlert"]',
            '[id*="pnlFeedback"]',
            '[id*="pnlSuccess"]',
            '[id*="pnlError"]',
            '[id*="pnlToast"]'
        ];

        var elements = document.querySelectorAll(selectors.join(','));
        for (var i = 0; i < elements.length; i++) {
            var el = elements[i];

            // If already processed or inside floating container, ignore
            if (el.dataset.toastProcessed === 'true' || el.closest('#appToastContainer')) {
                continue;
            }

            // Must be visible and have content
            var style = window.getComputedStyle(el);
            if (style.display === 'none' || style.visibility === 'hidden') {
                continue;
            }

            var text = (el.innerText || el.textContent || '').trim();
            // Ignore if empty or only close button "&times;"
            if (!text || text === '×' || text === '&times;') {
                continue;
            }

            // Determine Alert Type
            var cls = (el.className || '').toLowerCase();
            var type = 'info';
            var title = 'System Notice';

            if (cls.indexOf('success') !== -1) {
                type = 'success';
                title = 'Operation Successful';
            } else if (cls.indexOf('danger') !== -1 || cls.indexOf('error') !== -1) {
                type = 'error';
                title = 'Action Required';
            } else if (cls.indexOf('warn') !== -1) {
                type = 'warning';
                title = 'Attention';
            }

            el.dataset.toastProcessed = 'true';
            // Hide the original server panel to prevent in-flow visual stutter (except inside auth card)
            if (!el.closest('.auth-card')) {
                el.style.setProperty('display', 'none', 'important');
            }

            // Clean message: remove trailing/leading close '×' and prefix labels like ! ERROR
            var cleanText = text.replace(/^[×x]\s*/i, '').replace(/\s*[×x]$/i, '').trim();
            cleanText = cleanText.replace(/^!\s*ERROR\s*/i, '').replace(/^ERROR:\s*/i, '').replace(/^SUCCESS:\s*/i, '').replace(/^NOTICE:\s*/i, '').trim();

            // Spawn modern floating toast in lower-right
            AppToast.show({
                type: type,
                title: title,
                message: cleanText,
                duration: 5500
            });
        }
    }

    // Initialize on DOM load and on partial postbacks (ASP.NET AJAX)
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', harvestServerAlerts);
    } else {
        harvestServerAlerts();
    }

    if (typeof window.Sys !== 'undefined' && window.Sys.WebForms && window.Sys.WebForms.PageRequestManager) {
        var prm = window.Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            setTimeout(harvestServerAlerts, 50);
        });
    }

})(window, document);
