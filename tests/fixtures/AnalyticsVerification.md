# Analytics verification fixture

The local database contains **QA - Analytics Verification**, event ID **23**.
Open: http://localhost:8080/Frontend/Admin/EventAnalytics.aspx?eventId=23&from=history

The completed event runs on **7 October 2026, 9:00 AM–11:00 AM**, using the application's current local-time convention. The registration window is 1 October at 9:00 AM through 6 October at 11:59:59 PM. Capacity is 100; non-cancelled registrations are 90.

## Expected analytics

| Metric | Expected |
|---|---:|
| Total attendee records | 100 |
| Reserved (present + no-show) | 90 |
| Present / confirmed check-ins | 60 |
| No-show | 30 |
| Cancelled | 10 |
| Turnout (60 / 90) | 66.7% |
| Venue load (60 / 100) | 60.0% |
| Seats remaining | 40 |
| Reservation chart | Reserved 90%; cancelled 10% |
| Peak arrivals | 25, 9:30 AM–9:45 AM |

| Interval | Check-ins |
|---|---:|
| 9:00 AM–9:15 AM | 5 |
| 9:15 AM–9:30 AM | 15 |
| 9:30 AM–9:45 AM | 25 |
| 9:45 AM–10:00 AM | 0 |
| 10:00 AM–10:15 AM | 10 |
| 10:15 AM–10:30 AM | 5 |

| Program | All records | Present | No-show | Cancelled |
|---|---:|---:|---:|---:|
| BSIT | 40 | 24 | 12 | 4 |
| BSCS | 30 | 18 | 9 | 3 |
| BS Industrial Engineering | 20 | 12 | 6 | 2 |
| BS Accountancy | 10 | 6 | 3 | 1 |

Each year level (1–4) has 25 total attendees and 15 present attendees. Campuses are San Bartolome (34), Batasan (33), and San Francisco (33); each has 20 present attendees. Sponsors are QA Campus Partners and QA Technology Club.

The demographic chart counts **non-cancelled registrations**, so its center should show **90**. Expected program counts are BSIT 36 (40%), BSCS 27 (30%), Industrial Engineering 18 (20%), and Accountancy 9 (10%). Departments are Computer Studies 63 (70%), Engineering 18 (20%), and Business/Accountancy 9 (10%). Each branch has 30 (33.3%); year levels 1–4 have 23, 23, 22, and 22 respectively.

## Manual checks

- Find the completed QA event in Event History and open its analytics.
- Confirm the peak marker, the zero-count interval, and the interval-data table.
- Change **Interval** from the default 15 minutes to 5 minutes: 18 points, with a peak of 10 at 9:35 AM–9:40 AM (the first of two tied intervals).
- Select 30 minutes: three intervals with counts 20, 25, and 15; peak 9:30 AM–10:00 AM. The heading, peak summary, tooltip, and interval table should update together without reloading.
- Switch back to 15 minutes to recover the six intervals above. Each interval setting totals 60 arrivals and leaves the roster and other charts unchanged.
- Focus or tap chart points to inspect their exact counts.
- Filter the Present roster to BSIT: 24 records. Switch to No-show: 12. Switch to Cancelled: 4.
- Search `QA-ANALYTICS-001`: one present student; check-in 9:00 AM. Reset filters afterward.
- Inspect program, department, year-level, and branch charts. Roster filters should not change the event-wide charts.
- Check the graph on a narrow viewport; the timeline can scroll horizontally.

## Seed and cleanup

The 100 synthetic student IDs are `QA-ANALYTICS-001` through `QA-ANALYTICS-100`. Their account emails use `example.invalid`; all accounts are inactive and have random unusable credentials. They appear in admin directories as QA records but cannot sign in. Existing administrators and students are not changed.

Run from the repository root:

```powershell
sqlcmd -S localhost -E -b -f 65001 -i tests/fixtures/SeedAnalyticsVerification.sql
```

The seed runs in one transaction. Re-running retains the existing marked event without overwriting it. The ID may differ on another installation; use the ID printed by the seed rather than 23.

When finished, remove this fixture with:

```powershell
sqlcmd -S localhost -E -b -f 65001 -i tests/fixtures/CleanupAnalyticsVerification.sql
```

Cleanup checks the event marker, all 100 QA student/account identities, and references from other events before deleting. It refuses cleanup if the fixture has been repurposed or identities changed. It leaves the existing administrator intact.
