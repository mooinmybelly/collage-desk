-- Collage Desk: database setup
-- Paste this whole file into Supabase > SQL Editor > New query, then press Run.
-- It is safe to run more than once.

-- 1. Boards: one row per page, owned by the person who made it
create table if not exists public.pages (
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id         text not null,
  position   integer not null default 0,
  data       jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

-- 2. Per-person settings: page order, current page, grain toggle, saved stickers
create table if not exists public.settings (
  user_id    uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- 3. Lock both tables so each person can only see and change their own rows
alter table public.pages    enable row level security;
alter table public.settings enable row level security;

drop policy if exists "own pages" on public.pages;
create policy "own pages" on public.pages
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "own settings" on public.settings;
create policy "own settings" on public.settings
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- 4. Picture storage: a private folder per person (pictures/<their id>/...)
insert into storage.buckets (id, name, public)
values ('pictures', 'pictures', false)
on conflict (id) do nothing;

drop policy if exists "see own pictures" on storage.objects;
create policy "see own pictures" on storage.objects
  for select to authenticated
  using (bucket_id = 'pictures' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "add own pictures" on storage.objects;
create policy "add own pictures" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'pictures' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "remove own pictures" on storage.objects;
create policy "remove own pictures" on storage.objects
  for delete to authenticated
  using (bucket_id = 'pictures' and (storage.foldername(name))[1] = auth.uid()::text);
