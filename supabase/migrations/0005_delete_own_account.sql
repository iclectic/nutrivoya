-- Lets a signed-in user delete their own auth account.
-- Diary rows and product submissions reference auth.users with
-- ON DELETE CASCADE, so those remote rows go with the account.
-- Verified foods already copied into public_food_catalog stay, because
-- that table has no owner column and other people may rely on it.
-- Apply this before account deletion from the app can succeed.

create or replace function public.delete_own_account()
returns void
language plpgsql
security definer
set search_path = public, auth
as $$
begin
  if auth.uid() is null then
    raise exception 'not authenticated';
  end if;

  delete from auth.users where id = auth.uid();
end;
$$;

revoke all on function public.delete_own_account() from public;
grant execute on function public.delete_own_account() to authenticated;
