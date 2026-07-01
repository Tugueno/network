# Web And Mobile Architecture Plan

## Goal
Make NetWork feel like a polished mobile app while keeping it reliable and usable as a web/PWA app.

## Current Direction
- Keep the existing GetX route and binding structure.
- Keep feature code inside `lib/features/...`.
- Keep shared UI, responsive helpers, and app-level utilities inside `lib/core/...`.
- Support mobile-first screens, tablet split panes, and desktop/web list-detail layouts.

## Responsive Rules
- Compact/mobile: `< 600`
- Split pane/tablet: `>= 720`
- Desktop shell: `>= 1200`

The source of truth is `lib/core/responsive/app_breakpoints.dart`.

## Stage 1 - Foundation
- Centralize responsive breakpoints.
- Add loading, empty, error, and retry states.
- Add pull-to-refresh on request lists.
- Add fallback screens for detail pages when no item is selected.
- Polish PWA metadata for Add to Home Screen.

## Stage 2 - Mobile Quality
- Add haptic feedback to high-confidence actions.
- Add consistent pressed, loading, disabled, and success states.
- Improve keyboard/focus behavior on forms.
- Replace tappable `GestureDetector` usage with semantic buttons where possible.
- Add local cached data for poor-network sessions.

## Stage 3 - Web/PWA Quality
- Support ID-based detail routes such as `/paymentreq/:id`.
- Add an update prompt when the service worker has a new version.
- Bundle app fonts locally instead of relying on runtime Google Fonts fetches.
- Add viewport smoke tests for mobile, tablet, and desktop.

## Stage 4 - Production Readiness
- Replace mock payment and advance repositories with API-backed repositories.
- Complete real auth/session/biometric flows.
- Add integration tests for login, list, detail, approve/reject, and logout flows.
- Verify release builds for Android, iOS, and web.
