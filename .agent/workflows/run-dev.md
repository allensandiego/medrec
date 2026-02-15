---
description: How to run the MedRec project locally
---

## Prerequisites
- Node.js >= 18
- PostgreSQL >= 14 (running with a `medrec_db` database created)
- Angular CLI >= 19 (`npm install -g @angular/cli`)
- Android Studio (for the mobile app)

## 1. Start the Backend

```bash
cd /home/allen/.gemini/antigravity/playground/cobalt-viking/backend
```

// turbo
1. Install dependencies:
```bash
npm install
```

2. Make sure PostgreSQL is running and the database exists:
```bash
createdb medrec_db
```

3. Run database migrations:
```bash
npm run migrate
```

4. Seed demo data (optional):
```bash
npm run seed
```

// turbo
5. Start the development server:
```bash
npm run dev
```

The backend will be available at:
- **Parse API**: http://localhost:1337/parse
- **Parse Dashboard**: http://localhost:1337/dashboard (admin/admin123)

## 2. Start the Admin UI

```bash
cd /home/allen/.gemini/antigravity/playground/cobalt-viking/admin-ui
```

// turbo
1. Install dependencies:
```bash
npm install
```

// turbo
2. Start the Angular dev server:
```bash
npx ng serve
```

The admin dashboard will be available at http://localhost:4200

## 3. Android App

1. Open `/home/allen/.gemini/antigravity/playground/cobalt-viking/android` in Android Studio
2. Sync Gradle
3. Run on an emulator or device
4. The app connects to `http://10.0.2.2:1337/parse` (emulator loopback to host)

## Default Login Credentials (after seeding)
- **Username**: admin
- **Password**: admin123456
