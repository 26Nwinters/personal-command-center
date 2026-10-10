-- Private cloud state for Personal Command Center.
-- Applied to Supabase project: personal-command-center.
-- RLS makes each row visible only to the authenticated owner.
create table if not exists public.pcc_user_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  state jsonb not null default '{}'::jsonb check (jsonb_typeof(state) = 'object'),
  updated_at timestamptz not null default now()
);
alter table public.pcc_user_state enable row level security;
drop policy if exists "Users manage their own app state" on public.pcc_user_state;
create policy "Users manage their own app state"
  on public.pcc_user_state
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
revoke all on public.pcc_user_state from public, anon;
grant select, insert, update, delete on public.pcc_user_state to authenticated;
