# Environment Configuration Guide

This guide explains how to configure environment variables for both backend and Flutter applications.

## Quick Start

1. Copy the sample environment file:
```bash
cp .env.sample .env
```

2. Edit `.env` with your configuration values

3. The `.env` file is automatically loaded by:
   - **Backend**: Go reads environment variables directly
   - **Flutter**: Pass variables during build/run

## Environment Variables

### Backend (Go)

The backend reads these variables from the environment:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `DB_TYPE` | Database type: `mongodb` or `mysql` | `mongodb` | No |
| `MONGO_DB_URI` | MongoDB connection string | - | Yes (if using MongoDB) |
| `MYSQL_DB_URI` | MySQL connection string | - | Yes (if using MySQL) |
| `DB_NAME` | Database name | `cashlens` | No |
| `LOG_FILE` | Log file path | `./cashlens.log` | No |
| `SERVER_PORT` | Server port | `8080` | No |

**MongoDB URI Format:**
```
mongodb+srv://username:password@cluster.mongodb.net/cashlens?retryWrites=true&w=majority
```

**MySQL URI Format:**
```
username:password@tcp(localhost:3306)/cashlens
```

### Flutter

Flutter uses compile-time environment variables:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `API_BASE_URL` | Backend API URL | `http://localhost:8080` | No |

**Pass during build:**
```bash
flutter build web --dart-define=API_BASE_URL=https://api.yourdomain.com
```

**Pass during run:**
```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8080
```

## Usage Examples

### Development Setup

**Backend:**
```bash
# Set environment variables
export DB_TYPE=mongodb
export MONGO_DB_URI="mongodb://localhost:27017"
export DB_NAME=cashlens_dev

# Run backend
cd backend
go run main.go server start -p 8080
```

**Flutter:**
```bash
cd flutter
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080
```

### Production Setup

**Backend:**
```bash
# Use production database
export DB_TYPE=mongodb
export MONGO_DB_URI="mongodb+srv://prod-user:password@cluster.mongodb.net/cashlens?retryWrites=true&w=majority"
export LOG_FILE=/var/log/cashlens/app.log

cd backend
go run main.go server start -p 8080
```

**Flutter:**
```bash
cd flutter
flutter build web --release --dart-define=API_BASE_URL=https://api.yourdomain.com
```

## Using .env File

### Backend

The backend reads environment variables directly from the system. You can use tools like:

**Option 1: Export manually**
```bash
export $(cat .env | xargs)
cd backend
go run main.go server start
```

**Option 2: Use direnv** (recommended)
```bash
# Install direnv
# Then create .envrc file
echo 'dotenv' > .envrc
direnv allow
```

**Option 3: Use docker-compose**
```yaml
# docker-compose.yml
services:
  backend:
    env_file:
      - .env
```

### Flutter

Flutter doesn't read `.env` files directly. Options:

**Option 1: Shell script wrapper**
```bash
#!/bin/bash
# run-flutter.sh
source .env
flutter run --dart-define=API_BASE_URL=$API_BASE_URL
```

**Option 2: Use flutter_dotenv package**
```yaml
# pubspec.yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

## Security Notes

⚠️ **Important:**
- Never commit `.env` file to version control
- `.env` is already in `.gitignore`
- Use different credentials for development and production
- Rotate secrets regularly
- Use environment-specific configurations

## Troubleshooting

**Backend can't connect to database:**
- Check `MONGO_DB_URI` or `MYSQL_DB_URI` format
- Verify database credentials
- Ensure database server is running
- Check network connectivity

**Flutter can't reach API:**
- Verify `API_BASE_URL` is correct
- Check if backend server is running
- Ensure CORS is configured (for web)
- Check network/firewall settings

**Environment variables not loading:**
- Verify `.env` file exists
- Check file permissions
- Ensure proper export/sourcing
- Restart terminal/IDE after changes
