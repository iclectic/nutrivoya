-- Nutrivoya: offline-first diary sync table.
-- Rows are created on-device with a client-generated UUID and pushed by
-- DiarySyncService. Deletions are soft (deleted_at) so they propagate.
create table if not exists public.diary_entries (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  food_id text not null,
  food_name text not null,
  food_canonical_name text not null,
  meal_type text not null check (meal_type in ('breakfast','lunch','dinner','snack')),
  grams double precision not null check (grams > 0),
  portion_name text,
  quantity integer not null default 1 check (quantity > 0),
  calories_kcal double precision,
  protein_g double precision,
  carbohydrate_g double precision,
  fat_g double precision,
  fibre_g double precision,
  confidence text not null default 'unknown',
  source_name text,
  logged_at timestamptz not null,
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index if not exists diary_entries_user_updated_idx
  on public.diary_entries (user_id, updated_at);

alter table public.diary_entries enable row level security;

create policy "diary_entries_select_own" on public.diary_entries
  for select using (auth.uid() = user_id);
create policy "diary_entries_insert_own" on public.diary_entries
  for insert with check (auth.uid() = user_id);
create policy "diary_entries_update_own" on public.diary_entries
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "diary_entries_delete_own" on public.diary_entries
  for delete using (auth.uid() = user_id);
