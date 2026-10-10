# Migrating the university event system to React

This is a learning guide and proposed architecture. No React project or API endpoints have been created by this document. Keep the current Web Forms application running at http://localhost:8080 while learning and migrating separately.

## 1. Understand the architecture

The existing app combines server-rendered ASPX pages, C# code-behind, repositories, and SQL Server stored procedures.

The proposed app has three parts:

```text
React + TypeScript in the browser
       | HTTP requests / JSON responses
ASP.NET Core API in C#
       | parameterized stored procedure calls
SQL Server
```

React replaces the user interface. ASP.NET Core replaces the Web Forms request and authentication infrastructure. SQL Server can remain. React must never receive a database connection string or connect directly to SQL Server.

For this project, keeping C# on the server reduces the amount of logic to rewrite. A Node.js server is possible, but it would also require rewriting your C# backend. React does not require Node.js as its production backend; Node.js is used here for frontend build tooling.

## 2. Map the existing code to the new app

| Existing code | New responsibility |
| --- | --- |
| Frontend/User/Dashboard.aspx | StudentDashboard.tsx, EventCard.tsx, RegisteredEventCard.tsx |
| Dashboard.aspx.cs data loading | Student event API and service |
| EventRegistration.aspx and code-behind | Registration page and booking endpoint |
| EventPass.aspx | Pass page and pass endpoint that verifies ownership |
| Frontend/Admin/CreateEvent.aspx | React wizard with one shared frame and step components |
| CreateEvent.aspx.cs | Event creation service and admin endpoint |
| AttendanceScanner.aspx WebMethods | Attendance lookup and check-in endpoints |
| Admin.Master | AdminLayout.tsx with navigation and route content |
| ASP.NET ViewState and hidden fields | React component state for the unsaved draft |
| SessionHelper/AdminPage/StudentPage | Server authentication and authorization policies |
| Backend/Models | Ported domain models and explicit request/response DTOs |
| Backend/Repository | Ported data-access services |
| Backend/Database/StoredProcedures | Existing database operations, reviewed and tested |

There is no automatic conversion of ASPX controls into React components. Rebuild the markup, remove runat="server" and ASP.NET controls, and adapt existing CSS selectively. Replace direct DOM updates with state-driven rendering.

Do not copy code-behind into React. It contains operations that belong on the server.

## 3. Create separate frontend and backend projects

Install a supported Node.js release and .NET SDK. Use a separate workspace or migration directory so these commands do not overwrite the existing application.

```powershell
mkdir university-events-modern
cd university-events-modern
dotnet new webapi --use-controllers -n UniversityEvents.Api
npm create vite@latest university-events-web -- --template react-ts
cd university-events-web
npm install
npm run dev
```

In a second terminal, in the backend project:

```powershell
dotnet run --urls http://localhost:5100
```

The React dev server normally uses port 5173; use the actual URL it prints. Port 8080 stays assigned to the existing app. Creating these projects alone does not connect them to your database or implement your existing features.

React's official setup: https://react.dev/learn/build-a-react-app-from-scratch

Microsoft's API tutorial: https://learn.microsoft.com/en-us/aspnet/core/tutorials/first-web-api?view=aspnetcore-10.0

## 4. Learn one request from beginning to end

Start with a read-only event list. The sequence is:

1. The student opens the React dashboard.
2. React requests GET /api/student/events/available.
3. The API authenticates the student and obtains their profile from the server.
4. The service applies campus, college, program, and registration rules.
5. The repository calls SQL Server with parameters.
6. The API sends JSON containing only the fields the page needs.
7. React renders EventCard components.

Example proposed response:

```json
[
  {
    "eventId": 8,
    "title": "Example campus workshop",
    "registrationState": "Open",
    "remainingCapacity": 12
  }
]
```

This is illustrative data. These API routes do not yet exist in the current system.

For your two student tabs, propose separate endpoints:

```text
GET /api/student/events/available
GET /api/student/registrations
```

Exclude events with a current non-cancelled pass from the available endpoint. After booking or cancellation, refresh both lists. Compute Open/Soon/Closed on the server using a consistent clock and policy.

## 5. Connect the React development server to the API

In the generated vite.config.ts, configure a development proxy:

```typescript
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      '/api': 'http://localhost:5100',
    },
  },
});
```

The browser calls /api on the React origin; Vite forwards it to the API. This proxy is for development. Configure same-origin hosting or a reverse proxy separately for deployment.

A small React learning example, after the available-events endpoint exists:

```tsx
import { useEffect, useState } from 'react';

type CampusEvent = {
  eventId: number;
  title: string;
  registrationState: 'Open' | 'Soon' | 'Closed';
  remainingCapacity: number;
};

export default function AvailableEvents() {
  const [events, setEvents] = useState<CampusEvent[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const controller = new AbortController();

    async function load() {
      try {
        const response = await fetch('/api/student/events/available', {
          credentials: 'include',
          signal: controller.signal,
        });
        if (!response.ok) {
          throw new Error(response.status === 401
            ? 'Please sign in to view events.'
            : 'Events could not be loaded. Please try again.');
        }
        const data: CampusEvent[] = await response.json();
        if (!controller.signal.aborted) setEvents(data);
      } catch (err) {
        if (!controller.signal.aborted) {
          setError(err instanceof Error ? err.message : 'Events could not be loaded.');
        }
      } finally {
        if (!controller.signal.aborted) setLoading(false);
      }
    }

    void load();
    return () => controller.abort();
  }, []);

  if (loading) return <p role="status">Loading events...</p>;
  if (error) return <p role="alert">{error}</p>;
  if (events.length === 0) return <p>No available events.</p>;

  return (
    <div className="events-grid">
      {events.map(event => (
        <article key={event.eventId}
          className={event.registrationState === 'Closed' ? 'event-card closed' : 'event-card'}>
          <h2>{event.title}</h2>
          <p>{event.registrationState}</p>
          <p>{event.remainingCapacity} seats remaining</p>
        </article>
      ))}
    </div>
  );
}
```

Here, useState stores UI data, useEffect loads it, and map creates a component for each event. This is a learning example; a data-fetching library can manage refreshes and caching once the basic flow is understood.

## 6. Port the backend deliberately

The existing app targets .NET Framework 4.7.2. A new ASP.NET Core project cannot simply run its Web Forms pages or System.Web helpers.

Port repositories into the new API, replace System.Web dependencies, use ASP.NET Core configuration and dependency injection, and use a supported SQL client such as Microsoft.Data.SqlClient. Keep stored procedures initially to limit simultaneous changes. Test against a separate database copy before enabling writes.

Return explicit DTOs. Never serialize UserModel directly because it contains password fields. Do not return password hashes or salts.

Proposed endpoints beyond the dashboard:

```text
POST /api/auth/login
POST /api/auth/logout
GET  /api/auth/me
POST /api/student/events/{eventId}/registrations
POST /api/student/registrations/{registrationId}/cancel
GET  /api/student/registrations/{registrationId}/pass
POST /api/admin/events
PUT  /api/admin/events/{eventId}
POST /api/admin/events/{eventId}/attendance/check-in
GET  /api/admin/events/{eventId}/analytics
```

Derive student identity and administrator permissions from the authenticated server principal. Never trust a studentId or role sent by the React app as proof of identity. Keep duplicate, eligibility, capacity, cancellation, and event-context validation in the API/database transactions.

For a browser app, same-origin HttpOnly cookie authentication is a useful starting point. Include CSRF protection for state-changing operations and revalidate deactivated accounts. Existing Web Forms sessions do not automatically authenticate the new API; implement and test a new login flow. Review compatibility of existing password hashes before changing password storage.

## 7. Migrate in this order

1. Learn components, props, state, forms, effects, and fetch using a small event-card exercise.
2. Build the new API connection and read-only event endpoint against a test database.
3. Implement authentication and server-side authorization.
4. Rebuild the student dashboard and registered-events tab.
5. Add registration, cancellation, and pass viewing, checking ownership and concurrent bookings.
6. Rebuild the admin layout, event wizard, sponsor management, and banner upload.
7. Move attendance scanning and analytics, keeping event context and export behavior.
8. Verify mobile layouts, keyboard access, errors, and feature parity; then switch deployment traffic.

The first milestone is small: sign in as a test student and display real eligible events from the API in React. Keep the old application available until the new workflow is verified.
