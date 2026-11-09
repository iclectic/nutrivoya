-- Nutrivoya: user-contributed product submissions + review workflow.
-- Values are never treated as authoritative until status = 'verified'.
-- Reviewers change status only — they must not invent missing nutrition.
create table if not exists public.product_submissions (
  id text primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null,
  status text not null check (
    status in (
      'draft',
      'pendingReview',
      'publishedLocally',
      'verified',
      'rejected',
      'withdrawn'
    )
  ),
  brand text,
  barcode text,
  cuisine text,
  default_serving_grams double precision,
  portion_name text,
  energy_kcal_per_100g double precision,
  protein_g_per_100g double precision,
  carbohydrate_g_per_100g double precision,
  fat_g_per_100g double precision,
  fibre_g_per_100g double precision,
  notes text,
  review_notes text,
  reviewed_at timestamptz,
  reviewed_by text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists product_submissions_user_updated_idx
  on public.product_submissions (user_id, updated_at);
create index if not exists product_submissions_status_idx
  on public.product_submissions (status);

alter table public.product_submissions enable row level security;

create policy "product_submissions_select_own" on public.product_submissions
  for select using (auth.uid() = user_id);
create policy "product_submissions_insert_own" on public.product_submissions
  for insert with check (auth.uid() = user_id);
create policy "product_submissions_update_own" on public.product_submissions
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "product_submissions_delete_own" on public.product_submissions
  for delete using (auth.uid() = user_id);
