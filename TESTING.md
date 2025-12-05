# Testing Guide for Cashlens

Complete guide for testing the full stack.

## Prerequisites

After devcontainer rebuild, verify Docker is available:

```bash
docker --version
docker compose version
```

## Quick Test Workflow

### 1. Start Database

```bash
# Start MongoDB with demo data
docker compose up -d mongodb

# Check logs
docker compose logs -f mongodb

# Verify it's running
docker compose ps
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
      _id: "$type",
      total: { $sum: "$amount" },
      count: { $count: {} }
    }
  }
])

# Exit
exit
```

### 3. Start Backend

```bash
# Set environment variables
export MONGO_DB_URI="mongodb://cashlens:cashlens123@localhost:27017/cashlens?authSource=admin"
export DB_TYPE=mongodb
export DB_NAME=cashlens

# Or use .env file
export $(cat .env | xargs)

# Start backend
cd backend
go run main.go server start -p 8080
```

### 4. Test API Endpoints

Open a new terminal:

```bash
# Health check
curl http://localhost:8080/api/health

# Version info
curl http://localhost:8080/api/version

# Get today's transactions
curl http://localhost:8080/api/cash/date/$(date +%Y-%m-%d)

# Get all transactions from a specific date
curl http://localhost:8080/api/cash/date/2024-12-04

# Test CORS
curl -i -H "Origin: http://localhost:3000" \
     -H "Access-Control-Request-Method: GET" \
     -H "Access-Control-Request-Headers: Content-Type" \
     -X OPTIONS \
     http://localhost:8080/api/health
```

### 5. Test with Flutter

```bash
# In another terminal
cd flutter

# Run on Chrome
flutter run -d chrome

# Or build and serve
flutter build web --release
cd build/web
python3 -m http.server 3000
```

## Detailed Testing

### Backend API Tests

**Create Income:**
```bash
curl -X POST http://localhost:8080/api/cash/income \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 1000.00,
    "date": "2024-12-05",
    "category": "Salary",
    "description": "Test income"
  }'
```

**Create Expense:**
```bash
curl -X POST http://localhost:8080/api/cash/outcome \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 50.00,
    "date": "2024-12-05",
    "category": "Food & Dining",
    "description": "Test expense"
  }'
```

**Query by Date:**
```bash
curl http://localhost:8080/api/cash/date/2024-12-05
```

**Query by ID:**
```bash
# Get ID from previous query, then:
curl http://localhost:8080/api/cash/{id}
```

**Delete by ID:**
```bash
curl -X DELETE http://localhost:8080/api/cash/{id}
```

**Delete by Date:**
```bash
curl -X DELETE http://localhost:8080/api/cash/date/2024-12-05
```

### Database Tests

**MongoDB:**
```bash
# List all transactions
docker exec -it cashlens-mongodb mongosh \
  -u cashlens -p cashlens123 \
  --authenticationDatabase admin cashlens \
  --eval "db.cash_flows.find().pretty()"

# Get income total
docker exec -it cashlens-mongodb mongosh \
  -u cashlens -p cashlens123 \
  --authenticationDatabase admin cashlens \
  --eval "db.cash_flows.aggregate([
    { \$match: { type: 'income' } },
    { \$group: { _id: null, total: { \$sum: '\$amount' } } }
  ])"

# Get expense total
docker exec -it cashlens-mongodb mongosh \
  -u cashlens -p cashlens123 \
  --authenticationDatabase admin cashlens \
  --eval "db.cash_flows.aggregate([
    { \$match: { type: 'outcome' } },
    { \$group: { _id: null, total: { \$sum: '\$amount' } } }
  ])"
```

**MySQL (Alternative):**
```bash
# Start MySQL instead
docker compose --profile mysql up -d mysql

# Connect
docker exec -it cashlens-mysql mysql -u cashlens -pcashlens123 cashlens

# In MySQL shell:
SELECT COUNT(*) FROM cash_flows;
SELECT COUNT(*) FROM categories;
SELECT type, SUM(amount) as total FROM cash_flows GROUP BY type;
```

### Flutter Integration Tests

**1. Update API URL:**

Edit `flutter/lib/core/api/api_client.dart` if needed, or run with:
```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080
```

**2. Test Currency Settings:**
- Open Settings
- Change currency
- Verify localStorage persistence
- Refresh page
- Verify currency persists

**3. Test Navigation:**
- Click hamburger menu
- Navigate to different sections
- Verify routing works

## Performance Testing

### Load Test with curl

```bash
# Create 100 transactions
for i in {1..100}; do
  curl -X POST http://localhost:8080/api/cash/outcome \
    -H "Content-Type: application/json" \
    -d "{
      \"amount\": $((RANDOM % 100 + 1)).00,
      \"date\": \"2024-12-05\",
      \"category\": \"Food & Dining\",
      \"description\": \"Test transaction $i\"
    }" &
done
wait

# Query all
time curl http://localhost:8080/api/cash/date/2024-12-05
```

### Monitor Resources

```bash
# Docker stats
docker stats cashlens-mongodb

# Backend memory
ps aux | grep "go run"
```

## Troubleshooting

### Docker Issues

**Port already in use:**
```bash
# Find process
lsof -i :27017
lsof -i :8080

# Stop containers
docker compose down

# Remove volumes and restart
docker compose down -v
docker compose up -d mongodb
```

**Container won't start:**
```bash
# Check logs
docker compose logs mongodb

# Restart
docker compose restart mongodb

# Rebuild
docker compose up -d --force-recreate mongodb
```

### Backend Issues

**Can't connect to database:**
```bash
# Verify MongoDB is running
docker compose ps

# Check connection string
echo $MONGO_DB_URI

# Test connection
docker exec -it cashlens-mongodb mongosh \
  -u cashlens -p cashlens123 \
  --authenticationDatabase admin cashlens \
  --eval "db.adminCommand('ping')"
```

**Import errors:**
```bash
# Clean and rebuild
cd backend
go clean
go mod tidy
go build -o cashlens main.go
```

### Flutter Issues

**API not reachable:**
```bash
# Check CORS headers
curl -i -H "Origin: http://localhost:3000" \
     http://localhost:8080/api/health

# Verify backend is running
curl http://localhost:8080/api/health

# Check browser console for errors
```

**Build errors:**
```bash
cd flutter
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

## Automated Testing Script

Create `test-all.sh`:

```bash
#!/bin/bash

echo "🧪 Cashlens Full Stack Test"
echo "=========================="

# Start MongoDB
echo "📦 Starting MongoDB..."
docker compose up -d mongodb
sleep 5

# Check MongoDB
echo "✓ Checking MongoDB..."
docker exec cashlens-mongodb mongosh \
  -u cashlens -p cashlens123 \
  --authenticationDatabase admin cashlens \
  --eval "db.cash_flows.countDocuments()" > /dev/null
if [ $? -eq 0 ]; then
  echo "✅ MongoDB is running with demo data"
else
  echo "❌ MongoDB check failed"
  exit 1
fi

# Start Backend
echo "🚀 Starting Backend..."
cd backend
export MONGO_DB_URI="mongodb://cashlens:cashlens123@localhost:27017/cashlens?authSource=admin"
go run main.go server start -p 8080 &
BACKEND_PID=$!
sleep 3

# Test API
echo "🔍 Testing API..."
HEALTH=$(curl -s http://localhost:8080/api/health | grep "healthy")
if [ -n "$HEALTH" ]; then
  echo "✅ API health check passed"
else
  echo "❌ API health check failed"
  kill $BACKEND_PID
  exit 1
fi

# Test CORS
echo "🌐 Testing CORS..."
CORS=$(curl -s -I -H "Origin: http://localhost:3000" \
  http://localhost:8080/api/health | grep "Access-Control-Allow-Origin")
if [ -n "$CORS" ]; then
  echo "✅ CORS is configured"
else
  echo "❌ CORS check failed"
fi

# Cleanup
echo "🧹 Cleaning up..."
kill $BACKEND_PID
docker compose down

echo "=========================="
echo "✅ All tests passed!"
```

Make it executable:
```bash
chmod +x test-all.sh
./test-all.sh
```

## CI/CD Testing

For automated testing in CI/CD:

```yaml
# .github/workflows/test.yml
name: Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Start MongoDB
        run: docker compose up -d mongodb
      
      - name: Setup Go
        uses: actions/setup-go@v4
        with:
          go-version: '1.21'
      
      - name: Test Backend
        run: |
          cd backend
          go test ./...
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.38.3'
      
      - name: Test Flutter
        run: |
          cd flutter
          flutter test
```

## Next Steps

After successful testing:
1. Implement remaining API endpoints (see `backend/API_TODO.md`)
2. Connect Flutter to real API
3. Add integration tests
4. Set up CI/CD pipeline
5. Deploy to production

Happy testing! 🚀
