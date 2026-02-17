#!/bin/bash

# Configuration
APP_DIR="$(pwd)"
CONFIG_DIR="$APP_DIR/config"
CONFIG_FILE="$CONFIG_DIR/parse-config.json"
DASHBOARD_CONFIG="$CONFIG_DIR/dashboard-config.json"
DB_NAME="medrec_server_db"
DB_USER="medrec_admin"
DB_PASS=$(openssl rand -base64 12) # Generate random password
APP_ID="medrec_$(openssl rand -hex 4)" # Generate somewhat unique app id
MASTER_KEY=$(openssl rand -base64 32) # Generate strong master key
CLIENT_KEY=$(openssl rand -base64 16) # Generate random client key
PORT=1337
DASHBOARD_PORT=4040
DASHBOARD_USER="admin"
DASHBOARD_PASS=$(openssl rand -base64 8)

# Argument Parsing
INSTALL_DASHBOARD=true
for arg in "$@"
do
    case $arg in
        --no-dashboard)
        INSTALL_DASHBOARD=false
        shift
        ;;
    esac
done

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}   MedRec Setup Script (v2.1)            ${NC}"
echo -e "${GREEN}   Parse Server + PostgreSQL             ${NC}"
if [ "$INSTALL_DASHBOARD" = true ]; then
    echo -e "${GREEN}   + Parse Dashboard                     ${NC}"
fi
echo -e "${GREEN}=========================================${NC}"

# Check for root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root.${NC}" 
   echo "Please run with sudo: sudo ./INSTALL.sh [--no-dashboard]"
   exit 1
fi

echo "Updating system packages..."
apt-get update -y && apt-get upgrade -y
apt-get install -y curl gnupg build-essential libssl-dev

# Install Node.js (LTS v20)
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Install PostgreSQL
echo "Installing PostgreSQL..."
apt-get install -y postgresql postgresql-contrib

# Start PostgreSQL service
systemctl start postgresql
systemctl enable postgresql

# Create Database and User
echo "Configuring Database..."
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

DB_URI="postgres://$DB_USER:$DB_PASS@localhost:5432/$DB_NAME"

echo -e "${GREEN}Database created successfully!${NC}"

# Install Parse Server Globally
echo "Installing Parse Server..."
npm install -g parse-server pm2

# Install Parse Dashboard Globally (if requested)
if [ "$INSTALL_DASHBOARD" = true ]; then
    echo "Installing Parse Dashboard..."
    npm install -g parse-dashboard
fi

# Create Config Directory
if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
fi

# Write Parse Server Config
echo "Generating Server Configuration..."
cat > "$CONFIG_FILE" <<EOF
{
  "appName": "MedRec",
  "databaseURI": "$DB_URI",
  "appId": "$APP_ID",
  "masterKey": "$MASTER_KEY",
  "clientKey": "$CLIENT_KEY",
  "serverURL": "http://localhost:$PORT/parse",
  "publicServerURL": "http://localhost:$PORT/parse",
  "port": $PORT,
  "cloud": "$APP_DIR/cloud/main.js",
  "allowClientClassCreation": false,
  "enableAnonymousUsers": false
}
EOF

# Write Dashboard Config (if requested)
if [ "$INSTALL_DASHBOARD" = true ]; then
    echo "Generating Dashboard Configuration..."
    cat > "$DASHBOARD_CONFIG" <<EOF
{
  "apps": [
    {
      "serverURL": "http://localhost:$PORT/parse",
      "appId": "$APP_ID",
      "masterKey": "$MASTER_KEY",
      "appName": "MedRec"
    }
  ],
  "users": [
    {
      "user": "$DASHBOARD_USER",
      "pass": "$DASHBOARD_PASS"
    }
  ],
  "port": $DASHBOARD_PORT,
  "trustProxy": 1
}
EOF
fi

echo -e "${GREEN}Configuration files created at $CONFIG_DIR${NC}"

# Setup PM2 for process management
echo "Setting up PM2 process manager..."

# Start Parse Server
pm2 start parse-server --name "medrec-server" -- "$CONFIG_FILE"

# Start Dashboard (if requested)
if [ "$INSTALL_DASHBOARD" = true ]; then
    pm2 start parse-dashboard --name "medrec-dashboard" -- --config "$DASHBOARD_CONFIG"
fi

pm2 save
pm2 startup

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}   Installation Complete!                ${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "Your Parse Server is running on port $PORT."
if [ "$INSTALL_DASHBOARD" = true ]; then
    echo "Your Parse Dashboard is running on port $DASHBOARD_PORT."
fi
echo ""
echo -e "Use the following credentials in your App Setup Activity:"
echo -e "${GREEN}Server URL:${NC} http://<YOUR_SERVER_IP>:$PORT/parse"
echo -e "${GREEN}App ID:${NC}     $APP_ID"
echo -e "${GREEN}Client Key:${NC} $CLIENT_KEY"
echo ""

if [ "$INSTALL_DASHBOARD" = true ]; then
    echo "Access Dashboard at: http://<YOUR_SERVER_IP>:$DASHBOARD_PORT"
    echo "Username: $DASHBOARD_USER"
    echo "Password: $DASHBOARD_PASS"
    echo ""
fi

echo "Database Password (for reference): $DB_PASS"
echo ""
echo "You can manage the servers using: pm2 status / pm2 logs"