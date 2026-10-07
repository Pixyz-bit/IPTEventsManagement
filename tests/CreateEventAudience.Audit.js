// Read-only audit of the actual wizard functions; no database or browser writes.
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const source = fs.readFileSync(path.join(__dirname, '../241611JalopEventsManagement/Frontend/Admin/CreateEvent.aspx'), 'utf8');
const start = source.indexOf('function onCourseSelectionChanged()');
const end = source.indexOf('// ─── Step 5', start);
const script = source.slice(start, end).replace(/<%=\s*(\w+)\.ClientID\s*%>/g, '$1');
const codes = [['BSIT','CCS'], ['BSCS','CCS'], ['BSEd','CED']];
const classes = () => { const values = new Set(); return { add:v=>values.add(v), remove:v=>values.delete(v), contains:v=>values.has(v) }; };
const inputs = codes.map(([value]) => ({value,checked:false}));
const cards = codes.map(([code,dept], i) => ({id:'card_'+code, style:{display:'flex'}, classList:classes(), getAttribute:()=>dept, querySelector:()=>inputs[i]}));
const hidden = {value:''}, department = {value:''};
const document = {
  getElementById:id=>id==='hfSelectedPrograms'?hidden:id==='ddlDepartment'?department:cards.find(c=>c.id===id),
  querySelectorAll:selector=>selector==='.course-picker-card'?cards:inputs
};
const context = vm.createContext({document}); vm.runInContext(script, context);
let passed=0, findings=0;
const check=(ok,name)=>{if(ok){passed++;console.log('PASS: '+name);}else{findings++;console.log('FINDING: '+name);}};
context.selectAllPrograms(true);check(hidden.value==='BSIT, BSCS, BSEd','all visible courses selected');
context.selectAllPrograms(false);check(hidden.value==='','clear means open to all');
inputs[0].checked=true;context.onCourseSelectionChanged();check(hidden.value==='BSIT','individual course persisted to hidden field');
context.filterProgramsByDepartment('CCS');check(cards[2].style.display==='none' && cards[0].style.display==='flex','department hides other courses');
context.selectAllPrograms(true);check(hidden.value==='BSIT, BSCS','select all affects only current department');
context.filterProgramsByDepartment('CED');check(!inputs[0].checked && !inputs[1].checked && hidden.value==='','switching college removes incompatible selected courses');
context.selectAllPrograms(true);check(hidden.value==='BSEd','select all in education picks education only');
// Simulate a full ASP.NET postback: hidden value returns, native checkboxes render unchecked.
department.value='CCS';hidden.value='BSIT';inputs.forEach(input=>input.checked=false);
context.restoreCourseSelection();
check(hidden.value==='BSIT' && inputs[0].checked,'saved program survives full sponsor postback');
console.log(`RESULT: ${passed} passed; ${findings} finding(s).`);
