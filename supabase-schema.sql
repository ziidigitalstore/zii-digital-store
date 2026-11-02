-- Zii Digital Store database setup
-- Run this entire file in Supabase Dashboard -> SQL Editor -> New query.
create extension if not exists pgcrypto;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null default 'Other',
  price numeric(12,2) not null default 0 check (price >= 0),
  description text not null default '',
  image_url text,
  download_url text,
  published boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  customer_name text not null,
  contact text not null,
  payment_method text not null,
  payment_reference text,
  items jsonb not null,
  total numeric(12,2) not null check (total >= 0),
  status text not null default 'pending' check (status in ('pending','paid','delivered','cancelled')),
  created_at timestamptz not null default now()
);

create table if not exists public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create or replace function public.is_store_admin()
returns boolean language sql stable security definer
set search_path = public
as $$ select exists (select 1 from public.admins where user_id = auth.uid()); $$;

alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.admins enable row level security;

 drop policy if exists "Public can view published products" on public.products;
create policy "Public can view published products" on public.products for select using (published = true or public.is_store_admin());
drop policy if exists "Admins manage products" on public.products;
create policy "Admins manage products" on public.products for all to authenticated using (public.is_store_admin()) with check (public.is_store_admin());

drop policy if exists "Customers can place orders" on public.orders;
create policy "Customers can place orders" on public.orders for insert to anon, authenticated with check (
  char_length(customer_name) between 1 and 100 and char_length(contact) between 3 and 150 and
  payment_method in ('JazzCash','Easypaisa','International - contact me') and jsonb_typeof(items) = 'array' and jsonb_array_length(items) between 1 and 30
);
drop policy if exists "Admins view orders" on public.orders;
create policy "Admins view orders" on public.orders for select to authenticated using (public.is_store_admin());
drop policy if exists "Admins update orders" on public.orders;
create policy "Admins update orders" on public.orders for update to authenticated using (public.is_store_admin()) with check (public.is_store_admin());

drop policy if exists "Admins can view own admin row" on public.admins;
create policy "Admins can view own admin row" on public.admins for select to authenticated using (user_id = auth.uid());

-- IMPORTANT: After creating your admin user in Authentication -> Users,
-- copy that user's UUID and run this separately:
-- insert into public.admins (user_id) values ('PASTE-ADMIN-USER-UUID-HERE');

-- Optional sample product (unpublished until you switch published to true):
-- insert into public.products (title, category, price, description, published)
-- values ('Luxury Gold Wallpaper Pack', 'Wallpapers', 499, 'A premium collection of elegant gold wallpapers.', true);
