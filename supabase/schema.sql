-- Personal Command Center private cloud-sync foundation
-- Run only in a dedicated Supabase project for this app.
-- Access is limited to authenticated users reading/writing rows they own.
-- Disable public sign-ups in Supabase Auth and create/invite only your own account.

create extension if not exists pgcrypto;

create table if not exists public.pcc_shortcuts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (char_length(trim(name)) between 1 and 40),
  url text not null check (url ~* '^https?://'),
  category text not null default 'Personal',
  icon text,
  tone text,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.pcc_tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  task_text text not null check (char_length(trim(task_text)) between 1 and 180),
  is_done boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.pcc_notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null default 'Quick note' check (char_length(title) <= 120),
  content text not null default '' check (char_length(content) <= 10000),
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.pcc_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  accent text not null default 'gold' check (accent in ('gold', 'green', 'blue')),
  preferences jsonb not null default '{}'::jsonb check (jsonb_typeof(preferences) = 'object'),
  updated_at timestamptz not null default now()
);

create index if not exists pcc_shortcuts_user_sort_idx on public.pcc_shortcuts(user_id, sort_order);
create index if not exists pcc_tasks_user_sort_idx on public.pcc_tasks(user_id, sort_order);
create index if not exists pcc_notes_user_sort_idx on public.pcc_notes(user_id, sort_order);

create or replace function public.pcc_set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists pcc_shortcuts_updated_at on public.pcc_shortcuts;
create trigger pcc_shortcuts_updated_at before update on public.pcc_shortcuts
for each row execute function public.pcc_set_updated_at();

drop trigger if exists pcc_tasks_updated_at on public.pcc_tasks;
create trigger pcc_tasks_updated_at before update on public.pcc_tasks
for each row execute function public.pcc_set_updated_at();

drop trigger if exists pcc_notes_updated_at on public.pcc_notes;
create trigger pcc_notes_updated_at before update on public.pcc_notes
for each row execute function public.pcc_set_updated_at();

drop trigger if exists pcc_settings_updated_at on public.pcc_settings;
create trigger pcc_settings_updated_at before update on public.pcc_settings
for each row execute function public.pcc_set_updated_at();

alter table public.pcc_shortcuts enable row level security;
alter table public.pcc_tasks enable row level security;
alter table public.pcc_notes enable row level security;
alter table public.pcc_settings enable row level security;

drop policy if exists "Users manage their own shortcuts" on public.pcc_shortcuts;
create policy "Users manage their own shortcuts" on public.pcc_shortcuts
for all to authenticated using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "Users manage their own tasks" on public.pcc_tasks;
create policy "Users manage their own tasks" on public.pcc_tasks
for all to authenticated using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "Users manage their own notes" on public.pcc_notes;
create policy "Users manage their own notes" on public.pcc_notes
for all to authenticated using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "Users manage their own settings" on public.pcc_settings;
create policy "Users manage their own settings" on public.pcc_settings
for all to authenticated using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

revoke all on public.pcc_shortcuts, public.pcc_tasks, public.pcc_notes, public.pcc_settings from public, anon;
grant select, insert, update, delete on public.pcc_shortcuts, public.pcc_tasks, public.pcc_notes, public.pcc_settings to authenticated;

-- Do not put a Supabase service-role key in the browser or repository.
-- The app must use only the project URL and publishable/anon key, protected by RLS.
