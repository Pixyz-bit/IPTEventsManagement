# Database-free checks of the compiled profile selection and interval aggregation.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Web
[void][Reflection.Assembly]::LoadFrom((Join-Path $PSScriptRoot '..\241611JalopEventsManagement\bin\241611JalopEventsManagement.dll'))
$script:passed = 0
function Assert([bool]$condition, [string]$name) {
    if (!$condition) { throw "FAIL: $name" }
    $script:passed++
    Write-Output "PASS: $name"
}
$select = [_241611JalopEventsManagement.Frontend.Admin.StudentList].GetMethod('SelectStoredValue', [Reflection.BindingFlags]'NonPublic,Static')
$dropdown = New-Object System.Web.UI.WebControls.DropDownList
[void]$dropdown.Items.Add('BS Information Technology')
[void]$dropdown.Items.Add('BS Computer Science')
$select.Invoke($null, @($dropdown.PSObject.BaseObject, 'BSCS'))
Assert ($dropdown.SelectedValue -eq 'BSCS' -and $dropdown.SelectedItem.Text -eq 'BSCS') 'stored course code matches the directory and survives an unchanged save'
$select.Invoke($null, @($dropdown.PSObject.BaseObject, 'BS Information Systems'))
Assert ($dropdown.SelectedValue -eq 'BS Information Systems') 'unlisted course is selected instead of silently falling back to IT'
$select.Invoke($null, @($dropdown.PSObject.BaseObject, 'BS Computer Science'))
Assert ($dropdown.SelectedValue -eq 'BS Computer Science') 'existing full course name remains selected'
$before = $dropdown.Items.Count
$select.Invoke($null, @($dropdown.PSObject.BaseObject, 'BSCS'))
Assert ($dropdown.Items.Count -eq $before) 'reopening a stored code does not duplicate options'
$select.Invoke($null, @($dropdown.PSObject.BaseObject, $null))
Assert ($dropdown.SelectedValue -eq '') 'missing stored course does not inherit the previous student course'
$select.Invoke($null, @($dropdown.PSObject.BaseObject, 'Legacy College'))
Assert ($dropdown.SelectedValue -eq 'Legacy College') 'unlisted department can round-trip before program binding'

$builder = [_241611JalopEventsManagement.Frontend.Admin.EventAnalytics].GetMethod('BuildCheckInIntervals', [Reflection.BindingFlags]'NonPublic,Static')
function Intervals([DateTime[]]$times, [int]$minutes = 15) {
    $arguments = New-Object 'object[]' 2
    $arguments[0] = $times
    $arguments[1] = $minutes
    return ,$builder.Invoke($null, $arguments)
}
$empty = Intervals @()
Assert ($empty.Count -eq 0) 'no timestamps produces an empty chart, not a fabricated interval'
$single = Intervals @([DateTime]'2026-10-08T09:04:00')
Assert ($single.Count -eq 1 -and $single[0].CheckInCount -eq 1) 'one check-in produces one real point'
$bins = Intervals @([DateTime]'2026-10-08T09:14:59', [DateTime]'2026-10-08T09:00:00', [DateTime]'2026-10-08T09:15:00', [DateTime]'2026-10-08T10:00:00', [DateTime]'2026-10-08T10:01:00')
Assert ($bins.Count -eq 5) 'all quarter-hour windows between first and last arrivals are included'
Assert ($bins[0].CheckInCount -eq 2 -and $bins[1].CheckInCount -eq 1) '15-minute boundary belongs to the next interval'
Assert ($bins[2].CheckInCount -eq 0 -and $bins[3].CheckInCount -eq 0) 'gaps are plotted as zero arrivals'
Assert ($bins[0].IntensityPercent -eq 100 -and $bins[4].IntensityPercent -eq 100) 'both tied peak windows remain represented'
Assert (($bins | Measure-Object CheckInCount -Sum).Sum -eq 5) 'interval counts conserve the number of confirmed check-ins'
$overnight = Intervals @([DateTime]'2026-10-08T23:59:59', [DateTime]'2026-10-09T00:00:00')
Assert ($overnight.Count -eq 2 -and $overnight[0].IntervalStart.Date -ne $overnight[1].IntervalStart.Date) 'midnight boundary stays chronological'
Assert ($overnight[0].AxisLabel -ne $overnight[1].AxisLabel -and $overnight[0].IntervalWindow.Contains('Oct 9')) 'overnight labels include dates and the next-day interval end'
$sampleTimes = @([DateTime]'2026-10-08T09:04:59', [DateTime]'2026-10-08T09:05:00', [DateTime]'2026-10-08T09:29:59', [DateTime]'2026-10-08T09:30:00', [DateTime]'2026-10-08T10:00:00')
$five = Intervals $sampleTimes 5
Assert ($five.Count -eq 13 -and $five[0].CheckInCount -eq 1 -and $five[1].CheckInCount -eq 1) 'five-minute bins preserve exact boundaries and all empty gaps'
Assert ($five[5].CheckInCount -eq 1 -and $five[6].CheckInCount -eq 1) 'five-minute arrivals are regrouped from timestamps rather than split from quarter-hour totals'
$thirty = Intervals $sampleTimes 30
Assert ($thirty.Count -eq 3 -and $thirty[0].CheckInCount -eq 3 -and $thirty[1].CheckInCount -eq 1) 'thirty-minute bins regroup arrivals and assign the boundary to the next window'
foreach ($minutes in @(5, 15, 30)) {
    $series = Intervals $sampleTimes $minutes
    Assert (($series | Measure-Object CheckInCount -Sum).Sum -eq 5) "$minutes-minute grouping conserves the total confirmed arrivals"
    $emptySeries = Intervals @() $minutes
    Assert ($emptySeries.Count -eq 0) "$minutes-minute grouping retains the empty state"
    $nightSeries = Intervals @([DateTime]'2026-10-08T23:59:59', [DateTime]'2026-10-09T00:00:00') $minutes
    Assert ($nightSeries.Count -eq 2 -and $nightSeries[0].IntervalWindow.Contains('Oct 9')) "$minutes-minute grouping remains chronological across midnight"
}
$rejected = $false
try { $null = Intervals $sampleTimes 0 } catch { $rejected = $_.Exception.InnerException -is [ArgumentOutOfRangeException] }
Assert $rejected 'unsupported window sizes are rejected before aggregation'
Write-Output "$script:passed checks passed; no database connections or writes were made."
