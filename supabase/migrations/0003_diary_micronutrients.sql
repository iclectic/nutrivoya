-- Optional micronutrients on diary_entries (null = unavailable).
alter table public.diary_entries
  add column if not exists sodium_mg double precision,
  add column if not exists iron_mg double precision,
  add column if not exists calcium_mg double precision,
  add column if not exists potassium_mg double precision,
  add column if not exists vitamin_c_mg double precision;
