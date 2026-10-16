-- Run in Supabase SQL Editor. Public links can only read published invitations.
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
create policy "Public can read published invitations" on public.invitations for select using (published = true or auth.uid() = owner_id);
create policy "Hosts create their own invitations" on public.invitations for insert to authenticated with check (auth.uid() = owner_id);
create policy "Hosts update their own invitations" on public.invitations for update to authenticated using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
create policy "Hosts delete their own invitations" on public.invitations for delete to authenticated using (auth.uid() = owner_id);
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values
('invitation-images','invitation-images',true,5242880,array['image/jpeg','image/png','image/webp']),
('invitation-audio','invitation-audio',true,10485760,array['audio/mpeg'])
on conflict (id) do nothing;
create policy "Host image uploads" on storage.objects for insert to authenticated with check (bucket_id='invitation-images' and (storage.foldername(name))[1]=auth.uid()::text);
create policy "Host audio uploads" on storage.objects for insert to authenticated with check (bucket_id='invitation-audio' and (storage.foldername(name))[1]=auth.uid()::text);
create policy "Public invitation images" on storage.objects for select using (bucket_id='invitation-images');
create policy "Public invitation audio" on storage.objects for select using (bucket_id='invitation-audio');
