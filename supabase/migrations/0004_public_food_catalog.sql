-- Verified user-contributed foods published to a shared catalog.
-- Only rows with reviewer-verified provenance should be inserted by the app.
create table if not exists public.public_food_catalog (
  id text primary key,
  name text not null,
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
  updated_at timestamptz not null default now()
);

alter table public.public_food_catalog enable row level security;

-- Readable by authenticated users; writes go through the signed-in client
-- which only upserts locally verified submissions.
create policy "public_food_catalog_select_auth" on public.public_food_catalog
  for select to authenticated using (true);
create policy "public_food_catalog_upsert_auth" on public.public_food_catalog
  for insert to authenticated with check (true);
create policy "public_food_catalog_update_auth" on public.public_food_catalog
  for update to authenticated using (true) with check (true);
create policy "public_food_catalog_delete_auth" on public.public_food_catalog
  for delete to authenticated using (true);
