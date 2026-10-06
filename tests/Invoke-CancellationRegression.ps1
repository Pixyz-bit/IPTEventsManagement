param([int]$Port = 51892, [switch]$Review)
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$projectRoot = Split-Path $PSScriptRoot -Parent
$appRoot = Join-Path $projectRoot '241611JalopEventsManagement'
$runId = [Guid]::NewGuid().ToString('N')
$databaseName = 'JalopCancellationTest_' + $runId
$testRoot = Join-Path $env:TEMP $databaseName
$sqlcmd = 'C:/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/SQLCMD.EXE'
$server = '(localdb)\MSSQLLocalDB'
$connection = "Data Source=$server;Initial Catalog=$databaseName;Integrated Security=True;Encrypt=False;Connect Timeout=5;Pooling=False;"
$process = $null
$checks = 0
function Assert-Test([bool]$ok, [string]$name) {
    if (!$ok) { throw "FAIL: $name" }
    $script:checks++
    Write-Output "PASS: $name"
}
function Invoke-TestSql([string]$query) {
    $sqlPath = Join-Path $testRoot 'query.sql'
    [IO.File]::WriteAllText($sqlPath, $query, [Text.UTF8Encoding]::new($true))
    & $sqlcmd -S $server -d $databaseName -E -l 10 -t 10 -b -i $sqlPath
    if ($LASTEXITCODE -ne 0) { throw 'Fixture SQL failed' }
}
function Hidden-Form([string]$html) {
    $form = @{}
    foreach ($match in [regex]::Matches($html, '<input[^>]*type="hidden"[^>]*name="([^"]+)"[^>]*value="([^"]*)"[^>]*>')) {
        $form[[System.Net.WebUtility]::HtmlDecode($match.Groups[1].Value)] = [System.Net.WebUtility]::HtmlDecode($match.Groups[2].Value)
    }
    return $form
}
try {
    [void](New-Item -ItemType Directory -Path $testRoot)
    $schema = [IO.File]::ReadAllText((Join-Path $appRoot 'Backend/Database/Migration/05_ConsolidatedDatabaseSchema.sql')).Replace('UniversityEventDB', $databaseName)
    if ($schema.Contains('UniversityEventDB')) { throw 'Unsafe schema target' }
    $schemaPath = Join-Path $testRoot 'schema.sql'
    [IO.File]::WriteAllText($schemaPath, $schema, [Text.UTF8Encoding]::new($true))
    & $sqlcmd -S $server -d master -E -l 10 -t 15 -b -i $schemaPath
    if ($LASTEXITCODE -ne 0) { throw 'Isolated schema creation failed' }
    # Simulate an existing installation without the lifecycle default or constraint.
    Invoke-TestSql 'ALTER TABLE dbo.EventsTable DROP CONSTRAINT CK_EventsTable_Status; ALTER TABLE dbo.EventsTable DROP CONSTRAINT DF_EventsTable_Status;'
    foreach ($migrationPass in 1..2) {
        & $sqlcmd -S $server -d $databaseName -E -l 10 -t 15 -b -i (Join-Path $appRoot 'Backend/Database/Migration/06_EnforceEventLifecycleStatuses.sql')
        if ($LASTEXITCODE -ne 0) { throw 'Lifecycle migration failed' }
    }
    Invoke-TestSql @'
INSERT INTO dbo.UserTable (Email,PasswordHash,PasswordSalt,Role) VALUES
 ('admin@example.invalid','test','test','Admin'), ('student@example.invalid','test','test','Student');
INSERT INTO dbo.StudentTable (StudentId,FirstName,LastName,Gender,CampusBranch,Department,Program,UserId) VALUES
 ('TEST-1','Test','One','Other','San Bartolome','College of Computer Studies','BSIT',2),
 ('TEST-2','Test','Two','Other','San Bartolome','College of Computer Studies','BSIT',2),
 ('TEST-3','Test','Three','Other','San Bartolome','College of Computer Studies','BSIT',2);
DECLARE @i int=1;
WHILE @i <= 9
BEGIN
 INSERT INTO dbo.EventsTable (Title,VenueLocation,MaxCapacity,CurrentRegistrations,CreatedByUserId,EventStart,EventEnd,RegStart,RegEnd,Status,CancellationReason)
 VALUES ('Fixture event '+CAST(@i AS varchar(10)),'Test venue',50,CASE WHEN @i=1 THEN 2 WHEN @i IN (5,8) THEN 1 ELSE 0 END,1,
 DATEADD(day,2,GETDATE()),DATEADD(day,3,GETDATE()),DATEADD(day,-1,GETDATE()),DATEADD(day,1,GETDATE()),
 CASE @i WHEN 2 THEN 'Completed' WHEN 3 THEN 'Cancelled' ELSE 'Upcoming' END,
 CASE WHEN @i=3 THEN 'Original reason' ELSE NULL END);
 SET @i=@i+1;
END
INSERT INTO dbo.EventRegistrationTable (EventId,StudentId,CurrentYearLvl,CurrentSection,Status,CheckInTimestamp) VALUES
 (1,'TEST-1',1,'TEST','NoShow',NULL), (1,'TEST-2',1,'TEST','Present',GETDATE()),
 (5,'TEST-1',1,'TEST','NoShow',NULL), (8,'TEST-1',1,'TEST','NoShow',NULL);
'@
    Copy-Item (Join-Path $appRoot 'bin') $testRoot -Recurse
    $runner = Join-Path $testRoot 'bin/CancellationRegression.exe'
    $assembly = Join-Path $testRoot 'bin/241611JalopEventsManagement.dll'
    & 'C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe' /nologo /target:exe "/out:$runner" "/reference:$assembly" /reference:System.Data.dll /reference:System.Configuration.dll (Join-Path $PSScriptRoot 'CancellationRegression.cs')
    if ($LASTEXITCODE -ne 0) { throw 'Test compilation failed' }
    [IO.File]::WriteAllText(($runner + '.config'), '<configuration><connectionStrings><add name="UniversityEventDBConnection" connectionString="' + $connection + '" /></connectionStrings></configuration>')
    & $runner
    if ($LASTEXITCODE -ne 0) { throw 'Repository regressions failed' }

    Copy-Item (Join-Path $appRoot 'Frontend') $testRoot -Recurse
    Copy-Item (Join-Path $appRoot 'Default.aspx') $testRoot
    [xml]$config = Get-Content (Join-Path $appRoot 'Web.config')
    $config.configuration.connectionStrings.add.connectionString = $connection
    $config.Save((Join-Path $testRoot 'Web.config'))
    # This session helper exists exclusively in the disposable clone.
    [IO.File]::WriteAllText((Join-Path $testRoot 'VerificationSession.aspx'), @'
<%@ Page Language="C#" %>
<script runat="server">
protected void Page_Load(object sender, EventArgs e) {
 Session["UserId"] = 1; Session["Role"] = Request.QueryString["role"] ?? "Admin";
 Session["Email"] = "verification@example.invalid"; Session["StudentId"] = "TEST-1";
 Session["CampusBranch"]="San Bartolome"; Session["Department"]="College of Computer Studies"; Session["Program"]="BSIT";
 _241611JalopEventsManagement.Backend.Repository.DatabaseConnection.RecordConnectionSuccess();
 Response.Write("Isolated session ready");
}
</script>
'@)
    $process = Start-Process 'C:/Program Files/IIS Express/iisexpress.exe' -ArgumentList @('/path:"' + $testRoot + '"', '/port:' + $Port, '/systray:false') -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $testRoot 'iis-out.log') -RedirectStandardError (Join-Path $testRoot 'iis-error.log')
    $base = 'http://localhost:' + $Port
    $ready = $false
    for ($attempt = 0; $attempt -lt 20; $attempt++) {
        try { $response=Invoke-WebRequest "$base/Frontend/Login/Login.aspx" -TimeoutSec 10; $ready=$response.StatusCode -eq 200; break } catch { Start-Sleep -Milliseconds 500 }
    }
    Assert-Test $ready 'Isolated app starts'
    $matrixUrl = "$base/Frontend/Admin/AdminEvents.aspx"
    $anon = Invoke-WebRequest $matrixUrl -TimeoutSec 15
    Assert-Test ($anon.BaseResponse.RequestMessage.RequestUri.AbsolutePath -eq '/Frontend/Login/Login.aspx') 'Anonymous admin request redirects to login'
    $session = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
    [void](Invoke-WebRequest "$base/VerificationSession.aspx" -WebSession $session)
    foreach ($studentPage in @('Dashboard','StudentProfile','EventRegistration','EventPass')) {
        $url = "$base/Frontend/User/$studentPage.aspx"
        $anonymous = Invoke-WebRequest $url
        Assert-Test ($anonymous.BaseResponse.RequestMessage.RequestUri.AbsolutePath -eq '/Frontend/Login/Login.aspx') "Anonymous $studentPage redirects to login"
        $anonymousPost = Invoke-WebRequest $url -Method Post -Body @{ '__EVENTTARGET'='btnConfirmRegistration' }
        Assert-Test ($anonymousPost.BaseResponse.RequestMessage.RequestUri.AbsolutePath -eq '/Frontend/Login/Login.aspx') "Anonymous $studentPage postback redirects before handlers"
        $adminDenied = Invoke-WebRequest $url -WebSession $session
        Assert-Test ($adminDenied.BaseResponse.RequestMessage.RequestUri.AbsolutePath -eq '/Frontend/AccessDenied.aspx') "Admin cannot access student $studentPage"
    }
    $matrix = Invoke-WebRequest $matrixUrl -WebSession $session
    Assert-Test ($matrix.Content.Contains('Cancel Event') -and !$matrix.Content.Contains('ToggleArchive')) 'Matrix renders cancellation and removes archive action'
    Assert-Test (!$matrix.Content.Contains('cancellation-reason') -and !$matrix.Content.Contains('[EVENT CANCELLED]')) 'Matrix omits inline cancellation reason and duplicate cancellation label'
    foreach ($tabName in @('Cancelled','Open','Soon','Close','All')) {
        $form=Hidden-Form $matrix.Content
        $form['__EVENTTARGET']='ctl00$MainContent$btnTab' + $tabName
        $matrix=Invoke-WebRequest $matrixUrl -Method Post -ContentType 'application/x-www-form-urlencoded' -Body $form -WebSession $session
        $labelsOk=$true
        foreach ($expected in @(@('All','All Events',9),@('Open','Open',4),@('Soon','Soon',0),@('Close','Close',1),@('Cancelled','Cancelled',4))) {
            $anchor=[regex]::Match($matrix.Content,'(?s)<a[^>]*id="[^"]*btnTab' + $expected[0] + '"[^>]*>(.*?)</a>')
            $text=[regex]::Replace($anchor.Groups[1].Value,'<[^>]*>',' ') -replace '\s+',' '
            $labelsOk=$labelsOk -and ($text.Trim() -eq ($expected[1] + ' ' + $expected[2]))
        }
        Assert-Test $labelsOk "All tab labels and counts survive $tabName filter postback"
        $active=[regex]::Match($matrix.Content,'<a[^>]*id="[^"]*btnTab' + $tabName + '"[^>]*class="tab-btn(?: tab-status-[a-z]+)? active"')
        Assert-Test $active.Success "$tabName filter remains selected"
    }
    $row=[regex]::Matches($matrix.Content,'(?s)<tr class=.event-matrix-row.*?</tr>') | Where-Object { $_.Value.Contains('Fixture event 9') } | Select-Object -First 1
    $decoded=[System.Net.WebUtility]::HtmlDecode($row.Value)
    $target=[regex]::Match($decoded,"__doPostBack\('([^']*btnCancelEventRow)'",'IgnoreCase').Groups[1].Value
    Assert-Test (![string]::IsNullOrEmpty($target)) 'Real row cancellation command rendered'
    $form=Hidden-Form $matrix.Content
    $form['__EVENTTARGET']=$target
    $rowModal=Invoke-WebRequest $matrixUrl -Method Post -ContentType 'application/x-www-form-urlencoded' -Body $form -WebSession $session
    Assert-Test ($rowModal.Content.Contains('Confirm Event Cancellation') -and $rowModal.Content.Contains('Fixture event 9')) 'Repeater postback opens correct event dialog'
    $form=Hidden-Form $rowModal.Content
    $form['ctl00$MainContent$btnCancelDismiss']='Keep Event'
    $kept=Invoke-WebRequest $matrixUrl -Method Post -ContentType 'application/x-www-form-urlencoded' -Body $form -WebSession $session
    Assert-Test ($kept.Content -notmatch 'id="[^"]*pnlCancelModal"') 'Keep Event dismisses dialog'
    Invoke-TestSql "IF NOT EXISTS(SELECT 1 FROM dbo.EventsTable WHERE EventId=9 AND Status='Upcoming') THROW 51000,'Keep Event changed the event',1;"
    $modal = Invoke-WebRequest ($matrixUrl + '?cancelEventId=8') -WebSession $session
    Assert-Test ($modal.Content.Contains('Confirm Event Cancellation') -and $modal.Content.Contains('Fixture event 8')) 'Details entry point opens confirmation without cancellation'
    $form=Hidden-Form $modal.Content
    $form['ctl00$MainContent$btnConfirmCancellation']='Confirm Cancellation'
    $form['ctl00$MainContent$txtCancellationReason']=' '
    $blank=Invoke-WebRequest $matrixUrl -Method Post -ContentType 'application/x-www-form-urlencoded' -Body $form -WebSession $session
    Assert-Test ($blank.Content.Contains('Enter a cancellation reason between 1 and 500 characters.')) 'Blank reason keeps dialog with inline error'
    $form=Hidden-Form $blank.Content
    $form['ctl00$MainContent$btnConfirmCancellation']='Confirm Cancellation'
    $form['ctl00$MainContent$txtCancellationReason']='x' * 501
    $long=Invoke-WebRequest $matrixUrl -Method Post -ContentType 'application/x-www-form-urlencoded' -Body $form -WebSession $session
    Assert-Test ($long.Content.Contains('Enter a cancellation reason between 1 and 500 characters.')) 'Server rejects oversized reason'
    $form=Hidden-Form $long.Content
    $form['ctl00$MainContent$btnConfirmCancellation']='Confirm Cancellation'
    $form['ctl00$MainContent$txtCancellationReason']='Created by mistake — UI test'
    $form['ctl00$MainContent$hfCancelEventId']='9'
    $cancelled=Invoke-WebRequest $matrixUrl -Method Post -ContentType 'application/x-www-form-urlencoded' -Body $form -WebSession $session
    $cancelledRow = [regex]::Matches($cancelled.Content, '(?s)<tr class=.event-matrix-row.*?</tr>') | Where-Object { $_.Value.Contains('Fixture event 8') } | Select-Object -First 1
    Assert-Test ($cancelled.Content.Contains('Event cancelled. Registration and check-in are closed; existing records are retained.') -and $cancelledRow.Value.Contains('status-cancelled')) 'Cancellation succeeds and cancelled row remains visible'
    Invoke-TestSql "IF NOT EXISTS(SELECT 1 FROM dbo.EventsTable WHERE EventId=8 AND Status='Cancelled') OR NOT EXISTS(SELECT 1 FROM dbo.EventsTable WHERE EventId=9 AND Status='Upcoming') THROW 51000,'Hidden event ID tampering changed the wrong event',1;"
    Assert-Test $true 'Signed ViewState prevents hidden event ID tampering'
    $repeat=Invoke-WebRequest $matrixUrl -Method Post -ContentType 'application/x-www-form-urlencoded' -Body $form -WebSession $session
    Assert-Test ($repeat.Content.Contains('The event was not cancelled.')) 'Repeated stale submission fails safely'
    $details=Invoke-WebRequest "$base/Frontend/Admin/EventDetails.aspx?eventId=8" -WebSession $session
    Assert-Test ($details.Content.Contains('Created by mistake — UI test') -and !$details.Content.Contains('Restore to Students')) 'Event details display cancellation reason'
    $history=Invoke-WebRequest "$base/Frontend/Admin/EventHistory.aspx" -WebSession $session
    Assert-Test ($history.Content.Contains('Fixture event 8') -and $history.Content.Contains('Cancelled')) 'History retains cancelled event'
    $lookup=Invoke-WebRequest "$base/Frontend/Admin/AttendanceScanner.aspx/LookupAttendee" -Method Post -ContentType 'application/json' -Body '{"eventId":8,"query":"TCK-0008-00004"}' -WebSession $session
    $result=($lookup.Content | ConvertFrom-Json).d
    Assert-Test ($result.State -eq 'CancelledWarning' -and $result.Message.Contains('Created by mistake')) 'Scanner rejects cancelled event pass at lookup'
    $commit=Invoke-WebRequest "$base/Frontend/Admin/AttendanceScanner.aspx/CommitCheckIn" -Method Post -ContentType 'application/json' -Body '{"eventRegistrationId":4,"verificationMethod":"Regression"}' -WebSession $session
    $result=($commit.Content | ConvertFrom-Json).d
    Assert-Test (!$result.Success -and $result.Message.Contains('cancelled')) 'Scanner web method cannot bypass cancelled event check'
    $failedModal=Invoke-WebRequest ($matrixUrl + '?cancelEventId=9') -WebSession $session
    [IO.File]::WriteAllText((Join-Path $testRoot 'before-failure.html'), $failedModal.Content)
    Assert-Test ($failedModal.Content -match 'id="[^"]*pnlCancelModal"') 'Failure test starts with an open confirmation'
    Invoke-TestSql "CREATE TRIGGER dbo.RejectTestCancellation ON dbo.EventsTable AFTER UPDATE AS BEGIN THROW 51001,'Simulated database failure',1; END;"
    $form=Hidden-Form $failedModal.Content
    $form['ctl00$MainContent$btnConfirmCancellation']='Confirm Cancellation'
    $form['ctl00$MainContent$txtCancellationReason']='Retain this reason after failure'
    $form['__EVENTTARGET']=''
    $form['__EVENTARGUMENT']=''
    $failure=Invoke-WebRequest $matrixUrl -Method Post -ContentType 'application/x-www-form-urlencoded' -Body $form -WebSession $session
    [IO.File]::WriteAllText((Join-Path $testRoot 'cancellation-failure.html'), $failure.Content)
    Assert-Test ($failure.Content.Contains('Unable to save cancellation.') -and $failure.Content.Contains('Retain this reason after failure') -and $failure.Content -match 'id="[^"]*pnlCancelModal"') 'Database failure keeps reason and open confirmation'
    Invoke-TestSql "DROP TRIGGER dbo.RejectTestCancellation; IF NOT EXISTS(SELECT 1 FROM dbo.EventsTable WHERE EventId=9 AND Status='Upcoming') THROW 51000,'Failed cancellation changed event',1;"
    [void](Invoke-WebRequest "$base/VerificationSession.aspx" -WebSession $session)
    Invoke-TestSql "EXEC sp_rename 'dbo.EventsTable','EventsUnavailable';"
    $failure=Invoke-WebRequest $matrixUrl -WebSession $session
    Assert-Test ($failure.Content.Contains('Unable to load events.') -and !$failure.Content.Contains('Fixture event') -and !$failure.Content.Contains('btnCancelEventRow')) 'Database read failure shows error without fake actionable events'
    Invoke-TestSql "EXEC sp_rename 'dbo.EventsUnavailable','EventsTable';"
    [void](Invoke-WebRequest "$base/VerificationSession.aspx" -WebSession $session)
    [void](Invoke-WebRequest "$base/VerificationSession.aspx?role=Student" -WebSession $session)
    $pass=Invoke-WebRequest "$base/Frontend/User/EventPass.aspx?regId=4" -WebSession $session
    Assert-Test ($pass.Content.Contains('EVENT CANCELLED') -and $pass.Content.Contains('Created by mistake') -and !$pass.Content.Contains('id="btnDownloadPass"')) 'Student pass clearly invalid and download removed'
    Assert-Test ($pass.Content.Contains('if (!false) return;')) 'Cancelled pass does not generate QR'
    $registration=Invoke-WebRequest "$base/Frontend/User/EventRegistration.aspx?eventId=8" -WebSession $session
    Assert-Test ($registration.Content.Contains('This event is unavailable or cancelled. Registration is closed.')) 'Student registration page blocks cancelled event'
    $dashboard=Invoke-WebRequest "$base/Frontend/User/Dashboard.aspx" -WebSession $session
    Assert-Test ($dashboard.Content.Contains('EVENT CANCELLED')) 'Student dashboard labels cancelled registrations'
    Assert-Test (!$dashboard.Content.Contains('DEMO PREVIEW') -and !$dashboard.Content.Contains('Martin Jalop')) 'Student dashboard renders without preview identity'
    $profile = Invoke-WebRequest "$base/Frontend/User/StudentProfile.aspx" -WebSession $session
    Assert-Test ($profile.Content.Contains('Test') -and !$profile.Content.Contains('DEMO PREVIEW') -and !$profile.Content.Contains('Martin Jalop')) 'Real student profile renders without demo fallback'
    $otherPass = Invoke-WebRequest "$base/Frontend/User/EventPass.aspx?regId=2" -WebSession $session
    Assert-Test ($otherPass.BaseResponse.RequestMessage.RequestUri.AbsolutePath -eq '/Frontend/User/Dashboard.aspx') 'Student cannot view another student pass'
    Invoke-TestSql "EXEC sp_rename 'dbo.EventsTable','EventsUnavailable';"
    $emptyDashboard = Invoke-WebRequest "$base/Frontend/User/Dashboard.aspx" -WebSession $session
    Assert-Test (!$emptyDashboard.Content.Contains('AI &amp; Cloud Architecture Workshop') -and !$emptyDashboard.Content.Contains('Cybersecurity and AI Convention') -and !$emptyDashboard.Content.Contains('DEMO PREVIEW')) 'Database outage renders without fabricated events'
    Invoke-TestSql "EXEC sp_rename 'dbo.EventsUnavailable','EventsTable';"
    Invoke-TestSql "UPDATE dbo.EventRegistrationTable SET Status='NoShow', CheckInTimestamp=NULL WHERE EventRegistrationId=3;"
    $activePass=Invoke-WebRequest "$base/Frontend/User/EventPass.aspx?regId=3" -WebSession $session
    Assert-Test ($activePass.Content.Contains('id="qrCanvas"') -and $activePass.Content.Contains('id="btnDownloadPass"') -and $activePass.Content.Contains('pass-status-active')) 'Active pass retains QR, download and styled status'
    Invoke-TestSql "UPDATE dbo.EventRegistrationTable SET Status='Present', CheckInTimestamp=GETDATE() WHERE EventRegistrationId=3;"
    $checkedPass=Invoke-WebRequest "$base/Frontend/User/EventPass.aspx?regId=3" -WebSession $session
    Assert-Test ($checkedPass.Content.Contains('id="qrCanvas"') -and $checkedPass.Content.Contains('pass-status-checked-in') -and $checkedPass.Content.Contains('PRESENT &amp; CHECKED IN') -and $checkedPass.Content.Contains('Attendance confirmed.')) 'Checked-in pass displays QR and styled attendance confirmation'
    Assert-Test (!$checkedPass.Content.Contains('id="btnDownloadPass"') -and $checkedPass.Content.Contains('if (!true) return;')) 'Checked-in QR remains visible without enabling ticket download or reuse'
    $checkedPost=Invoke-WebRequest "$base/Frontend/User/EventPass.aspx?regId=3" -Method Post -Body (Hidden-Form $checkedPass.Content) -WebSession $session
    Assert-Test ($checkedPost.Content.Contains('PRESENT &amp; CHECKED IN') -and $checkedPost.Content.Contains('TCK-0005-00003')) 'Pass state and actual QR payload survive postback'
    $denied=Invoke-WebRequest $matrixUrl -WebSession $session
    Assert-Test ($denied.BaseResponse.RequestMessage.RequestUri.AbsolutePath -eq '/Frontend/AccessDenied.aspx') 'Student cannot access cancellation controls'
    [void](Invoke-WebRequest "$base/VerificationSession.aspx" -WebSession $session)
    Invoke-TestSql @'
INSERT INTO dbo.EventRegistrationTable (EventId,StudentId,CurrentYearLvl,CurrentSection,Status,CheckInTimestamp) VALUES
 (6,'TEST-1',1,'TEST','NoShow',NULL), (6,'TEST-2',1,'TEST','Cancelled',NULL), (6,'TEST-3',1,'TEST','Present',GETDATE());
'@
    $chartUrl = "$base/Frontend/Admin/EventAnalytics.aspx?eventId=6"
    $chart = Invoke-WebRequest $chartUrl -WebSession $session
    Assert-Test ($chart.Content.Contains('Reserved: 66.7 percent. Cancelled: 33.3 percent.') -and $chart.Content.Contains('3 reserved or cancelled registrations')) 'Reservation pie counts Present and NoShow once each and excludes Cancelled from reserved total'
    Assert-Test ($chart.Content -match 'Registered:</span>\s*<span class="stat-val">2</span>') 'Analytics uses actual active registrations despite a stale event capacity counter'
    Invoke-TestSql "UPDATE dbo.EventRegistrationTable SET Status='Present', CheckInTimestamp=GETDATE() WHERE EventId=6 AND Status='NoShow';"
    $chart = Invoke-WebRequest $chartUrl -WebSession $session
    Assert-Test ($chart.Content.Contains('Reserved: 66.7 percent. Cancelled: 33.3 percent.')) 'Checking in a reserved student does not change the reservation split'
    Invoke-TestSql "UPDATE dbo.EventRegistrationTable SET Status='Cancelled', CheckInTimestamp=NULL WHERE EventId=6;"
    $chart = Invoke-WebRequest $chartUrl -WebSession $session
    Assert-Test ($chart.Content.Contains('Reserved: 0.0 percent. Cancelled: 100.0 percent.')) 'Reservation pie supports all cancelled'
    Invoke-TestSql "UPDATE dbo.EventRegistrationTable SET Status='NoShow', CheckInTimestamp=NULL WHERE EventId=6 AND Status='Cancelled';"
    $chart = Invoke-WebRequest $chartUrl -WebSession $session
    Assert-Test ($chart.Content.Contains('Reserved: 100.0 percent. Cancelled: 0.0 percent.')) 'Reservation pie supports all reserved'
    Invoke-TestSql "UPDATE dbo.EventRegistrationTable SET Status='Present', CheckInTimestamp=GETDATE() WHERE EventId=6;"
    $chart = Invoke-WebRequest $chartUrl -WebSession $session
    Assert-Test ($chart.Content.Contains('Reserved: 100.0 percent. Cancelled: 0.0 percent.')) 'All Present students remain included in the reserved total'
    $chart = Invoke-WebRequest "$base/Frontend/Admin/EventAnalytics.aspx?eventId=3" -WebSession $session
    Assert-Test ($chart.Content.Contains('reservation-pie is-empty') -and $chart.Content.Contains('No reserved or cancelled registrations')) 'Reservation pie handles zero registrations without a misleading slice'
    Write-Output "WEB TOTAL PASSED: $checks"
    Write-Output "Isolated diagnostics: $testRoot"
    if ($Review) { [void](Read-Host 'Isolated app remains available for visual review. Press Enter when finished') }
}
finally {
    if ($process -and !$process.HasExited) { Stop-Process -Id $process.Id }
    # The generated name is checked before cleanup; never target the user's database.
    if ($databaseName -match '^JalopCancellationTest_[a-f0-9]{32}$') {
        & $sqlcmd -S $server -d master -E -l 10 -t 15 -b -Q "IF DB_ID('$databaseName') IS NOT NULL BEGIN ALTER DATABASE [$databaseName] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$databaseName]; END;"
    }
}
