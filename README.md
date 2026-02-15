# 🏥 MedRec — Medical Records Logger

A comprehensive medical records management system with AI-powered document processing, built with **Parse Server + PostgreSQL** backend, **Angular 19** admin dashboard, and **Android** mobile app.

---

## 🏗 Architecture

```
┌─────────────────────────────────────────────────┐
│                   MedRec                        │
├────────────┬───────────────┬────────────────────┤
│  Backend   │  Admin UI     │  Android App       │
│  (Node.js) │  (Angular 19) │  (Kotlin)          │
├────────────┼───────────────┼────────────────────┤
│ Parse      │ Parse JS SDK  │ Parse Android SDK  │
│ Server     │ Chart.js      │ CameraX            │
│ Express    │ Material Icons│ Material 3          │
│ PostgreSQL │ Dark Theme    │ Navigation Component│
│ Cloud Code │               │ Coroutines         │
└────────────┴───────────────┴────────────────────┘
```

## 📁 Project Structure

```
cobalt-viking/
├── backend/              # Parse Server + PostgreSQL
│   ├── index.js          # Express + Parse Server entry
│   ├── cloud/
│   │   ├── main.js       # Cloud Code entry
│   │   ├── triggers/     # beforeSave/afterSave hooks
│   │   │   ├── medicalRecord.js
│   │   │   ├── extractedData.js
│   │   │   └── auditLog.js
│   │   └── functions/    # Cloud Functions
│   │       ├── records.js
│   │       ├── analytics.js
│   │       ├── ocr.js
│   │       └── users.js
│   └── migrations/
│       ├── run.js        # Schema migrations
│       └── seed.js       # Demo data seeder
│
├── admin-ui/             # Angular 19 Admin Dashboard
│   └── src/app/
│       ├── components/
│       │   ├── dashboard/
│       │   ├── login/
│       │   ├── users/
│       │   ├── records/
│       │   ├── audit-log/
│       │   └── shared/   # Sidebar, Header
│       ├── services/     # ParseService
│       ├── guards/       # AuthGuard
│       └── models/       # TypeScript interfaces
│
└── android/              # Android Mobile App
    └── app/src/main/
        ├── java/com/medrec/app/
        │   ├── MedRecApp.kt
        │   ├── data/
        │   │   ├── model/Models.kt
        │   │   └── repository/
        │   └── ui/
        │       ├── login/
        │       ├── dashboard/
        │       ├── records/
        │       ├── profile/
        │       └── scan/      # CameraX Smart Scan
        └── res/
            ├── layout/
            ├── values/
            ├── navigation/
            ├── menu/
            └── drawable/
```

## 🚀 Getting Started



### Prerequisites
- **Node.js** ≥ 18
- **PostgreSQL** ≥ 14
- **Angular CLI** ≥ 19
- **Android Studio** (for mobile app)

### 1. Backend Setup

```bash
cd backend
cp .env.example .env    # Configure your database & keys
npm install
npm run migrate          # Create indexes & schema
npm run seed             # Populate demo data
npm run dev              # Start with nodemon
```

Backend runs at `http://localhost:1337`
- Parse API: `http://localhost:1337/parse`
- Dashboard: `http://localhost:1337/dashboard`

### 2. Admin UI Setup

```bash
cd admin-ui
npm install
ng serve                 # Dev server at http://localhost:4200
```

### 3. Android App

Open `/android` in Android Studio. The app connects to `10.0.2.2:1337` (emulator loopback) by default.

## 📋 Database Schema

| Class | Description |
|-------|-------------|
| `_User` | Patient & admin accounts |
| `MedicalRecord` | Core record (prescription, lab, imaging, general) |
| `Prescription` | Medication details linked to a record |
| `LabResult` | Lab test results with reference ranges |
| `ImagingRecord` | X-ray, MRI, CT scan data |
| `ExtractedData` | AI/OCR extraction results |
| `AuditLog` | Immutable system activity trail |

## 🤖 AI/OCR Pipeline

1. **Upload** — Patient captures/uploads a medical document
2. **Process** — Cloud function sends to Google Document AI / Amazon Textract
3. **Extract** — Structured data is extracted and stored with confidence scores
4. **Review** — Human review step for verification
5. **Approve** — Approved data creates structured records automatically

## 🔐 Security

- Role-based access control (Admin vs Patient)
- Audit logging for all mutations
- Immutable audit trail (no edits/deletes)
- Environment-based secrets
- Helmet.js security headers
- Input validation on all triggers

## 📄 License

MIT
# 🌍 Self-Hosting MedRec

This guide explains how to deploy the MedRec infrastructure on your own Linux server. Since the client applications (Android & Admin UI) rely on **Parse Server**, this guide covers setting up a Parse Server instance backed by PostgreSQL.

## 📋 Prerequisites

- A Linux server (Ubuntu 20.04+ recommended)
- Root or `sudo` access
- A valid domain name (optional, but recommended for SSL)

## ⚡ Quick Start (Automated Installation)

We provide an automated script to set up Parse Server, Dashboard, and PostgreSQL with a dedicated database user.

1.  **Upload the project** to your server.
2.  Run the installation script:

```bash
chmod +x INSTALL.sh
# Must run as root to create users and install packages
sudo ./INSTALL.sh --no-dashboard # Add --no-dashboard to skip dashboard
```

- Install **Parse Server**
- (Optional) Install **Parse Dashboard** if `--no-dashboard` is NOT used
- Configure the database and create a dedicated `medrec_admin` user
- Set up PM2 to keep the server running
- Output your App ID, Master Key, and Server URL (and Dashboard credentials if installed)

---

## 🛠 Manual Installation

### 1. Update System & Install Dependencies

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl gnupg build-essential libssl-dev postgresql postgresql-contrib
```

### 2. Install Node.js (LTS)

```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
```

### 3. Configure PostgreSQL

```bash
sudo -u postgres psql
```

```sql
CREATE DATABASE medrec;
CREATE USER medrec_user WITH ENCRYPTED PASSWORD 'secure_password';
GRANT ALL PRIVILEGES ON DATABASE medrec TO medrec_user;
\q
```

### 4. Install Parse Server (and optionally Dashboard)

We use the global CLI for a standalone setup.
```bash
# Install Parse Server
sudo npm install -g parse-server pm2

# Optional: Install Parse Dashboard if you want a web UI
sudo npm install -g parse-dashboard
```

### 5. Start Server with PM2

Create a configuration file `medrec-config.json`:

```json
{
  "appName": "MedRec",
  "databaseURI": "postgres://medrec_user:secure_password@localhost:5432/medrec",
  "appId": "medrec_app_id",
  "masterKey": "master_key_secure",
  "serverURL": "http://localhost:1337/parse",
  "publicServerURL": "http://<YOUR_IP>:1337/parse",
  "port": 1337,
  "allowClientClassCreation": false
}
```

Start Parse Server:

```bash
pm2 start parse-server --name "medrec-server" -- medrec-config.json
```

### 6. Start Dashboard (Optional)

If you installed the dashboard, create `dashboard-config.json`:

```json
{
  "apps": [
    {
      "serverURL": "http://localhost:1337/parse",
      "appId": "medrec_app_id",
      "masterKey": "master_key_secure",
      "appName": "MedRec"
    }
  ],
  "users": [
    {
      "user": "admin",
      "pass": "password"
    }
  ],
  "trustProxy": 1
}
```

Start Dashboard:

```bash
pm2 start parse-dashboard --name "medrec-dashboard" -- --config dashboard-config.json
```

Save PM2 list:
```bash
pm2 save
pm2 startup
```

## 📱 Connecting the App

1.  Open the MedRec Android App.
2.  If the setup screen appears, enter:
    -   **Server URL**: `http://<YOUR_IP>:1337/parse`
    -   **App ID**: `medrec_app_id` (or what was generated)
    -   **Client Key**: (Leave blank if not configured)
