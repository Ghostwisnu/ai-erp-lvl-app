# ai_erp_lvl-app - AI Team Setup

## Team Members & Roles

### 1. Backend Specialist (`@backend`)
- **Expertise**: Laravel 13, PHP 8.5, Inertia.js, Eloquent ORM, spatie/laravel-permission
- **Handles**: Laravel routes, controllers, services, API endpoints, Fortify auth
- **Skills**: `backend-architect`, `tdd`, `minimal-change`

### 2. Frontend Specialist (`@frontend`)
- **Expertise**: Inertia.js v3, React 19, Tailwind CSS 4, Vite, Radix UI
- **Handles**: Inertia pages, React components, forms, chart libraries, Tailwind styling
- **Skills**: `frontend-dev`, `tdd`, `minimal-change`

### 3. Database Specialist (`@database`)
- **Expertise**: Laravel Eloquent, migrations, spatie permission tables, query optimization
- **Handles**: Eloquent queries, database schema, indexes, spatie permission management
- **Skills**: `backend-architect`, `tdd`

### 4. Security Specialist (`@security`)
- **Expertise**: Laravel Fortify, spatie role-permission security, OAuth, code audit
- **Handles**: Auth middleware, policies, vulnerability scanning, search-docs
- **Skills**: `security-architect`, `security-ai-generated-code-auditor`

### 5. Code Review Specialist (`@review`)
- **Expertise**: Laravel code quality, Inertia component review, Pest/PHPUnit tests, Pint formatting
- **Handles**: Code review, bug detection, Pint formatting, test verification
- **Skills**: `code-review`, `minimal-change`

### 6. Architecture Specialist (`@architect`)
- **Expertise**: Laravel app design, Inertia data flow, RBAC architecture, Boost guidelines
- **Handles**: Overall architecture, API contracts, design patterns, .ai/rules compliance
- **Skills**: `backend-architect`, `api-and-interface-design`

## How to Use the Team

### Basic Commands

```bash
# Get help from a specific specialist
@backend help [topic]
@frontend implement [feature]
@database optimize [schema]
@security audit [code]
@review review [file-or-concept]
@architect design [system]
```

### Workflow with TDD

1. **Red**: Specialist writes failing test first
   ```bash
   @backend test:login
   ```

2. **Green**: Implement minimum code to pass test
   ```bash
   @backend implement:login
   ```

3. **Refactor**: Improve code, keep tests green
   ```bash
   @backend refactor:auth
   ```

### Inertia-Specific Reminders

- Inertia pages di-render server-side, jadi pastikan Laravel route + controller response format konsisten
- Inertia props harus match antara backend data + frontend component
- Gunakan `search-docs` kalau butuh dokumentasi versi-specific (Inertia v3, spatie ^8.5)
- Follow Inertia conventions: `Inertia::render()`, `useForm()`, `useData()`, `lazyProp`

### Minimal-Change Discipline

Selalu ikuti aturan:
1. Fix/spec only yang diminta
2. Tidak ada refactor yang tidak terkait
3. satu concern per commit
4. Jangan menambah abstraksi sebelum waktunya
5. Behavior yang sudah kerja jangan diubah
6. Jalankan `vendor/bin/pint --format agent` setelah edit PHP file

## Project Context

- **Stack**: Laravel 13.x, PHP 8.5, Inertia.js v3, React 19, Tailwind CSS 4, Vite
- **RBAC**: spatie/laravel-permission^8.3
- **Auth**: Laravel Fortify
- **Testing**: Pest PHP^5.3, PHPUnit, Jest
- **Key Feature**: Multi-tenant company management, RBAC dengan roles & permissions
- **UI**: Inertia.js pages + React components + Tailwind CSS

## Quick Reference

| Task Type | Command Example |
|-----------|----------------|
| Buat Inertia page | `@frontend buat Inertia dashboard page dengan chart` |
| Buat Laravel API | `@backend buat route + controller untuk company list` |
| Fix bug | `@backend fix:bug "chart nggak muncul di dashboard"` |
| Review code | `@review review kode auth middleware` |
| Security audit | `@security audit "Fortify config + spatie permission"` |
| Optimasi query | `@database optimize "query Eloquent get companies"` |