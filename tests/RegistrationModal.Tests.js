// Database-free regression for the shortened student-modal argument list.
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const assert = require('assert');
const source = fs.readFileSync(path.join(__dirname,
    '../241611JalopEventsManagement/Frontend/Admin/EventPreRegistered.aspx'), 'utf8');
const functionStart = source.indexOf('    function openStudentModal(');
const functionEnd = source.indexOf('    function closeStudentModal(', functionStart);
assert(functionStart >= 0 && functionEnd > functionStart);
const elements = new Map();
const document = {
    getElementById(id) {
        if (!elements.has(id)) elements.set(id, { style: {}, classList: { add() {} } });
        return elements.get(id);
    }
};
const context = vm.createContext({ document });
vm.runInContext(source.slice(functionStart, functionEnd)
    .replace(/<%= btnModalCancelPass.ClientID %>/g, 'cancelButton'), context);
const calls = [...source.matchAll(/onclick='(openStudentModal\([^\r\n]*\))'/g)].map(match => match[1]);
assert.strictEqual(calls.length, 2, 'both active and cancelled roster buttons are tested');
for (const status of ['Present', 'Cancelled']) {
    const values = {
        StudentId: 'TEST-1', StudentFullName: 'Test Student', StudentEmail: 'test@example.test',
        StudentCampusBranch: 'Test Campus', StudentDepartment: 'Test Department', StudentProgram: 'Test Program',
        CurrentYearLvl: '2', CurrentSection: 'A', TicketReference: 'TCK-0001-00042',
        Status: status, EventRegistrationId: '42'
    };
    for (const call of calls) {
        const rendered = call.replace(/<%# Eval\("([^\"]+)"\) %>/g, (_, field) => {
            assert(Object.prototype.hasOwnProperty.call(values, field), `unexpected binding ${field}`);
            return values[field];
        });
        assert(!rendered.includes('<%'), 'all server bindings are resolved');
        vm.runInContext(rendered, context);
        assert.strictEqual(elements.get('modalStatusText').innerText, status);
        assert.strictEqual(elements.get('hfModalEventRegId').value, '42');
        assert.strictEqual(elements.get('modalTicketRef').innerText, 'TCK-0001-00042');
        assert.strictEqual(elements.get('cancelButton').style.display,
            status === 'Cancelled' ? 'none' : 'inline-flex');
    }
}
for (const file of ['EventPreRegistered.aspx', 'CreateEvent.aspx']) {
    const markup = fs.readFileSync(path.join(__dirname,
        '../241611JalopEventsManagement/Frontend/Admin', file), 'utf8');
    const scripts = [...markup.matchAll(/<script type="text\/javascript">([\s\S]*?)<\/script>/g)];
    assert(scripts.length > 0, `${file} inline script found`);
    scripts.forEach((match, index) => new vm.Script(match[1].replace(/<%[\s\S]*?%>/g, 'serverControl'),
        { filename: `${file}:${index + 1}` }));
}
console.log('PASS: both roster buttons preserve status, ticket reference, record ID and cancel visibility.');
console.log('PASS: changed inline JavaScript parses successfully.');
