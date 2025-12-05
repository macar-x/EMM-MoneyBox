# Cashlens CLI Reference

**See your money clearly**

Command-line interface for managing personal finances with Cashlens.

## Quick Start

### Common Commands

```bash
# Add expense
cashlens cash outcome -c "Food" -a 45.50 -d "Lunch"

# Add income
cashlens cash income -c "Salary" -a 5000

# View today's transactions
cashlens cash query -b $(date +%Y-%m-%d)

# Start API server
cashlens server start -p 8080

# Export data
cashlens manage export -o data.xlsx
```

### Command Structure

```
cashlens
├── version              Show version info
├── server start         Start API server
├── cash                 Manage transactions
│   ├── income          Add income
│   ├── outcome         Add expense
│   ├── update          Update transaction
│   ├── delete          Delete transaction
│   ├── query           Query transactions
│   ├── list            List all transactions
│   ├── range           Query date range
│   └── summary         Show summary
├── category            Manage categories
│   ├── create          Create category
│   ├── update          Update category
│   ├── delete          Delete category
│   ├── query           Query categories
│   └── list            List all categories
├── manage              Data management
│   ├── export          Export to Excel
│   ├── import          Import from Excel
│   ├── backup          Create backup
│   ├── restore         Restore backup
│   ├── init            Initialize demo data
│   ├── reset           Clear all data
│   └── stats           Show statistics
└── db                  Database operations
    ├── connect         Test connection
    └── seed            Seed demo data
```

### Implementation Status

✅ **Working**: cash income/outcome/query/delete, category create/query/delete, manage export/import, server start  
🚧 **Pending**: cash update/list/range/summary, category update/list, manage backup/restore/init/reset/stats, db connect/seed

## Installation

```bash
cd backend
go build -o cashlens main.go
```

## Environment Setup

```bash
# MongoDB
export DB_TYPE=mongodb
export MONGO_DB_URI="mongodb://cashlens:cashlens123@localhost:27017/cashlens?authSource=admin"
export DB_NAME=cashlens

# MySQL
export DB_TYPE=mysql
export MYSQL_DB_URI="cashlens:cashlens123@tcp(localhost:3306)/cashlens"
export DB_NAME=cashlens
```

See [ENVIRONMENT.md](../../docs/ENVIRONMENT.md) for detailed configuration.

---

## Command Reference

### Global Commands

### version
Show version information

```bash
cashlens version
```

Output:
```
Cashlens v1.0.0
Build Time: unknown
Git Commit: unknown
Go Version: go1.21.5
OS/Arch: linux/amd64
```

## Server Commands

### server start
Start the API server

```bash
cashlens server start -p 8080
```

Flags:
- `-p, --port` - Server port (default: 8080)

Environment variables required:
- `MONGO_DB_URI` or `MYSQL_DB_URI` - Database connection string
- `DB_TYPE` - Database type (mongodb/mysql)
- `DB_NAME` - Database name

## Cash Flow Commands

### cash income
Add new income transaction

```bash
cashlens cash income -c "Salary" -a 5000 -d "Monthly salary"
cashlens cash income -c "Freelance" -a 1500 -b 2024-01-15
```

Flags:
- `-c, --category` - Category name (required)
- `-a, --amount` - Amount (required)
- `-b, --date` - Transaction date (optional, default: today)
- `-d, --description` - Description (optional)

### cash outcome
Add new expense transaction

```bash
cashlens cash outcome -c "Food & Dining" -a 45.50 -d "Lunch"
cashlens cash outcome -c "Transportation" -a 20 -b 2024-01-15
```

Flags:
- `-c, --category` - Category name (required)
- `-a, --amount` - Amount (required)
- `-b, --date` - Transaction date (optional, default: today)
- `-d, --description` - Description (optional)

### cash update
Update existing transaction

```bash
cashlens cash update -i 507f1f77bcf86cd799439011 -a 50.00
cashlens cash update -i 507f1f77bcf86cd799439011 -c "Groceries" -d "Updated"
```

Flags:
- `-i, --id` - Transaction ID (required)
- `-a, --amount` - New amount (optional)
- `-c, --category` - New category (optional)
- `-b, --date` - New date (optional)
- `-d, --description` - New description (optional)

**Status**: Not yet implemented - requires database integration

### cash delete
Delete transaction(s)

```bash
# Delete by ID
cashlens cash delete -i 507f1f77bcf86cd799439011

# Delete all transactions on a date
cashlens cash delete -b 2024-01-15
```

Flags:
- `-i, --id` - Transaction ID
- `-b, --date` - Date (YYYY-MM-DD)

### cash query
Query transactions by filters

```bash
# Query by ID
cashlens cash query -i 507f1f77bcf86cd799439011

# Query by date
cashlens cash query -b 2024-01-15

# Query by exact description
cashlens cash query -e "Lunch"

# Query by fuzzy description
cashlens cash query -f "lunch"
```

Flags:
- `-i, --id` - Query by ID
- `-b, --date` - Query by date
- `-e, --exact` - Query by exact description
- `-f, --fuzzy` - Query by fuzzy description

### cash list
List all transactions with pagination

```bash
# List all
cashlens cash list

# List with limit
cashlens cash list -l 20

# List with offset
cashlens cash list -l 20 -o 40

# Filter by type
cashlens cash list -t income
cashlens cash list -t outcome
```

Flags:
- `-l, --limit` - Maximum records to return (default: 50)
- `-o, --offset` - Number of records to skip (default: 0)
- `-t, --type` - Filter by type (income/outcome)

**Status**: Not yet implemented - requires database integration

### cash range
Query transactions by date range

```bash
cashlens cash range -f 2024-01-01 -t 2024-01-31
cashlens cash range --from 2024-01-01 --to 2024-01-31
```

Flags:
- `-f, --from` - Start date (YYYY-MM-DD) (required)
- `-t, --to` - End date (YYYY-MM-DD) (required)

Output includes:
- All transactions in range
- Total income
- Total expense
- Balance

**Status**: Not yet implemented - requires database integration

### cash summary
Show financial summary

```bash
# Daily summary
cashlens cash summary -p daily -d 2024-01-15

# Monthly summary
cashlens cash summary -p monthly -d 2024-01

# Yearly summary
cashlens cash summary -p yearly -d 2024
```

Flags:
- `-p, --period` - Period type (daily/monthly/yearly) (required)
- `-d, --date` - Date for summary (required)
  - Daily: YYYY-MM-DD
  - Monthly: YYYY-MM
  - Yearly: YYYY

Output includes:
- Total income
- Total expense
- Balance
- Transaction count
- Category breakdown

**Status**: Not yet implemented - requires database integration

## Category Commands

### category create
Create new category

```bash
cashlens category create -n "Food & Dining"
cashlens category create -n "Groceries" -p 507f1f77bcf86cd799439011
```

Flags:
- `-n, --name` - Category name (required)
- `-p, --parent` - Parent category ID (optional)

### category update
Update existing category

```bash
cashlens category update -i 507f1f77bcf86cd799439011 -n "New Name"
cashlens category update -i 507f1f77bcf86cd799439011 -p 507f1f77bcf86cd799439012
```

Flags:
- `-i, --id` - Category ID (required)
- `-n, --name` - New name (optional)
- `-p, --parent` - New parent ID (optional)

**Status**: Not yet implemented - requires database integration

### category delete
Delete category

```bash
cashlens category delete -i 507f1f77bcf86cd799439011
```

Flags:
- `-i, --id` - Category ID (required)

### category query
Query categories by filters

```bash
# Query by ID
cashlens category query -i 507f1f77bcf86cd799439011

# Query by name
cashlens category query -n "Food & Dining"

# Query by parent
cashlens category query -p 507f1f77bcf86cd799439011
```

Flags:
- `-i, --id` - Query by ID
- `-n, --name` - Query by name
- `-p, --parent` - Query by parent ID

### category list
List all categories

```bash
cashlens category list
```

**Status**: Not yet implemented - requires database integration

## Data Management Commands

### manage export
Export data to Excel

```bash
# Export all data
cashlens manage export -o data.xlsx

# Export date range
cashlens manage export -f 2024-01-01 -t 2024-01-31 -o january.xlsx
```

Flags:
- `-o, --output` - Output file path (required)
- `-f, --from` - Start date (optional)
- `-t, --to` - End date (optional)

### manage import
Import data from Excel

```bash
cashlens manage import -i data.xlsx
```

Flags:
- `-i, --input` - Input file path (required)

### manage backup
Create database backup

```bash
# Auto-generated filename
cashlens manage backup

# Custom filename
cashlens manage backup -o backup_20240115.json
```

Flags:
- `-o, --output` - Backup file path (optional, default: cashlens_backup_TIMESTAMP.json)

**Status**: Not yet implemented - requires database integration

### manage restore
Restore database from backup

```bash
cashlens manage restore -i backup_20240115.json

# Skip confirmation
cashlens manage restore -i backup_20240115.json -f
```

Flags:
- `-i, --input` - Backup file path (required)
- `-f, --force` - Skip confirmation prompt

**Status**: Not yet implemented - requires database integration

### manage init
Initialize database with demo data

```bash
cashlens manage init
```

Creates:
- 8 default categories
- 15 sample transactions

**Status**: Not yet implemented - requires database integration

### manage reset
Clear all database data

```bash
cashlens manage reset

# Skip confirmation (dangerous!)
cashlens manage reset -f
```

Flags:
- `-f, --force` - Skip confirmation prompt

⚠️ **WARNING**: This operation cannot be undone. Create a backup first!

**Status**: Not yet implemented - requires database integration

### manage stats
Show database statistics

```bash
cashlens manage stats
```

Output:
- Cash flow record counts
- Income/expense breakdown
- Financial summary
- Date range

**Status**: Not yet implemented - requires database integration

## Database Commands

### db connect
Test database connection

```bash
cashlens db connect
```

Output:
- Connection status
- Database type
- Host
- Database name

**Status**: Not yet implemented - requires database integration

### db seed
Seed database with demo data

```bash
cashlens db seed
```

Alias for `manage init`.

**Status**: Not yet implemented - requires database integration

## Advanced Configuration

### Optional Environment Variables

```bash
# Logging
export LOG_LEVEL=debug  # debug, info, warn, error

# Server
export SERVER_PORT=8080
export CORS_ORIGINS="http://localhost:3000,http://localhost:4000"
```

## Examples

### Daily Workflow

```bash
# Add morning coffee
cashlens cash outcome -c "Food & Dining" -a 4.50 -d "Morning coffee"

# Add lunch
cashlens cash outcome -c "Food & Dining" -a 12.00 -d "Lunch"

# Check today's transactions
cashlens cash query -b $(date +%Y-%m-%d)

# Get monthly summary
cashlens cash summary -p monthly -d $(date +%Y-%m)
```

### Data Management

```bash
# Create backup before major changes
cashlens manage backup -o backup_before_cleanup.json

# Export data for analysis
cashlens manage export -f 2024-01-01 -t 2024-12-31 -o year_2024.xlsx

# Check database stats
cashlens manage stats
```

### Category Management

```bash
# Create main categories
cashlens category create -n "Food & Dining"
cashlens category create -n "Transportation"
cashlens category create -n "Entertainment"

# Create subcategories
cashlens category create -n "Groceries" -p <food_category_id>
cashlens category create -n "Restaurants" -p <food_category_id>

# List all categories
cashlens category list
```

## Implementation Status

### ✅ Implemented
- Server start
- Cash income/outcome
- Cash query (by ID, date, description)
- Cash delete (by ID, date)
- Category create/query/delete
- Manage export/import
- Version command

### 🚧 Pending Implementation
- Cash update
- Cash list
- Cash range
- Cash summary
- Category update
- Category list
- Manage backup/restore
- Manage init/reset/stats
- DB connect/seed

All pending commands have CLI structure in place and will return helpful error messages indicating they need database integration.

## Building for Production

```bash
# Build with version info
cd backend
go build -ldflags "\
  -X github.com/macar-x/cashlens/cmd.Version=1.0.0 \
  -X github.com/macar-x/cashlens/cmd.BuildTime=$(date -u +%Y-%m-%dT%H:%M:%SZ) \
  -X github.com/macar-x/cashlens/cmd.GitCommit=$(git rev-parse --short HEAD)" \
  -o cashlens main.go

# Install globally
sudo mv cashlens /usr/local/bin/
```

## Shell Completion

Generate shell completion scripts:

```bash
# Bash
cashlens completion bash > /etc/bash_completion.d/cashlens

# Zsh
cashlens completion zsh > "${fpath[1]}/_cashlens"

# Fish
cashlens completion fish > ~/.config/fish/completions/cashlens.fish

# PowerShell
cashlens completion powershell > cashlens.ps1
```

## Troubleshooting

### Database Connection Issues

```bash
# Test connection
cashlens db connect

# Check environment variables
echo $MONGO_DB_URI
echo $DB_TYPE
echo $DB_NAME
```

### Command Not Found

```bash
# Ensure binary is in PATH
which cashlens

# Or use full path
./cashlens version
```

### Permission Denied

```bash
# Make binary executable
chmod +x cashlens
```

## Support

For issues and feature requests, visit:
https://github.com/macar-x/cashlens/issues
