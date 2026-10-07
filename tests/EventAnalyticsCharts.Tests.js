// Database-free interaction coverage for the actual analytics page script.
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const assert = require('assert');
class Element {
    constructor() {
        this.children = []; this.style = {}; this.attributes = {}; this.events = {}; this.value = '';
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
    getBoundingClientRect() { return { left: 100, bottom: 200 }; }
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
const context = vm.createContext({ console, window: { innerWidth: 390, innerHeight: 844 }, document: {
    getElementById: element, createElement: () => new Element(), createElementNS: () => new Element(),
    addEventListener() {}, querySelectorAll(selector) { return sheets[selector.split(' ')[0].slice(1)] || []; }
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
console.log('PASS: roster filters, ID/name/ticket search, tab persistence, reset, empty roster, unchanged chart totals, donut hover and keyboard tooltips.');
