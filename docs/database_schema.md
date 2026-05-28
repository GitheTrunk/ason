# Database Schema for ASON Project

This document describes the database schema used by the application. Each section includes the table DDL and a concise explanation of the purpose and important columns.

---

## emergency_services

Purpose: Stores information about emergency service providers and resources.

DDL:
```
create table emergency_services (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  type text not null,
  phone text,
  address text,
  description text,
  open_hours text,
  latitude double precision,
  longitude double precision,
  distance_km numeric,
  rating numeric default 0,
  image_url text,
  created_at timestamp default now()
);
```

Key columns:
- `id`: Primary key (UUID).
- `name`: Service name.
- `type`: Service category (see Types below).
- `latitude`/`longitude`: Geolocation for distance calculations.
- `rating`: Aggregated rating score.

Allowed `type` values:
- `hospital`, `police`, `fire`, `ambulance`, `women_help`, `disaster_relief`

---

## reviews

Purpose: User-submitted reviews for services.

DDL:
```
create table reviews (
  id uuid primary key default gen_random_uuid(),
  service_id uuid references emergency_services(id) on delete cascade,
  username text,
  rating integer,
  comment text,
  created_at timestamp default now()
);
```

Key columns:
- `service_id`: Foreign key to `emergency_services`.
- `rating`: Integer rating provided by the user.

---

## gallery

Purpose: Media items associated with services (images, videos, etc.).

DDL:
```
create table gallery (
  id uuid primary key default gen_random_uuid(),
  service_id uuid references emergency_services(id) on delete cascade,
  image_url text,
  media_type text,
  created_at timestamp default now()
);
```

Key columns:
- `media_type`: e.g., `image`, `video`.

---

## favorites

Purpose: Tracks services marked as favorites by users.

DDL:
```
create table favorites (
  id uuid primary key default gen_random_uuid(),
  service_id uuid references emergency_services(id) on delete cascade,
  created_at timestamp default now()
);
```

Note: Consider adding a `user_id` column if favorites are user-scoped.

---

## bookings

Purpose: Appointment or booking records for services that support reservations.

DDL:
```
create table bookings (
  id uuid primary key default gen_random_uuid(),
  service_id uuid references emergency_services(id) on delete cascade,
  booking_date date,
  booking_time text,
  status text,
  created_at timestamp default now()
);
```

Status values:
- `pending`, `confirmed`, `cancelled`

---

## promotions

Purpose: Promotional campaigns and coupons.

DDL:
```
create table promotions (
  id uuid primary key default gen_random_uuid(),
  title text,
  description text,
  coupon_code text,
  expiry_date date,
  image_url text,
  created_at timestamp default now()
);
```

---

## personal_contacts

Purpose: User-maintained emergency contacts and related info.

DDL:
```
create table personal_contacts (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  relationship text,
  phone text,
  blood_group text,
  allergies text,
  created_at timestamp default now()
);
```

---

## first_aid_guides

Purpose: First-aid instructions and guides organized by topic.

DDL:
```
create table first_aid_guides (
  id uuid primary key default gen_random_uuid(),
  title text,
  category text,
  steps text,
  image_url text,
  created_at timestamp default now()
);
```

Suggested categories:
- `CPR`, `Burns`, `Bleeding`, `Snake Bite`, `Choking`

---

## chat_messages

Purpose: Stores chat or system messages exchanged in the app.

DDL:
```
create table chat_messages (
  id uuid primary key default gen_random_uuid(),
  sender text,
  message text,
  created_at timestamp default now()
);
```

---

Notes & suggestions:
- Add `created_by` / `user_id` fields where data should be associated with users.
- Consider standardizing enumerated types (e.g., `type`, `status`, `media_type`) using database enums for validation.
- Add indexes on foreign keys and geolocation columns (`latitude`, `longitude`) to improve lookup performance.

