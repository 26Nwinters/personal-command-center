# Personal Command Center

A personal home for shortcuts, tasks, notes, and eventually a built-in desktop browser.

## Current milestone

The first version is a responsive installable web dashboard (PWA) designed for Chromebook, Windows, and macOS browsers.

### Included
- Forest-green, charcoal, and antique-gold dashboard
- Search bar that opens web searches or URLs in a new browser tab
- Starter shortcuts for Milanote, MarrowVeil Studios, GitHub, Supabase, and Google Drive
- Add/remove website shortcuts
- Tasks with completion and delete controls
- Quick notes shared between Home and Notes
- Accent-color settings
- Local JSON backup export
- PWA manifest, app icon, and basic offline shell caching

### Not connected yet
- Private account and cross-device cloud sync
- Weather and calendar integrations
- Desktop Electron shell
- Embedded browser engine with tabs and session handling

## Privacy notes

Tasks, notes, shortcuts, and settings are currently stored in this browser on this device using local storage. They are not synced or encrypted as a vault. Do not put secrets or sensitive personal information into this early prototype. Do not commit credentials, tokens, or exported backup files to the repository.

Keep the repository private for personal development. A private repository alone does not secure a deployed app or its backend.

## Roadmap
1. Review and polish the dashboard on Chromebook.
2. Add authentication and cloud sync with per-user database policies.
3. Add optional weather, calendar, and customizable widgets.
4. Build a desktop shell for Windows and macOS.
5. Prototype the embedded browser with safe navigation and isolated website sessions.
6. Test packaging and behavior on supported platforms.

## Local testing

Serve the project from localhost or deploy it to a static host. Service workers do not work when opening the HTML file directly from the filesystem.
