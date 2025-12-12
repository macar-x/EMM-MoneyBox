# CLI Testing Guide

Complete guide for testing all Cashlens CLI commands with Docker environment.

## Prerequisites

- Docker and Docker Compose installed
- Go 1.21+ installed
- Terminal access

## Setup

### 1. Start MongoDB with Docker

```bash
# Start MongoDB container
docker compose up -d mongodb

# Verify it's running
docker compose ps

# Check logs
docker compose logs -f mongodb
```

Expected output:
```
cashlens-mongodb  Up (healthy)
```

### 2. Set Environment Variables

```bash
# MongoDB configuration
export MONGO_DB_URI="mongodb://cashlens:cashlens123@localhost:27017/cashlens?authSource=admin"
export DB_TYPE=mongodb
export DB_NAME=cashlens

# Or use .env file
export $(cat .env | xargs)
```

### 3. Build CLI

```bash
cd backend
go build -o cashlens main.go
```

## Testing Checklist

### ✅ Global Commands

#### version
```bash
./cashlens version
```

**Expected**:
```
Cashlens v1.0.0
Build Time: unknown
Git Commit: unknown
Go Version: go1.21.5
OS/Arch: linux/amd64
```

**Status**: ✅ Should work

---

### ✅ Database Commands

#### db connect
```bash
./cashlens db connect
```

**Expected**:
```
✅ Database connection successful
Connection Info:
  Type:     mongodb
  Host:     localhost:27017
  Database: cashlens
  Status:   connected
```

**Status**: ✅ Should work

#### db seed
```bash
./cashlens db seed
```

**Expected**: Creates demo categories and transactions

**Status**: ✅ Should work (alias for manage init)

---

### ✅ Manage Commands

#### manage init
```bash
./cashlens manage init
```

**Expected**:
```
Database initialized with demo data successfully
Demo data includes:
  - 8 default categories
  - 15 sample transactions
```

**Status**: ✅ Should work

**Verification**:
```bash
# Check in MongoDB
docker exec -it cashlens-mongodb mongosh \
  -u cashlens -p cashlens123 \
  --authenticationDatabase admin cashlens \
  --eval "db.categories.countDocuments()"

# Should return 8
```

#### manage export
```bash
./cashlens manage export -o test_export.xlsx
```

**Expected**: Creates Excel file with transactions

**Status**: ✅ Should work

**Verification**:
```bash
ls -lh test_export.xlsx
```

#### manage import
```bash
./cashlens manage import -i test_export.xlsx
```

**Expected**: Imports transactions from Excel

**Status**: ✅ Should work

#### manage stats
```bash
./cashlens manage stats
```

**Expected**:
```
=== Database Statistics ===
Cash Flow Records:  0
  - Income:         0
  - Expense:        0
Categories:         0

Financial Summary:
  Total Income:     0.00
  Total Expense:    0.00
  Balance:          0.00

Date Range:
  Earliest:         N/A
  Latest:           N/A
```

**Status**: 🔶 Partial - Returns empty stats (needs mapper aggregation methods)

#### manage backup
```bash
./cashlens manage backup -o backup.json
```

**Expected**: Creates JSON backup file

**Status**: 🔶 Partial - Creates empty backup structure (needs GetAll mapper methods)

#### manage restore
```bash
./cashlens manage restore -i backup.json
```

**Expected**: Restores data from backup

**Status**: 🔶 Partial - Needs ResetDatabase and bulk insert methods

#### manage reset
```bash
./cashlens manage reset
```

**Expected**: Prompts for confirmation, then clears all data

**Status**: 🔶 Partial - Needs DeleteAll mapper methods

---

### ✅ Category Commands

#### category create
```bash
./cashlens category create -n "Food & Dining"
./cashlens category create -n "Transportation"
./cashlens category create -n "Entertainment"
```

**Expected**: Creates categories

**Status**: ✅ Should work

**Verification**:
```bash
docker exec -it cashlens-mongodb mongosh \
  -u cashlens -p cashlens123 \
  --authenticationDatabase admin cashlens \
  --eval "db.categories.find().pretty()"
```

#### category query
```bash
# Query by name
./cashlens category query -n "Food & Dining"

# Query by ID
./cashlens category query -i <category_id>
```

**Expected**: Displays matching categories

**Status**: ✅ Should work

#### category list
```bash
./cashlens category list
```

**Expected**: Lists all categories

**Status**: 🔶 Partial - Needs GetAllCategories mapper method

#### category update
```bash
./cashlens category update -i <category_id> -n "New Name"
```

**Expected**: Updates category name

**Status**: 🔶 Partial - Needs enhanced UpdateCategoryByEntity mapper method

#### category delete
```bash
./cashlens category delete -i <category_id>
```

**Expected**: Deletes category

**Status**: ✅ Should work

---

### ✅ Cash Flow Commands

#### cash income
```bash
./cashlens cash income -c "Salary" -a 5000 -d "Monthly salary"
./cashlens cash income -c "Freelance" -a 1500 -b 2024-12-04
```

**Expected**: Creates income transactions

**Status**: ✅ Should work

**Verification**:
```bash
docker exec -it cashlens-mongodb mongosh \
  -u cashlens -p cashlens123 \
  --authenticationDatabase admin cashlens \
  --eval "db.cash_flows.find({flow_type: 'INCOME'}).pretty()"
```

#### cash outcome
```bash
./cashlens cash outcome -c "Food & Dining" -a 45.50 -d "Lunch"
./cashlens cash outcome -c "Transportation" -a 20 -b 2024-12-04
```

**Expected**: Creates expense transactions

**Status**: ✅ Should work

**Verification**:
```bash
docker exec -it cashlens-mongodb mongosh \
  -u cashlens -p cashlens123 \
  --authenticationDatabase admin cashlens \
  --eval "db.cash_flows.find({flow_type: 'OUTCOME'}).pretty()"
```

#### cash query
```bash
# Query by date
./cashlens cash query -b 2024-12-04

# Query by ID
./cashlens cash query -i <transaction_id>

# Query by exact description
./cashlens cash query -e "Lunch"

# Query by fuzzy description
./cashlens cash query -f "lunch"
```

**Expected**: Displays matching transactions

**Status**: ✅ Should work

#### cash delete
```bash
# Delete by ID
./cashlens cash delete -i <transaction_id>

# Delete by date
./cashlens cash delete -b 2024-12-04
```

**Expected**: Deletes transactions

**Status**: ✅ Should work

#### cash update
```bash
./cashlens cash update -i <transaction_id> -a 50.00 -d "Updated description"
```

**Expected**: Updates transaction

**Status**: 🔶 Partial - Needs enhanced UpdateCashFlowByEntity mapper method

#### cash list
```bash
# List all
./cashlens cash list

# List with limit
./cashlens cash list -l 20

# List with offset
./cashlens cash list -l 20 -o 20

# Filter by type
./cashlens cash list -t income
./cashlens cash list -t outcome
```

**Expected**: Lists transactions with pagination

**Status**: 🔶 Partial - Needs GetAllCashFlows mapper method

#### cash range
```bash
./cashlens cash range -f 2024-12-01 -t 2024-12-31
```

**Expected**:
```
cash_flow 0 : [transaction details]
cash_flow 1 : [transaction details]
...

--- Summary ---
Period: 2024-12-01 to 2024-12-31
Total Records: 15
Total Income: 5000.00
Total Expense: 497.50
Balance: 4502.50
```

**Status**: ✅ Should work

#### cash summary
```bash
# Daily summary
./cashlens cash summary -p daily -d 2024-12-04

# Monthly summary
./cashlens cash summary -p monthly -d 2024-12

# Yearly summary
./cashlens cash summary -p yearly -d 2024
```

**Expected**:
```
=== monthly Summary for 2024-12 ===
Total Income:  5000.00
Total Expense: 497.50
Balance:       4502.50
Transactions:  15

--- Category Breakdown ---
  Food & Dining       : 77.50
  Transportation      : 20.00
  ...
```

**Status**: ✅ Should work

---

### ✅ Server Commands

#### server start
```bash
./cashlens server start -p 8080
```

**Expected**: Starts API server on port 8080

**Status**: ✅ Should work

**Verification** (in another terminal):
```bash
# Health check
curl http://localhost:8080/api/health

# Version
curl http://localhost:8080/api/version

# Get transactions
curl http://localhost:8080/api/cash/date/2024-12-04
```

---

## Complete Test Workflow

### 1. Initialize Database

```bash
# Start MongoDB
docker compose up -d mongodb

# Set environment
export MONGO_DB_URI="mongodb://cashlens:cashlens123@localhost:27017/cashlens?authSource=admin"
export DB_TYPE=mongodb
export DB_NAME=cashlens

# Build CLI
cd backend
go build -o cashlens main.go

# Test connection
./cashlens db connect
```

### 2. Create Demo Data

```bash
# Initialize with demo data
./cashlens manage init

# Or create manually
./cashlens category create -n "Salary"
./cashlens category create -n "Food & Dining"
./cashlens category create -n "Transportation"

./cashlens cash income -c "Salary" -a 5000 -d "Monthly salary"
./cashlens cash outcome -c "Food & Dining" -a 45.50 -d "Lunch"
./cashlens cash outcome -c "Transportation" -a 20 -d "Bus fare"
```

### 3. Query and Verify

```bash
# Query today's transactions
./cashlens cash query -b $(date +%Y-%m-%d)

# Query date range
./cashlens cash range -f 2024-12-01 -t 2024-12-31

# Get monthly summary
./cashlens cash summary -p monthly -d $(date +%Y-%m)

# List categories
./cashlens category query -n "Food & Dining"
```

### 4. Export and Backup

```bash
# Export to Excel
./cashlens manage export -o december_2024.xlsx

# Create backup
./cashlens manage backup -o backup_$(date +%Y%m%d).json

# Show stats
./cashlens manage stats
```

### 5. Test API Server

```bash
# Start server (in background or separate terminal)
./cashlens server start -p 8080 &

# Test endpoints
curl http://localhost:8080/api/health
curl http://localhost:8080/api/version
curl http://localhost:8080/api/cash/date/$(date +%Y-%m-%d)

# Stop server
pkill cashlens
```

---

## Implementation Status Summary

### ✅ Fully Functional (17 commands)
- version
- db connect, db seed
- manage init, export, import
- category create, query, delete
- cash income, outcome, query, delete, range, summary
- server start

### 🔶 Partially Functional (6 commands)
- manage stats, backup, restore, reset
- category list, update
- cash list, update

**Note**: Partially functional commands need mapper layer enhancements. See [docs/TODO.md](../../docs/TODO.md) for details.

---

## Troubleshooting

### MongoDB Connection Failed

```bash
# Check if MongoDB is running
docker compose ps

# Check MongoDB logs
docker compose logs mongodb

# Restart MongoDB
docker compose restart mongodb
```

### Command Not Found

```bash
# Ensure binary is built
cd backend
go build -o cashlens main.go

# Make executable
chmod +x cashlens

# Use full path
./cashlens version
```

### Category Not Found

```bash
# List all categories first
docker exec -it cashlens-mongodb mongosh \
  -u cashlens -p cashlens123 \
  --authenticationDatabase admin cashlens \
  --eval "db.categories.find({}, {name: 1}).pretty()"

# Create category if missing
./cashlens category create -n "CategoryName"
```

### Database Reset

```bash
# Stop MongoDB
docker compose down

# Remove volumes (deletes all data)
docker compose down -v

# Start fresh
docker compose up -d mongodb

# Reinitialize
./cashlens manage init
```

---

## Next Steps

1. Test all ✅ commands to verify they work
2. Document any issues found
3. Implement mapper enhancements for 🔶 commands
4. Add integration tests
5. Create automated test script

## See Also

- [CLI Reference](CLI.md) - Complete command documentation
- [API Reference](API.md) - API endpoints
- [Testing Guide](TESTING.md) - Backend testing
- [TODO](../../docs/TODO.md) - Mapper enhancements needed
