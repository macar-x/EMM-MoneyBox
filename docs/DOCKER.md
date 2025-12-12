# Docker Setup Guide

Quick start guide for running Cashlens with Docker.

## Prerequisites

- Docker Desktop installed
- Docker Compose installed (included with Docker Desktop)

## Quick Start (Recommended)

The easiest way to start Cashlens is using the `start.sh` script:

```bash
./start.sh
```

This script will:
1. Check if Docker is installed
2. Create `.env` from `.env.sample` if it doesn't exist
3. Prompt you to select which services to start:
   - MongoDB + Backend (default)
   - MySQL + Backend
   - MongoDB only
   - MySQL only
   - Backend only
   - Custom selection
4. Start the selected services with proper configuration
5. Show service status and access information

### Non-Interactive Mode

You can also configure services via `.env` file and run non-interactively:

```bash
# Edit .env file
ENABLE_SERVICES=mongodb,backend

# Run start.sh
./start.sh
```

## Manual Setup

### Start MongoDB (Default)

```bash
docker-compose --profile mongodb up -d
```

This will:
- Start MongoDB on port 27017
- Create `cashlens` database with demo data
- Use credentials from `.env` file

**Connection String**:
```
mongodb://cashlens:cashlens123@localhost:27017/cashlens?authSource=admin
```

### Start MySQL (Alternative)

```bash
docker-compose --profile mysql up -d
```

This will:
- Start MySQL on port 3306
- Create `cashlens` database with demo data
- Use credentials from `.env` file

**Connection String**:
```
mysql://cashlens:cashlens123@localhost:3306/cashlens
```

### Start Backend API

```bash
docker-compose --profile backend up -d
```

This will:
- Build and start the Go backend
- Connect to database (MongoDB or MySQL based on DB_TYPE)
- Expose API on configured port (default: 8080)

### Start All Services

**With MongoDB**:
```bash
docker-compose --profile mongodb --profile backend up -d
```

**With MySQL**:
```bash
docker-compose --profile mysql --profile backend up -d
```

## Environment Configuration

All configuration is managed through the `.env` file. Copy `.env.sample` to `.env` and customize:

```bash
cp .env.sample .env
```

### Key Configuration Variables

**Service Selection**:
```bash
# Services to enable (used by start.sh)
ENABLE_SERVICES=mongodb,backend
```

**MongoDB Configuration**:
```bash
MONGO_VERSION=7.0
MONGO_PORT=27017
MONGO_ROOT_USERNAME=cashlens
MONGO_ROOT_PASSWORD=your-secure-password
```

**MySQL Configuration**:
```bash
MYSQL_VERSION=8.0
MYSQL_PORT=3306
MYSQL_USER=cashlens
MYSQL_PASSWORD=your-secure-password
MYSQL_ROOT_PASSWORD=your-root-password
```

**Backend Configuration**:
```bash
DB_TYPE=mongodb  # or mysql
SERVER_PORT=8080
LOG_LEVEL=info
DB_NAME=cashlens
```

**Database URIs**:
```bash
# For Docker MongoDB (includes database name)
MONGO_DB_URI=mongodb://cashlens:cashlens123@mongodb:27017/cashlens?authSource=admin

# For Docker MySQL (database name appended automatically from DB_NAME)
MYSQL_DB_URI=cashlens:cashlens123@tcp(mysql:3306)
```

See `.env.sample` for all available configuration options.

## Demo Data

### Categories (8 total)

**Expenses**:
- 🍔 Food & Dining
- 🚗 Transportation
- 🛍️ Shopping
- 🎬 Entertainment
- 💡 Bills & Utilities
- 🏥 Healthcare

**Income**:
- 💰 Salary
- 📈 Investment

### Transactions (15 total)

- **Today**: 3 transactions ($3,557.50 total)
- **Yesterday**: 2 transactions ($114.99 total)
- **This week**: 3 transactions ($415.00 total)
- **Earlier this month**: 7 transactions ($1,180.50 total)

**Summary**:
- Total Income: $4,200.00
- Total Expense: $1,067.99
- Balance: $3,132.01

## Useful Commands

### View Logs

```bash
# MongoDB logs
docker-compose logs -f mongodb

# MySQL logs
docker-compose logs -f mysql

# Backend logs
docker-compose logs -f backend
```

### Stop Services

```bash
# Stop all
docker-compose down

# Stop and remove volumes (deletes data)
docker-compose down -v
```

### Restart Services

```bash
# Restart MongoDB
docker-compose restart mongodb

# Restart all
docker-compose restart
```

### Access Database

**MongoDB Shell**:
```bash
docker exec -it cashlens-mongodb mongosh -u cashlens -p cashlens123 --authenticationDatabase admin cashlens
```

**MySQL Shell**:
```bash
docker exec -it cashlens-mysql mysql -u cashlens -pcashlens123 cashlens
```

### Check Health

```bash
# Check container status
docker-compose ps

# Check MongoDB health
docker exec cashlens-mongodb mongosh --eval "db.adminCommand('ping')"

# Check MySQL health
docker exec cashlens-mysql mysqladmin ping -h localhost -u root -pcashlens123
```

## Data Persistence

Data is persisted in Docker volumes:
- `cashlens_mongodb_data` - MongoDB data
- `cashlens_mysql_data` - MySQL data

To completely reset:
```bash
docker-compose down -v
docker-compose up -d mongodb
```

## Troubleshooting

### Port Already in Use

**MongoDB (27017)**:
```bash
# Find process using port
lsof -i :27017

# Stop local MongoDB
brew services stop mongodb-community  # macOS
sudo systemctl stop mongod            # Linux
```

**MySQL (3306)**:
```bash
# Find process using port
lsof -i :3306

# Stop local MySQL
brew services stop mysql               # macOS
sudo systemctl stop mysql              # Linux
```

### Container Won't Start

```bash
# Check logs
docker-compose logs mongodb

# Remove and recreate
docker-compose down
docker-compose up -d mongodb
```

### Reset Demo Data

```bash
# Stop and remove volumes
docker-compose down -v

# Start fresh
docker-compose up -d mongodb
```

## Production Considerations

For production deployment:

1. **Change default passwords**:
   ```yaml
   environment:
     MONGO_INITDB_ROOT_PASSWORD: <strong-password>
   ```

2. **Use environment files**:
   ```yaml
   env_file:
     - .env.production
   ```

3. **Enable authentication**:
   - MongoDB: Already enabled
   - MySQL: Already enabled

4. **Backup volumes**:
   ```bash
   docker run --rm -v cashlens_mongodb_data:/data -v $(pwd):/backup ubuntu tar czf /backup/mongodb-backup.tar.gz /data
   ```

5. **Use secrets management**:
   - Docker Secrets
   - Kubernetes Secrets
   - HashiCorp Vault

## Network Configuration

All services run on the `cashlens-network` bridge network.

Services can communicate using container names:
- `mongodb` - MongoDB service
- `mysql` - MySQL service
- `backend` - Backend API service

## Profiles

Docker Compose profiles allow selective service startup:

- **Default**: Only MongoDB
- **mysql**: Start MySQL instead
- **backend**: Start backend API

```bash
# Start MongoDB + Backend
docker-compose --profile backend up -d

# Start MySQL + Backend
docker-compose --profile mysql --profile backend up -d
```

## Health Checks

All services include health checks:

- **MongoDB**: Ping command every 10s
- **MySQL**: mysqladmin ping every 10s
- **Backend**: Depends on database health

Check health status:
```bash
docker-compose ps
```

## Next Steps

1. Start MongoDB: `docker-compose up -d mongodb`
2. Update `.env` with connection string
3. Run backend: `cd backend && go run main.go server start`
4. Test API: `curl http://localhost:8080/api/health`
5. Run Flutter app: `cd flutter && flutter run`

Enjoy using Cashlens! 💰
