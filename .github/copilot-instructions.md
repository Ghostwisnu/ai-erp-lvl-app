# Copilot instructions for ai-erp-lvl-app

## Project overview

This repository is a Laravel 13 application with a React + Inertia frontend built via Vite.

- Backend: `app/`, `config/`, `database/`, `routes/`, `bootstrap/`
- Frontend: `resources/js/` with pages, layouts, components, hooks, and UI primitives
- Build integration: `vite.config.ts` and Laravel Vite plugin connect the React app to Laravel
- Auth and permissions: Fortify configuration in `app/Providers/FortifyServiceProvider.php`, custom registration logic in `app/Actions/Fortify/CreateNewUser.php`, and user role logic in `app/Models/User.php`
- Route structure: `routes/web.php` defines the main admin, production, dashboard, and settings sections; `routes/settings.php` is used for settings pages

A major part of the app is a permission-driven admin system with `permission:manage-*` middleware on route groups. When changing auth, team behavior, or route access, review both the backend route definitions and the Inertia page that consumes them.

## Build, test, and lint commands

Use the project scripts defined in `composer.json` and `package.json`:

```bash
# Install dependencies
composer install
npm install

# Local development
composer run dev

# Frontend checks
npm run check
npm run types:check
npm run build

# PHP linting
composer run lint
composer run lint:check

# Full validation
composer test
# or
php artisan test

# Single test example
php artisan test tests/Feature/Auth/RegistrationTest.php --filter='new users can register'
./vendor/bin/pest tests/Feature/Auth/AuthenticationTest.php --filter='users can authenticate using the login screen'

# CI-style validation shorthand
composer run ci:check
```

Prefer the single-test form for focused work instead of running the entire suite.

## Key conventions and repo-specific patterns

- Route names are part of the application contract. Prefer `route(...)` in tests and application logic rather than hard-coded URLs when interacting with auth or admin pages.
- This repo mixes Laravel server-side logic and Inertia React UI. A feature change often requires both a server-side route/provider change and a matching frontend page or prop update.
- Team-aware auth redirects are customized. Check `app/Http/Responses/RegisterResponse.php` and the Fortify service provider before changing registration or login redirect behavior.
- Permission checks are route-based. New admin or produksi endpoints should follow the existing pattern in `routes/web.php` and include the matching `permission:*` guard.
- Tests use factories (`User::factory()`, `Team::factory()`, etc.) and named routes. Keep test fixture values unique when the same type of entity is created across multiple tests.
- The dashboard route intentionally redirects to `/settings/profile`, so assertions should expect that redirect unless the feature under test specifically overrides it.
- The frontend uses a Vite React setup, so UI changes should still be checked with the relevant TypeScript/Vite validation and, when auth or routing behavior changes, with focused PHP feature tests.

## Working style

Keep changes scoped to the affected auth, route, permission, or UI slice. The codebase is organized by feature area (`Admin`, `Produksi`, `Settings`, and auth), so follow that structure when adding or updating files.
