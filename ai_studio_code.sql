-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Users Table
create table users (
  id uuid primary key default uuid_generate_v4(),
  email text unique not null,
  instagram_username text not null,
  score int default 3,
  is_admin boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Campaigns Table
create table campaigns (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references users(id),
  target_username text not null,
  target_amount int not null,
  fulfilled_amount int default 0,
  active boolean default true,
  is_system boolean default false,
  current_followers int default 0,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Follows Table (To track who followed whom)
create table follows (
  id uuid primary key default uuid_generate_v4(),
  follower_id uuid references users(id),
  campaign_id uuid references campaigns(id),
  created_at timestamp with time zone default timezone('utc'::text, now()),
  unique(follower_id, campaign_id)
);

-- Transactions Table
create table transactions (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references users(id),
  user_email text not null,
  amount int not null,
  cost numeric not null,
  status text default 'pending', -- 'pending', 'completed'
  payment_method text,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Packages Table
create table packages (
  id uuid primary key default uuid_generate_v4(),
  amount int not null,
  cost numeric not null,
  label text not null,
  is_popular boolean default false
);

-- Payment Methods Table
create table payment_methods (
  id uuid primary key default uuid_generate_v4(),
  type text not null,
  value text not null,
  label text not null
);

-- DISABLE RLS (For simple setup - makes public access easier for this MVP)
-- WARNING: In a production app with sensitive data, you must configure policies instead.
alter table users enable row level security;
alter table campaigns enable row level security;
alter table follows enable row level security;
alter table transactions enable row level security;
alter table packages enable row level security;
alter table payment_methods enable row level security;

create policy "Public Access Users" on users for all using (true);
create policy "Public Access Campaigns" on campaigns for all using (true);
create policy "Public Access Follows" on follows for all using (true);
create policy "Public Access Transactions" on transactions for all using (true);
create policy "Public Access Packages" on packages for all using (true);
create policy "Public Access Payment Methods" on payment_methods for all using (true);