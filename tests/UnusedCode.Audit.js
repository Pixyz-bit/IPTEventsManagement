// Candidate inventory only: public methods may be called by integrations, reflection, or tests.
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const root = path.resolve(__dirname, '../241611JalopEventsManagement');
const files=[];
function walk(dir) { for(const item of fs.readdirSync(dir,{withFileTypes:true})) {
  if(['bin','obj','packages','.git'].includes(item.name)) continue;
  const full=path.join(dir,item.name);
  if(item.isDirectory()) walk(full);
  else if(/\.(cs|aspx|Master|js)$/i.test(item.name)) files.push({path:full,source:fs.readFileSync(full,'utf8')});
}}
walk(root); const corpus=files.map(f=>f.source).join('\n');
let scriptCount=0, syntaxErrors=0, missingAssets=0;
for(const file of files) {
  const markup=file.source.replace(/<%=[\s\S]*?%>/g,'null').replace(/<%[\s\S]*?%>/g,'');
  const scripts=file.path.endsWith('.js')?[file.source]:Array.from(markup.matchAll(/<script\b([^>]*)>([\s\S]*?)<\/script>/gi)).filter(m=>!/type\s*=\s*["']application\/json/i.test(m[1])).map(m=>m[2]);
  for(const script of scripts) {
    if(!script.trim()) continue;
    const clean=script.replace(/<asp:Literal\b[^>]*\/>/gi,'null');
    // Server-side C# script blocks are compiled by aspnet_compiler instead.
    if(/protected void Page_Load/.test(clean)) continue;
    scriptCount++;
    try { new vm.Script(clean,{filename:path.relative(root,file.path)}); }
    catch(error) { syntaxErrors++;console.log(`SCRIPT ERROR ${path.relative(root,file.path)}: ${error.message}`); }
  }
  for(const match of file.source.matchAll(/~\/(Frontend\/Assets\/[^"'<>\r\n?]+)(?:\?[^"']*)?["']/g)) {
    const target=match[1];if(!/\.(css|js|png|jpg|jpeg|webp|svg|ico)$/i.test(target)) continue;
    if(!fs.existsSync(path.join(root,target))) { missingAssets++;console.log(`MISSING LITERAL ASSET CANDIDATE (may be guarded/dead) ${path.relative(root,file.path)}: ${target}`); }
  }
}
console.log(`STATIC RESULT: ${scriptCount} JavaScript blocks parsed; ${syntaxErrors} syntax errors; ${missingAssets} missing literal asset references.`);
for(const file of files.filter(f=>f.path.includes(path.sep+'Backend'+path.sep) || f.path.endsWith('.aspx.cs'))) {
  const definitions=/\b(public|private|protected|internal)\s+(?:static\s+)?(?:[\w.<>,\[\]?]+\s+)(\w+)\s*\(/g;
  for(const match of file.source.matchAll(definitions)) {
    const name=match[2];if(['Page_Load','OnInit','OnPreInit'].includes(name)) continue;
    const references=corpus.match(new RegExp('\\b'+name+'\\b','g'))||[];
    if(references.length===1) {
      const line=file.source.slice(0,match.index).split('\n').length;
      console.log(`${path.relative(root,file.path)}:${line} ${match[1]} ${name} — definition only in application sources`);
    }
  }
}
