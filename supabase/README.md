# Private cloud sync setup

This is the database foundation for Personal Command Center. It is intentionally separate from the MarrowVeil employee database.

## Before connecting the app

1. Create a **new Supabase project** specifically for Personal Command Center. Do not reuse the employee portal project.
2. In Supabase SQL Editor, run `schema.sql` from this folder.
3. In Supabase Authentication settings, turn off public sign-ups. Create/invite only your own account. Use a strong, unique password and enable MFA if available.
4. In the project's API settings, copy the project URL and the **publishable key** (or legacy anon key). These keys are designed to be used by a browser app; the database's RLS policies are the security boundary.
5. **Never use or commit the service-role/secret key** in frontend code, HTML, GitHub, or a browser. It bypasses RLS.
6. Verify RLS is enabled for all four `pcc_*` tables and test access with a signed-in user before storing real notes.

## Tables

- `pcc_shortcuts`: per-user launch links and ordering
- `pcc_tasks`: per-user tasks and completion state
- `pcc_notes`: per-user notes
- `pcc_settings`: per-user accent and preferences

Every table has a `user_id` foreign key to `auth.users`. RLS allows authenticated users to access only rows whose `user_id` equals their own auth UID. Anonymous access is revoked.

## Important deployment note

A static GitHub Pages site is public unless you have a hosting/access-control arrangement that restricts it. A private repository does not, by itself, make a deployed website private. Also, a publishable Supabase key is not a secret: security depends on correct RLS, disabled public registration, and safe frontend behavior.

## Smoke tests after app integration

- Signed-out visitor cannot read or change rows.
- Signed-in account can create, read, update, and delete its own rows.
- A second test account cannot read or change the first account's rows.
- Sign-out clears private app state from the screen.
- Refresh and another device restore only the signed-in user's data.
- Network failures do not silently overwrite or delete server data.
