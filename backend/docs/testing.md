# Backend Testing Guide

Testing guide for Cashlens backend (CLI and API).

## Prerequisites

- Go 1.21+
- MongoDB or MySQL running
- Docker (for database)

## Quick Start

### 1. Start Database

```bash
# Start MongoDB with demo data
docker compose up -d mongodb

# Verify it's running
docker compose ps

# Check logs
docker compose logs -f mongodb
```

### 2. Verify Demo Data

```bash
# Connect to MongoDB
docker exec -it cashlens-mongodb mongosh \
  -u cashlens -p cashlens123 \
  --authenticationDatabase admin cashlens

# In MongoDB shell:
db.cash_flows.countDocuments()  # Should return 15
db.categories.countDocuments()  # Should return 8

# Check summary
db.cash_flows.aggregate([
  {
    $group: {
      _id: "$flow_type",
      total: { $sum: "$amount" },
      count: { $count: {} }
    }
  }
])

# Exit
exit
```

### 3. Set Environment Variables

```bash
# MongoDB
export MONGO_DB_URI="mongodb://cashlens:cashlens123@localhost:27017/cashlens?authSource=admin"
export DB_TYPE=mongodb
export DB_NAME=cashlens

# Or use .env file
export $(cat .env | xargs)
```

## CLI Testing

### Build CLI

```bash
cd backend
go build -o cashlens main.go
```

### Test Commands

```bash
# Version
./cashlens version

# Query transactions
./cashlens cash query -b 2024-12-04

# Add expense
./cashlens cash outcome -c "Food & Dining" -a 45.50 -d "Lunch"

# Add income
./cashlens cash income -c "Salary" -a 5000

# List categories
./cashlens category list

# Export data
./cashlens manage export -o test_export.xlsx

# Show stats
./cashlens manage stats
```

See [CLI.md](CLI.md) for complete command reference.

## API Testing

### Start Server

```bash
cd backend
go run main.go server start -p 8080
```

### Test Endpoints

```bash
# Health check
curl http://localhost:8080/api/health

# Version info
curl http://localhost:8080/api/version

# Get today's transactions
curl http://localhost:8080/api/cash/date/$(date +%Y-%m-%d)

# Get specific date
curl http://localhost:8080/api/cash/date/2024-12-04

# Create expense
curl -X POST http://localhost:8080/api/cash/outcome \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 45.50,
    "date": "2024-12-05",
    "category": "Food & Dining",
    "description": "Lunch"
  }'

# Create income
curl -X POST http://localhost:8080/api/cash/income \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 5000,
    "date": "2024-12-05",
    "category": "Salary",
    "description": "Monthly salary"
  }'

# Delete by ID
curl -X DELETE http://localhost:8080/api/cash/{id}

# Delete by date
curl -X DELETE http://localhost:8080/api/cash/date/2024-12-05
```

### Test CORS

```bash
curl -i -H "Origin: http://localhost:3000" \
     -H "Access-Control-Request-Method: GET" \
     -H "Access-Control-Request-Headers: Content-Type" \
     -X OPTIONS \
     http://localhost:8080/api/health
```

Should return CORS headers:
```
Access-Control-Allow-Origin: http://localhost:3000
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type
```

## Unit Testing

```bash
cd backend

# Run all tests
go test ./...

# Run with coverage
go test -cover ./...

# Run specific package
go test ./service/cash_flow_service/

# Verbose output
go test -v ./...
```

## Integration Testing

### Test Database Connection

```bash
# Test MongoDB connection
./cashlens db connect

# Should output:
# ✅ Database connection successful
# Connection Info:
#   Type:     mongodb
#   Host:     localhost:27017
#   Database: cashlens
#   Status:   connected
```

### Test Full Workflow

```bash
# 1. Add income
./cashlens cash income -c "Salary" -a 5000

# 2. Add expenses
./cashlens cash outcome -c "Food & Dining" -a 45.50 -d "Lunch"
./cashlens cash outcome -c "Transportation" -a 20 -d "Bus fare"

# 3. Query today's transactions
./cashlens cash query -b $(date +%Y-%m-%d)

# 4. Export data
./cashlens manage export -o test_data.xlsx

# 5. Check stats
./cashlens manage stats
```

## Performance Testing

### Load Testing with Apache Bench

```bash
# Install Apache Bench
sudo apt-get install apache2-utils

# Test health endpoint
ab -n 1000 -c 10 http://localhost:8080/api/health

# Test query endpoint
ab -n 100 -c 5 http://localhost:8080/api/cash/date/2024-12-04
```

### Benchmark Tests

```bash
# Run Go benchmarks
go test -bench=. ./...

# With memory profiling
go test -bench=. -benchmem ./...
```

## Troubleshooting

### Database Connection Issues

```bash
# Check if MongoDB is running
docker compose ps

# Check MongoDB logs
docker compose logs mongodb

# Restart MongoDB
docker compose restart mongodb

# Reset database
docker compose down -v
docker compose up -d mongodb
```

### Port Already in Use

```bash
# Find process using port 8080
lsof -i :8080

# Kill process
kill -9 <PID>

# Or use different port
go run main.go server start -p 8081
```

### Build Errors

```bash
# Clean build cache
go clean -cache

# Update dependencies
go mod tidy
go mod download

# Rebuild
go build -o cashlens main.go
```

## Continuous Integration

### GitHub Actions Example

```yaml
name: Backend Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      mongodb:
        image: mongo:7
        env:
          MONGO_INITDB_ROOT_USERNAME: cashlens
          MONGO_INITDB_ROOT_PASSWORD: cashlens123
        ports:
          - 27017:27017
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Go
        uses: actions/setup-go@v4
        with:
          go-version: '1.21'
      
      - name: Run tests
        run: |
          cd backend
          go test -v ./...
      
      - name: Build
        run: |
          cd backend
          go build -o cashlens main.go
```

## Next Steps

1. Implement remaining API endpoints (see [API.md](API.md))
2. Add unit tests for new services
3. Add integration tests for API endpoints
4. Set up CI/CD pipeline
5. Add performance benchmarks

## See Also

- [CLI Reference](CLI.md) - Complete CLI documentation
- [API Reference](API.md) - API implementation tasks
- [Environment Configuration](../../docs/ENVIRONMENT.md) - Configuration guide
- [Docker Setup](../../docs/DOCKER.md) - Docker guide
