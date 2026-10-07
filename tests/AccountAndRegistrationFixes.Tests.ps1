# Database-free regression checks against the freshly built application assembly.
$ErrorActionPreference = 'Stop'
$projectDir = Join-Path $PSScriptRoot '..\241611JalopEventsManagement'
Add-Type -AssemblyName System.Web
Add-Type -AssemblyName System.Data
[void][Reflection.Assembly]::LoadFrom((Join-Path $projectDir 'bin\241611JalopEventsManagement.dll'))
$script:passed = 0
function Assert([bool]$condition, [string]$name) {
    if (!$condition) { throw "FAIL: $name" }
    $script:passed++
    Write-Output "PASS: $name"
}
function AssertRejected([scriptblock]$action, [string]$name) {
    $rejected = $false
    try { & $action } catch {
        $errorObject = $_.Exception
        while ($errorObject.InnerException) { $errorObject = $errorObject.InnerException }
        if ($errorObject -isnot [ArgumentException]) { throw }
        $rejected = $true
    }
    Assert $rejected $name
}
$start = [DateTime]'2026-10-15T09:00:00'
$end = [DateTime]'2026-10-15T17:00:00'
$opening = [DateTime]'2026-10-07T14:25:19'
$deadline = [DateTime]'2026-10-14T23:17:42'
[_241611JalopEventsManagement.Backend.Helpers.RegistrationDateTime]::ValidateWindow($opening, $deadline, $start, $end)
$parsed = [DateTime]::MinValue
Assert ([_241611JalopEventsManagement.Backend.Helpers.RegistrationDateTime]::TryParse(
    [_241611JalopEventsManagement.Backend.Helpers.RegistrationDateTime]::ToInput($deadline), [ref]$parsed) -and $parsed -eq $deadline) 'edit round trip preserves hours, minutes and seconds'
AssertRejected { [_241611JalopEventsManagement.Backend.Helpers.RegistrationDateTime]::ValidateWindow($deadline, $opening, $start, $end) } 'reversed registration window'
AssertRejected { [_241611JalopEventsManagement.Backend.Helpers.RegistrationDateTime]::ValidateWindow($opening, $start.AddHours(-1), $start, $end) } 'same-day deadline follows existing calendar-date policy'
AssertRejected { [_241611JalopEventsManagement.Backend.Helpers.RegistrationDateTime]::ValidateWindow($opening, $deadline, $end, $start) } 'reversed event times'
AssertRejected { [_241611JalopEventsManagement.Backend.Helpers.RegistrationDateTime]::ValidateWindow([DateTime]'1700-01-01', $deadline, $start, $end) } 'SQL DATETIME minimum'

$repo = New-Object _241611JalopEventsManagement.Backend.Repository.EventRepository
$event = New-Object _241611JalopEventsManagement.Backend.Models.EventModel
$event.EventId = 1; $event.Title = 'Validation'; $event.VenueLocation = 'Test'; $event.MaxCapacity = 1; $event.CreatedByUserId = 1
$event.EventStart = $start; $event.EventEnd = $end; $event.RegStart = $deadline; $event.RegEnd = $opening
AssertRejected { $repo.CreateEvent($event) } 'creation rejects invalid window before connecting to database'
AssertRejected { $repo.UpdateEvent($event) } 'editing rejects invalid window before connecting to database'
$accountRepo = New-Object _241611JalopEventsManagement.Backend.Repository.UserRepository
$user = New-Object _241611JalopEventsManagement.Backend.Models.UserModel
$user.UserId = 1; $user.Email = 'test@example.test'; $user.Role = 'Admin'; $user.IsActive = $true
AssertRejected { $accountRepo.SaveManagedAccount($user, $null, '123', 1) } 'invalid password rejected before any database writes'
$user.Role = 'Student'
AssertRejected { $accountRepo.SaveManagedAccount($user, $null, '', 1) } 'missing student fields rejected before any database writes'

$table = New-Object System.Data.DataTable
foreach ($name in @('EventRegistrationId','EventId','StudentId','CurrentYearLvl','CurrentSection','Status','CheckInTimestamp')) { [void]$table.Columns.Add($name, [object]) }
$row = $table.NewRow()
$row.EventRegistrationId = 1; $row.EventId = 1; $row.StudentId = 'TEST'; $row.CurrentYearLvl = 1
$row.CurrentSection = 'A'; $row.Status = 'NoShow'; $row.CheckInTimestamp = [DBNull]::Value
$mapper = [_241611JalopEventsManagement.Backend.Repository.RegistrationRepository].GetMethod('MapRowToRegistration', [Reflection.BindingFlags]'NonPublic,Static')
$mapped = $mapper.Invoke($null, @($row))
Assert ($mapped.EventRegistrationId -eq 1 -and $mapped.StudentId -eq 'TEST' -and $mapped.Status -eq 'NoShow') 'existing registration table projection maps ticket identity and status'
Assert ($null -eq $mapped.CheckInTimestamp) 'unconfirmed attendance remains unchecked'
$row.CheckInTimestamp = $start
$row.Status = 'Present'
$mapped = $mapper.Invoke($null, @($row))
Assert ($mapped.CheckInTimestamp -eq $start -and $mapped.IsCheckedIn) 'actual attendance timestamp and checked-in status survive mapping'
Write-Output "$script:passed checks passed; no database connections or writes were made."
