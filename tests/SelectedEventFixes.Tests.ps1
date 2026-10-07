param(
    [Parameter(Mandatory = $true)][int]$QaEventId,
    [string]$StudentEmail = 'SBECED10@gmail.com'
)

# Run in Windows PowerShell after building. Temporarily changes only a named QA event,
# creates no registrations, and restores the event's original fields in finally.
$ErrorActionPreference = 'Stop'
$projectDir = Join-Path $PSScriptRoot '..\241611JalopEventsManagement'
Add-Type -AssemblyName System.Web
Add-Type -AssemblyName System.Data
[void][Reflection.Assembly]::LoadFrom((Join-Path $projectDir 'bin\241611JalopEventsManagement.dll'))
$repo = New-Object _241611JalopEventsManagement.Backend.Repository.EventRepository
$connection = New-Object System.Data.SqlClient.SqlConnection([_241611JalopEventsManagement.Backend.Repository.DatabaseConnection]::ConnectionString)
$connection.Open()
function Query([string]$sql) {
    $command = $connection.CreateCommand()
    $command.CommandText = $sql
    [void]$command.Parameters.AddWithValue('@EventId', $QaEventId)
    [void]$command.Parameters.AddWithValue('@Email', $StudentEmail)
    try {
        $table = New-Object System.Data.DataTable
        $reader = $command.ExecuteReader()
        try { $table.Load($reader) } finally { $reader.Dispose() }
        return ,$table
    } finally { $command.Dispose() }
}
function Assert([bool]$condition, [string]$name) {
    if (!$condition) { throw "FAIL: $name" }
    Write-Output "PASS: $name"
}
function SetCase([string]$changes) {
    [void](Query ("UPDATE dbo.EventsTable SET Status='Upcoming', EventEnd=DATEADD(day,7,GETDATE()), " +
        "RegStart=DATEADD(day,-1,GETDATE()), RegEnd=DATEADD(day,1,GETDATE()), MaxCapacity=2, CurrentRegistrations=0, " +
        "TargetBranch=NULL, TargetDepartment=NULL, TargetProgram=NULL, TargetYearLevel=NULL WHERE EventId=@EventId; " + $changes))
}

$baseline = (Query 'SELECT Title, Status, EventEnd, RegStart, RegEnd, MaxCapacity, CurrentRegistrations, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel FROM dbo.EventsTable WHERE EventId=@EventId').Rows[0]
if (!$baseline -or !$baseline.Title.StartsWith('QA ') -or $baseline.CurrentRegistrations -ne 0) {
    $connection.Dispose()
    throw 'Choose an unregistered event whose title starts with QA . No test changes were made.'
}
$student = (Query 'SELECT s.StudentId, s.Program FROM dbo.StudentTable s JOIN dbo.UserTable u ON u.UserId=s.UserId WHERE u.Email=@Email').Rows[0]
if (!$student) { $connection.Dispose(); throw 'Sample student not found.' }
try {
    $parsed = [DateTime]::MinValue
    Assert ([_241611JalopEventsManagement.Backend.Helpers.RegistrationDateTime]::TryParse('2026-10-13T23:17:42', [ref]$parsed)) 'parse exact date and time'
    Assert ([_241611JalopEventsManagement.Backend.Helpers.RegistrationDateTime]::ToInput($parsed) -eq '2026-10-13T23:17:42') 'preserve seconds on edit round trip'
    Assert (![_241611JalopEventsManagement.Backend.Helpers.RegistrationDateTime]::TryParse('2026-10-13', [ref]$parsed)) 'reject date-only submissions'
    Assert ([_241611JalopEventsManagement.Backend.Helpers.RegistrationDateTime]::ToDisplay([DateTime]'2026-10-07T00:00:00') -eq '10/07/2026 12:00 AM') 'midnight has no UTC offset shift'

    SetCase ''
    Assert ($repo.GetRegistrationUnavailableReason($QaEventId, $student.StudentId, $null) -eq '') 'eligible open event'
    SetCase "UPDATE dbo.EventsTable SET Status='Cancelled' WHERE EventId=@EventId"
    Assert ($repo.GetRegistrationUnavailableReason($QaEventId, $student.StudentId, $null) -match 'cancelled') 'cancelled event'
    SetCase "UPDATE dbo.EventsTable SET Status='Completed' WHERE EventId=@EventId"
    Assert ($repo.GetRegistrationUnavailableReason($QaEventId, $student.StudentId, $null) -match 'ended') 'completed event'
    SetCase 'UPDATE dbo.EventsTable SET CurrentRegistrations=MaxCapacity WHERE EventId=@EventId'
    Assert ($repo.GetRegistrationUnavailableReason($QaEventId, $student.StudentId, $null) -match 'fully booked') 'full event'
    SetCase 'UPDATE dbo.EventsTable SET RegStart=DATEADD(hour,1,GETDATE()) WHERE EventId=@EventId'
    Assert ($repo.GetRegistrationUnavailableReason($QaEventId, $student.StudentId, $null) -match 'not opened') 'not-yet-open window'
    SetCase 'UPDATE dbo.EventsTable SET RegEnd=DATEADD(second,5,GETDATE()) WHERE EventId=@EventId'
    Assert ($repo.GetRegistrationUnavailableReason($QaEventId, $student.StudentId, $null) -eq '') 'five seconds before deadline'
    SetCase 'UPDATE dbo.EventsTable SET RegEnd=DATEADD(second,-5,GETDATE()) WHERE EventId=@EventId'
    Assert ($repo.GetRegistrationUnavailableReason($QaEventId, $student.StudentId, $null) -match 'deadline has passed') 'five seconds after deadline'
    SetCase "UPDATE dbo.EventsTable SET TargetDepartment='College of Business Administration and Accountancy' WHERE EventId=@EventId"
    Assert ($repo.GetRegistrationUnavailableReason($QaEventId, $student.StudentId, $null) -match 'audience') 'college mismatch'
    SetCase "UPDATE dbo.EventsTable SET TargetBranch='QA-INELIGIBLE' WHERE EventId=@EventId"
    Assert ($repo.GetRegistrationUnavailableReason($QaEventId, $student.StudentId, $null) -match 'audience') 'campus mismatch'
    SetCase "UPDATE dbo.EventsTable SET TargetProgram='QA-INELIGIBLE' WHERE EventId=@EventId"
    Assert ($repo.GetRegistrationUnavailableReason($QaEventId, $student.StudentId, $null) -match 'audience') 'program mismatch'
    SetCase 'UPDATE dbo.EventsTable SET TargetYearLevel=2 WHERE EventId=@EventId'
    Assert ($repo.GetRegistrationUnavailableReason($QaEventId, $student.StudentId, $null) -eq '') 'year not assumed before selection'
    Assert ($repo.GetRegistrationUnavailableReason($QaEventId, $student.StudentId, 1) -match 'audience') 'wrong selected year'
    Assert ($repo.GetRegistrationUnavailableReason($QaEventId, $student.StudentId, 2) -eq '') 'matching selected year'
    Assert ($repo.GetRegistrationUnavailableReason(2147483647, $student.StudentId, $null) -match 'could not be found') 'nonexistent event'
} finally {
    $restore = $connection.CreateCommand()
    $fields = @('Status','EventEnd','RegStart','RegEnd','MaxCapacity','CurrentRegistrations','TargetBranch','TargetDepartment','TargetProgram','TargetYearLevel')
    $restore.CommandText = 'UPDATE dbo.EventsTable SET ' + (($fields | ForEach-Object { "$_=@$_" }) -join ',') + ' WHERE EventId=@EventId'
    [void]$restore.Parameters.AddWithValue('@EventId', $QaEventId)
    foreach ($field in $fields) { [void]$restore.Parameters.AddWithValue("@$field", $baseline[$field]) }
    try { [void]$restore.ExecuteNonQuery() } finally { $restore.Dispose(); $connection.Dispose() }
}
