-- Run this in Supabase Dashboard → SQL Editor
-- Safe to re-run: uses IF NOT EXISTS / DROP IF EXISTS

create table if not exists public.prep_data (
  user_id uuid primary key references auth.users (id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.prep_data enable row level security;

drop policy if exists "prep_data_select_own" on public.prep_data;
drop policy if exists "prep_data_insert_own" on public.prep_data;
drop policy if exists "prep_data_update_own" on public.prep_data;
drop policy if exists "prep_data_delete_own" on public.prep_data;

create policy "prep_data_select_own"
  on public.prep_data for select
  using (auth.uid() = user_id);

create policy "prep_data_insert_own"
  on public.prep_data for insert
  with check (auth.uid() = user_id);

create policy "prep_data_update_own"
  on public.prep_data for update
  using (auth.uid() = user_id);

create policy "prep_data_delete_own"
  on public.prep_data for delete
  using (auth.uid() = user_id);

create index if not exists prep_data_updated_at_idx on public.prep_data (updated_at desc);
