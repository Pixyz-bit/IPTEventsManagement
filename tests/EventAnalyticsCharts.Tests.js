// Database-free interaction coverage for the actual analytics page script.
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const assert = require('assert');
class Element {
    constructor() {
        this.children = []; this.style = { setProperty(key, value) { this[key] = value; } }; this.attributes = {}; this.events = {}; this.value = '';
        this.offsetWidth = 120; this.offsetHeight = 50;
        const classes = new Set();
        this.classList = {
            add: value => classes.add(value), remove: value => classes.delete(value),
            contains: value => classes.has(value), toggle: (value, enabled) => enabled ? classes.add(value) : classes.delete(value)
        };
    }
    set innerHTML(value) { this.children = []; this.markup = value; }
    appendChild(child) { this.children.push(child); }
    setAttribute(key, value) { this.attributes[key] = String(value); }
    getAttribute(key) { return this.attributes[key] ?? null; }
    addEventListener(key, listener) { this.events[key] = listener; }
    getBoundingClientRect() { return { left: 100, top: 156, width: 44, height: 44, bottom: 200 }; }
    focus() { if (this.events.focus) this.events.focus(); }
    contains(node) { return node === this || this.children.some(child => child.contains(node)); }
}
const elements = new Map();
const element = id => {
    if (!elements.has(id)) elements.set(id, new Element());
    return elements.get(id);
};
const source = fs.readFileSync(path.join(__dirname,
    '../241611JalopEventsManagement/Frontend/Admin/EventAnalytics.aspx'), 'utf8');
const script = source.match(/<script type="text\/javascript">([\s\S]*?)<\/script>/)[1];
const sheets = { tblPresent: [], tblNoShow: [], tblCancelled: [] };
const timers = new Map(), documentEvents = {}, windowEvents = {};
let timerId = 0;
const context = vm.createContext({ console, setTimeout(callback) { timers.set(++timerId, callback); return timerId; }, clearTimeout(id) { timers.delete(id); },
window: { innerWidth: 390, innerHeight: 844, addEventListener(key, listener) { windowEvents[key] = listener; } }, document: {
    getElementById: element, createElement: () => new Element(), createElementNS: (namespace, tag) => { const node = new Element(); node.tagName = tag; return node; },
    addEventListener(key, listener) { documentEvents[key] = listener; }, querySelectorAll(selector) { return sheets[selector.split(' ')[0].slice(1)] || []; }
} });
vm.runInContext(script, context);
const run = code => vm.runInContext(code, context);
const fixture = [
    { studentId: '24-001', fullName: 'Alex Reyes', department: 'Computing', course: 'BSIT', year: 1, cancelled: false },
    { studentId: '24-002', fullName: 'Jamie Santos', department: 'Computing', course: 'BSIT', year: 2, cancelled: true },
    { studentId: '24-003', fullName: 'Sam Reyes', department: 'Education', course: 'BSEd', year: 1, cancelled: false }
];
run('telemetryData = ' + JSON.stringify({ registrations: fixture }));
fixture.forEach((r, index) => {
    const row = new Element();
    row.setAttribute('data-search', r.studentId + ' ' + r.fullName + ' TCK-' + index);
    row.setAttribute('data-dept', r.department);
    row.setAttribute('data-course', r.course);
    row.setAttribute('data-year', r.year);
    sheets[r.cancelled ? 'tblCancelled' : 'tblPresent'].push(row);
});
run('initializeCohortFilters(); renderReservationChart(); filterCohortTable();');
assert.deepStrictEqual(element('ddlCohortDepartment').children.map(x => x.value), ['Computing', 'Education']);
assert.strictEqual(element('reservationCenterCount').textContent, '3');
assert(element('reservationPieSvg').attributes['aria-label'].includes('Reserved: 2 (66.7%)'));
assert.strictEqual(element('reservationPieSvg').children.length, 2);

element('txtCohortSearch').value = ' REYES ';
run('filterCohortTable()');
assert.strictEqual(element('rosterFilterSummary').textContent, 'Showing 2 of 2 present attendees');
element('ddlCohortDepartment').value = 'Computing';
element('ddlCohortCourse').value = 'BSIT';
element('ddlCohortYear').value = '1';
run('filterCohortTable()');
assert.strictEqual(element('rosterFilterSummary').textContent, 'Showing 1 of 2 present attendees');
assert.strictEqual(sheets.tblPresent[1].style.display, 'none', 'all academic filters combine with search');
assert.strictEqual(element('reservationCenterCount').textContent, '3', 'roster filters leave event-wide chart unchanged');
element('txtCohortSearch').value = '24-002';
element('ddlCohortYear').value = '2';
run("switchSheet('cancelled')");
assert.strictEqual(element('rosterFilterSummary').textContent, 'Showing 1 of 1 cancelled attendees', 'filters persist across status tabs');
assert.strictEqual(sheets.tblCancelled[0].style.display, '');
element('txtCohortSearch').value = ' TCK-1 ';
run('filterCohortTable()');
assert.strictEqual(element('rosterFilterEmpty').hidden, true, 'ticket-reference search remains available');

const slice = element('reservationPieSvg').children[1];
const legend = element('reservationLegend').children[1];
const event = { currentTarget: legend, clientX: 380, clientY: 840 };
legend.events.mouseenter(event);
assert(slice.classList.contains('is-highlighted'));
assert(legend.classList.contains('is-highlighted'));
assert.strictEqual(element('pieTooltipTitle').textContent, 'Cancelled');
assert.strictEqual(element('pieTooltipPercent').textContent, '(33.3%)');
assert.strictEqual(element('pieInteractiveTooltip').style.left, '262px', 'tooltip stays within mobile viewport');
assert.strictEqual(element('pieInteractiveTooltip').style.top, '786px');
legend.events.mouseleave();
assert(!slice.classList.contains('is-highlighted'));
legend.events.focus({ currentTarget: legend });
assert.strictEqual(element('pieInteractiveTooltip').style.display, 'block', 'keyboard focus exposes tooltip');
legend.events.keydown({ key: 'Escape' });
assert.strictEqual(element('pieInteractiveTooltip').style.display, 'none');

element('txtCohortSearch').value = 'missing student';
run('filterCohortTable()');
assert.strictEqual(element('rosterFilterEmpty').hidden, false);
assert.strictEqual(element('rosterFilterSummary').textContent, 'Showing 0 of 1 cancelled attendees');
run('resetCohortFilters()');
assert.strictEqual(element('rosterFilterSummary').textContent, 'Showing 1 of 1 cancelled attendees', 'reset preserves selected tab');
run("switchSheet('noshow')");
assert.strictEqual(element('rosterFilterEmpty').textContent, 'No no-show attendees for this event.');
run('telemetryData.registrations = []; renderReservationChart()');
assert.strictEqual(element('reservationChartSummary').textContent, 'No reserved or cancelled registrations');
assert(element('reservationPieSvg').classList.contains('is-empty'));
run('telemetryData.registrations = [{cancelled: false}]; renderReservationChart()');
assert.strictEqual(element('reservationPieSvg').children.length, 1, 'zero-count categories have no slice');
assert.strictEqual(element('reservationPieSvg').children[0].attributes['fill-rule'], 'evenodd', '100% donut retains its hole');
assert(!element('reservationPieSvg').children[0].attributes.d.includes('NaN'));

run('renderDonutChart([{label: "<img onerror=alert(1)>", count: 1, percentage: 100}], "demographicsPieSvg", "demographicsLegend", "pieCenterCount", "pieCenterLabel", "Program", "Empty")');
assert.strictEqual(element('demographicsLegend').children[0].children[0].children[1].textContent, '<img onerror=alert(1)>', 'labels remain text');
run('telemetryData.intervals = []; renderCheckInFlowChart()');
assert.strictEqual(element('checkInFlowEmpty').hidden, false);
assert.strictEqual(element('checkInFlowChart').hidden, true);
assert.strictEqual(element('checkInIntervalDetails').hidden, true);
assert.strictEqual(element('checkInFlowSvg').children.length, 0, 'empty attendance never fabricates a trend');
assert.strictEqual(element('checkInInterval').value, '15', 'interval defaults to fifteen minutes');
assert.strictEqual(element('checkInInterval').disabled, true, 'empty attendance disables the interval selector');
run('telemetryData.intervals = ' + JSON.stringify([
    { window: '9:00 AM – 9:15 AM', label: '9:00 AM', count: 3 },
    { window: '9:15 AM – 9:30 AM', label: '9:15 AM', count: 0 },
    { window: '9:30 AM – 9:45 AM', label: '9:30 AM', count: 3 }
]) + '; renderCheckInFlowChart()');
assert.strictEqual(element('checkInFlowChart').hidden, false);
assert.strictEqual(element('checkInIntervalDetails').hidden, false);
assert.strictEqual(element('checkInInterval').disabled, false);
const points = element('checkInFlowSvg').children.filter(node => node.tagName === 'g');
assert.strictEqual(points.length, 3, 'every interval has an inspectable point');
assert.strictEqual(points[1].children[1].attributes.cy, '248', 'zero-arrival gap touches the zero baseline');
assert.strictEqual(points.filter(point => point.attributes.class.includes('is-peak')).length, 2, 'all tied peaks are marked');
points[0].events.focus();
assert.strictEqual(element('checkInFlowPointDetail').textContent, '9:00 AM – 9:15 AM: 3 check-ins (peak)');
assert.strictEqual(element('checkInFlowTooltip').hidden, false);
assert.strictEqual(element('checkInTooltipCount').textContent, '3');
assert.strictEqual(element('checkInTooltipShare').textContent, '50.0% of confirmed arrivals');
assert.strictEqual(element('checkInTooltipPeak').hidden, false);
points[0].events.keydown({ key: 'ArrowRight', preventDefault() {} });
assert.strictEqual(element('checkInTooltipCount').textContent, '0', 'arrow keys inspect the adjacent interval');
assert.strictEqual(element('checkInTooltipChange').textContent, '3 fewer than the previous interval');
documentEvents.keydown({ key: 'Escape' });
assert.strictEqual(element('checkInFlowTooltip').hidden, true, 'Escape dismisses the tooltip');
points[1].events.click();
assert.strictEqual(element('checkInFlowPointDetail').textContent, '9:15 AM – 9:30 AM: 0 check-ins', 'tap also exposes exact counts');
assert.strictEqual(element('checkInTooltipPeak').hidden, true, 'zero-count gaps are not identified as peaks');
points[1].events.blur();
element('checkInFlowTooltip').onmouseenter();
assert.strictEqual(timers.size, 0, 'tooltip remains visible while its content is hovered');
element('checkInFlowTooltip').onmouseleave();
for (const callback of [...timers.values()]) callback();
assert.strictEqual(element('checkInFlowTooltip').hidden, true, 'tooltip dismisses after leaving its content');
run('focusCheckInPeak()');
assert.strictEqual(element('checkInTooltipCount').textContent, '3', 'Inspect peak focuses the earliest tied peak');
windowEvents.scroll();
assert.strictEqual(element('checkInFlowTooltip').hidden, false, 'scroll keeps the tooltip anchored to a visible point');
points[0].getBoundingClientRect = () => ({left: 100, top: -100, width: 44, bottom: -56});
windowEvents.scroll();
assert.strictEqual(element('checkInFlowTooltip').hidden, true, 'scroll hides a tooltip whose point leaves the viewport');
const edgePosition = context.getCheckInTooltipPosition({left: 370, top: 5, width: 20, bottom: 25}, 252, 160, 390, 844);
assert(edgePosition.left >= 12 && edgePosition.left + 252 <= 378, 'tooltip stays inside a narrow viewport');
assert.strictEqual(edgePosition.placement, 'below', 'tooltip flips below points near the viewport top');
assert(edgePosition.top >= 12 && edgePosition.top + 160 <= 832);
run('telemetryData.intervals = [{ window: "9:00 AM – 9:15 AM", label: "9:00 AM", count: 1 }]; renderCheckInFlowChart()');
const lonePoint = element('checkInFlowSvg').children.find(node => node.tagName === 'g').children[1];
assert(Number.isFinite(Number(lonePoint.attributes.cx)) && Number.isFinite(Number(lonePoint.attributes.cy)), 'a single interval renders without invalid coordinates');
assert(!element('checkInFlowSvg').children.find(node => node.tagName === 'polyline').attributes.points.includes('NaN'));
const series = {
    5: [
        {window: '9:00 AM – 9:05 AM', label: '9:00 AM', count: 1},
        {window: '9:05 AM – 9:10 AM', label: '9:05 AM', count: 0},
        {window: '9:10 AM – 9:15 AM', label: '9:10 AM', count: 3},
        {window: '9:15 AM – 9:20 AM', label: '9:15 AM', count: 2}
    ],
    15: [{window: '9:00 AM – 9:15 AM', label: '9:00 AM', count: 4}, {window: '9:15 AM – 9:30 AM', label: '9:15 AM', count: 2}],
    30: [{window: '9:00 AM – 9:30 AM', label: '9:00 AM', count: 6}]
};
run('telemetryData.intervalSeries = ' + JSON.stringify(series));
for (const minutes of [5, 30, 15]) {
    element('checkInInterval').value = String(minutes);
    run('renderCheckInFlowChart(); focusCheckInPeak();');
    const expectedPeak = Math.max(...series[minutes].map(item => item.count));
    assert.strictEqual(element('checkInFlowTitle').textContent, `Check-ins every ${minutes} minutes`);
    assert(element('checkInFlowSvg').attributes['aria-label'].includes(`every ${minutes} minutes`));
    assert.strictEqual(element('checkInIntervalRows').children.length, series[minutes].length, 'table follows the selected interval');
    assert.strictEqual(element('checkInTableCaption').textContent, `Check-ins by ${minutes}-minute interval`);
    assert.strictEqual(element('checkInTooltipCount').textContent, String(expectedPeak), 'peak action inspects the newly regrouped data');
    assert(element('checkInPeakSummary').textContent.startsWith(`Peak: ${expectedPeak} check-ins`));
    assert.strictEqual(element('checkInTooltipShare').textContent, (100 * expectedPeak / 6).toFixed(1) + '% of confirmed arrivals');
    assert.strictEqual(element('checkInIntervalRows').children.reduce((sum, row) => sum + Number(row.children[1].textContent), 0), 6);
}
element('checkInInterval').value = '5';
run('renderCheckInFlowChart()');
assert.strictEqual(element('checkInFlowTooltip').hidden, true, 'changing interval dismisses the old tooltip');
element('checkInInterval').value = '99';
run('renderCheckInFlowChart()');
assert.strictEqual(element('checkInInterval').value, '15', 'invalid selection falls back to the default');
run('telemetryData.intervalSeries = {5: [], 15: [], 30: []}; renderCheckInFlowChart()');
assert.strictEqual(element('checkInPeakSummary').textContent, 'No check-ins recorded yet.');
assert.strictEqual(element('checkInIntervalRows').children.length, 0);
assert.strictEqual(element('checkInInterval').disabled, true);
console.log('PASS: roster filters, donut interaction, check-in chart states, tooltips, keyboard navigation, and interval selection with synchronized peaks, tables, counts, and empty states.');
