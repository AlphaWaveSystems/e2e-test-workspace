# E2E Test Workspace

Multi-stack test workspace for the AI CMS Project Board platform.

## Structure

```
mobile/       Flutter mobile app (iOS + Android)
frontend/     React web frontend (Vite + TypeScript)
backend/      Go REST API backend
docs/         Documentation
.github/      CI/CD workflows
```

## Stack

| Layer | Technology | Directory |
|-------|-----------|-----------|
| Mobile | Flutter 3 + Dart | `mobile/` |
| Frontend | React 18 + TypeScript + Vite | `frontend/` |
| Backend | Go 1.22 + Chi router + PostgreSQL | `backend/` |

## Development

```bash
# Backend
cd backend && go run ./cmd/server

# Frontend
cd frontend && npm run dev

# Mobile
cd mobile && flutter run
```

## JIRA

- Project: ETP
- Board: https://alphawavesystems.atlassian.net/jira/servicedesk/projects/ETP/queues/custom/98
