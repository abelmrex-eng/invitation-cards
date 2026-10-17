-- Run once in Supabase: SQL Editor > New query > paste all of this > Run.
-- Safe to run again. Anyone can sign up; each person can only see, edit and delete their own invitations.
-- Guests with a link can read published invitations only. Passwords are kept by Supabase Auth (hashed), not here.

create table if not exists public.invitations (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  details jsonb not null,
  published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists invitations_owner_idx on public.invitations(owner_id);
alter table public.invitations enable row level security;

drop policy if exists "Public can read published invitations" on public.invitations;
drop policy if exists "Hosts create their own invitations" on public.invitations;
drop policy if exists "Hosts update their own invitations" on public.invitations;
drop policy if exists "Hosts delete their own invitations" on public.invitations;
create policy "Public can read published invitations" on public.invitations for select using (published = true or auth.uid() = owner_id);
create policy "Hosts create their own invitations" on public.invitations for insert to authenticated with check (auth.uid() = owner_id);
create policy "Hosts update their own invitations" on public.invitations for update to authenticated using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
create policy "Hosts delete their own invitations" on public.invitations for delete to authenticated using (auth.uid() = owner_id);

-- Keep updated_at current on every edit
create or replace function public.touch_invitation() returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;
drop trigger if exists invitations_touch on public.invitations;
create trigger invitations_touch before update on public.invitations for each row execute function public.touch_invitation();

-- Pictures people upload for their cards
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values
('invitation-images','invitation-images',true,5242880,array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;

drop policy if exists "Host image uploads" on storage.objects;
drop policy if exists "Public invitation images" on storage.objects;
drop policy if exists "Host image deletes" on storage.objects;
create policy "Host image uploads" on storage.objects for insert to authenticated with check (bucket_id='invitation-images' and (storage.foldername(name))[1]=auth.uid()::text);
create policy "Public invitation images" on storage.objects for select using (bucket_id='invitation-images');
create policy "Host image deletes" on storage.objects for delete to authenticated using (bucket_id='invitation-images' and (storage.foldername(name))[1]=auth.uid()::text);

-- Visitors can no longer upload their own songs. Songs come from the site's music folder.
drop policy if exists "Host audio uploads" on storage.objects;
