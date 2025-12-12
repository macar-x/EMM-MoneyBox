# Cashlens Backend API Test Guide

This guide provides comprehensive testing instructions for all backend endpoints.

## Prerequisites

### 1. Start MongoDB (via Docker)
```bash
docker-compose up -d mongodb
```

### 2. Build and Run Backend
```bash
cd backend
go build -o cashlens .

# Set environment variables (or use defaults)
export DB_TYPE=mongodb
export MONGO_DB_URI="mongodb://cashlens:cashlens123@localhost:27017/cashlens?authSource=admin"
export DB_NAME=cashlens
```

### 3. Start Server
```bash
# CLI: Start server on port 8080
./cashlens server start -p 8080

# Or use go run
go run main.go server start -p 8080
```

---

## Testing Strategy

### Phase 1: Health & Version Check
### Phase 2: Category Management (Setup)
### Phase 3: Cash Flow CRUD Operations
### Phase 4: Advanced Queries (Range, Summary)
### Phase 5: Pagination & Filtering

---

## Phase 1: Health & Version Check

### Test 1.1: Health Check
```bash
curl -X GET http://localhost:8080/api/health
```

**Expected Response:**
```json
{
  "status": "healthy",
  "service": "cashlens-api",
  "message": "API is running"
}
```

### Test 1.2: Version Info
```bash
curl -X GET http://localhost:8080/api/version
```

**Expected Response:**
```json
{
  "version": "1.0.0",
  "name": "Cashlens API",
  "description": "Personal finance management API",
  "endpoints": {
    "cash_flow": [...],
    "category": [...],
    "health": [...]
  }
}
```

---

## Phase 2: Category Management

### Test 2.1: Create Root Category
```bash
curl -X POST http://localhost:8080/api/category \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Food",
    "remark": "All food related expenses"
  }'
```

**Expected Response:**
```json
{
  "id": "507f1f77bcf86cd799439011",
  "message": "category created successfully"
}
```

**Save the returned ID as `CATEGORY_FOOD_ID`**

### Test 2.2: Create Child Category
```bash
curl -X POST http://localhost:8080/api/category \
  -H "Content-Type: application/json" \
  -d '{
    "parent_name": "Food",
    "name": "Restaurants",
    "remark": "Dining out"
  }'
```

### Test 2.3: Create More Categories
```bash
# Salary category for income
curl -X POST http://localhost:8080/api/category \
  -H "Content-Type: application/json" \
  -d '{"name": "Salary", "remark": "Monthly salary"}'

# Transportation category
curl -X POST http://localhost:8080/api/category \
  -H "Content-Type: application/json" \
  -d '{"name": "Transportation", "remark": "Travel expenses"}'
```

### Test 2.4: List All Categories
```bash
curl -X GET "http://localhost:8080/api/category/list?limit=10&offset=0"
```

**Expected Response:**
```json
{
  "data": [
    {
      "id": "...",
      "parent_id": "000000000000000000000000",
      "name": "Food",
      "remark": "All food related expenses",
      "create_time": "...",
      "modify_time": "..."
    },
    ...
  ],
  "total_count": 3,
  "limit": 10,
  "offset": 0
}
```

### Test 2.5: Query Category by ID
```bash
curl -X GET http://localhost:8080/api/category/{CATEGORY_ID}
```

### Test 2.6: Query Category by Name
```bash
curl -X GET http://localhost:8080/api/category/name/Food
```

### Test 2.7: Query Child Categories
```bash
curl -X GET http://localhost:8080/api/category/children/{PARENT_ID}
```

### Test 2.8: Update Category
```bash
curl -X PUT http://localhost:8080/api/category/{CATEGORY_ID} \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Food & Beverages",
    "remark": "Updated description"
  }'
```

**Expected Response:**
```json
{
  "message": "category updated successfully"
}
```

### Test 2.9: Delete Category (Test at End)
```bash
# This should fail if category has transactions
curl -X DELETE http://localhost:8080/api/category/{CATEGORY_ID}
```

---

## Phase 3: Cash Flow CRUD Operations

### Test 3.1: Create Expense (Outcome)
```bash
curl -X POST http://localhost:8080/api/cash/outcome \
  -H "Content-Type: application/json" \
  -d '{
    "belongs_date": "20241201",
    "category_name": "Food",
    "amount": 45.50,
    "description": "Lunch at downtown restaurant"
  }'
```

**Expected Response:**
```json
{
  "id": "507f1f77bcf86cd799439012",
  "category_id": "...",
  "belongs_date": "2024-12-01T00:00:00Z",
  "flow_type": "OUTCOME",
  "amount": 45.5,
  "description": "Lunch at downtown restaurant",
  "remark": "",
  "create_time": "...",
  "modify_time": "..."
}
```

**Save the returned ID as `CASH_FLOW_ID_1`**

### Test 3.2: Create Income
```bash
curl -X POST http://localhost:8080/api/cash/income \
  -H "Content-Type: application/json" \
  -d '{
    "belongs_date": "20241201",
    "category_name": "Salary",
    "amount": 5000.00,
    "description": "December salary"
  }'
```

**Save the returned ID as `CASH_FLOW_ID_2`**

### Test 3.3: Create More Test Data
```bash
# Expense on Dec 2
curl -X POST http://localhost:8080/api/cash/outcome \
  -H "Content-Type: application/json" \
  -d '{
    "belongs_date": "20241202",
    "category_name": "Transportation",
    "amount": 25.00,
    "description": "Taxi to office"
  }'

# Expense on Dec 3
curl -X POST http://localhost:8080/api/cash/outcome \
  -H "Content-Type: application/json" \
  -d '{
    "belongs_date": "20241203",
    "category_name": "Food",
    "amount": 67.80,
    "description": "Grocery shopping"
  }'

# Income on Dec 5
curl -X POST http://localhost:8080/api/cash/income \
  -H "Content-Type: application/json" \
  -d '{
    "belongs_date": "20241205",
    "category_name": "Salary",
    "amount": 500.00,
    "description": "Bonus payment"
  }'
```

### Test 3.4: Query by ID
```bash
curl -X GET http://localhost:8080/api/cash/{CASH_FLOW_ID_1}
```

### Test 3.5: Query by Date
```bash
curl -X GET http://localhost:8080/api/cash/date/20241201
```

**Expected Response:**
```json
[
  {
    "id": "...",
    "flow_type": "OUTCOME",
    "amount": 45.5,
    "description": "Lunch at downtown restaurant",
    ...
  },
  {
    "id": "...",
    "flow_type": "INCOME",
    "amount": 5000.0,
    "description": "December salary",
    ...
  }
]
```

### Test 3.6: Update Cash Flow
```bash
curl -X PUT http://localhost:8080/api/cash/{CASH_FLOW_ID_1} \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 50.00,
    "description": "Lunch at downtown restaurant (updated)"
  }'
```

**Expected Response:**
```json
{
  "id": "...",
  "amount": 50.0,
  "description": "Lunch at downtown restaurant (updated)",
  ...
}
```

### Test 3.7: Delete by ID
```bash
curl -X DELETE http://localhost:8080/api/cash/{CASH_FLOW_ID}
```

### Test 3.8: Delete by Date
```bash
curl -X DELETE http://localhost:8080/api/cash/date/20241210
```

---

## Phase 4: Advanced Queries

### Test 4.1: Date Range Query
```bash
curl -X GET "http://localhost:8080/api/cash/range?from=20241201&to=20241205"
```

**Expected Response:**
```json
[
  {
    "id": "...",
    "belongs_date": "2024-12-01T00:00:00Z",
    "amount": 50.0,
    ...
  },
  {
    "id": "...",
    "belongs_date": "2024-12-02T00:00:00Z",
    "amount": 25.0,
    ...
  },
  ...
]
```

### Test 4.2: Daily Summary
```bash
curl -X GET http://localhost:8080/api/cash/summary/daily/20241201
```

**Expected Response:**
```json
{
  "total_income": 5000.0,
  "total_expense": 50.0,
  "balance": 4950.0,
  "transaction_count": 2,
  "category_breakdown": {
    "Food": 50.0,
    "Salary": 5000.0
  }
}
```

### Test 4.3: Monthly Summary
```bash
curl -X GET http://localhost:8080/api/cash/summary/monthly/202412
```

**Expected Response:**
```json
{
  "total_income": 5500.0,
  "total_expense": 142.8,
  "balance": 5357.2,
  "transaction_count": 5,
  "category_breakdown": {
    "Food": 117.8,
    "Transportation": 25.0,
    "Salary": 5500.0
  }
}
```

### Test 4.4: Yearly Summary
```bash
curl -X GET http://localhost:8080/api/cash/summary/yearly/2024
```

---

## Phase 5: Pagination & Filtering

### Test 5.1: List All Cash Flows (Paginated)
```bash
curl -X GET "http://localhost:8080/api/cash/list?limit=10&offset=0"
```

**Expected Response:**
```json
{
  "data": [
    {
      "id": "...",
      "belongs_date": "2024-12-05T00:00:00Z",
      "flow_type": "INCOME",
      "amount": 500.0,
      ...
    },
    ...
  ],
  "total_count": 5,
  "limit": 10,
  "offset": 0
}
```

### Test 5.2: Filter by Type (Income Only)
```bash
curl -X GET "http://localhost:8080/api/cash/list?type=INCOME&limit=10&offset=0"
```

**Expected Response:**
```json
{
  "data": [
    {
      "flow_type": "INCOME",
      "amount": 500.0,
      ...
    },
    {
      "flow_type": "INCOME",
      "amount": 5000.0,
      ...
    }
  ],
  "total_count": 5,
  "limit": 10,
  "offset": 0
}
```

### Test 5.3: Filter by Type (Expenses Only)
```bash
curl -X GET "http://localhost:8080/api/cash/list?type=OUTCOME&limit=10&offset=0"
```

### Test 5.4: Pagination - Second Page
```bash
curl -X GET "http://localhost:8080/api/cash/list?limit=2&offset=2"
```

---

## CLI Testing (Alternative to API)

### Category Commands
```bash
# Create category
./cashlens category create -n "Food" -r "Food expenses"

# Query category
./cashlens category query -n "Food"

# Update category
./cashlens category update -i {CATEGORY_ID} -n "Food & Drinks"

# Delete category
./cashlens category delete -i {CATEGORY_ID}

# List categories
./cashlens category list
```

### Cash Flow Commands
```bash
# Create income
./cashlens cash income -c "Salary" -a 5000 -d "20241201" -e "Monthly salary"

# Create expense
./cashlens cash outcome -c "Food" -a 45.50 -d "20241201" -e "Lunch"

# Query by ID
./cashlens cash query -i {CASH_FLOW_ID}

# Query by date
./cashlens cash query -d "20241201"

# Update
./cashlens cash update -i {CASH_FLOW_ID} -a 50.00

# Delete by ID
./cashlens cash delete -i {CASH_FLOW_ID}

# Delete by date
./cashlens cash delete -d "20241201"

# Range query
./cashlens cash range -f "20241201" -t "20241231"

# Summaries
./cashlens cash summary --type daily -d "20241201"
./cashlens cash summary --type monthly -m "202412"
./cashlens cash summary --type yearly -y "2024"

# List all
./cashlens cash list
```

---

## Test Results Checklist

- [ ] Health endpoint returns 200 OK
- [ ] Version endpoint lists all endpoints
- [ ] Category creation works
- [ ] Category listing with pagination works
- [ ] Category update works
- [ ] Income creation works
- [ ] Expense creation works
- [ ] Cash flow query by ID works
- [ ] Cash flow query by date works
- [ ] Cash flow date range query works
- [ ] Cash flow update works
- [ ] Daily summary calculates correctly
- [ ] Monthly summary calculates correctly
- [ ] Yearly summary calculates correctly
- [ ] Pagination returns correct limits
- [ ] Type filtering (INCOME/OUTCOME) works
- [ ] Delete operations work
- [ ] Error handling returns proper messages

---

## Common Issues & Solutions

### Issue: "category does not exist"
**Solution:** Create the category first using the category API

### Issue: "cash_flow not found"
**Solution:** Verify the ID is correct, use list endpoint to find valid IDs

### Issue: Connection refused
**Solution:** Ensure server is running and MongoDB is accessible

### Issue: "invalid date format"
**Solution:** Use YYYYMMDD format (e.g., 20241201)

### Issue: Update returns "failed to update"
**Solution:** Verify the record exists and all required fields are provided

---

## Performance Testing

### Load Test - Create 100 Transactions
```bash
for i in {1..100}; do
  curl -X POST http://localhost:8080/api/cash/outcome \
    -H "Content-Type: application/json" \
    -d "{
      \"belongs_date\": \"20241201\",
      \"category_name\": \"Food\",
      \"amount\": $((RANDOM % 100 + 1)),
      \"description\": \"Test transaction $i\"
    }" &
done
wait
```

### Pagination Performance Test
```bash
# Test with large offset
curl -X GET "http://localhost:8080/api/cash/list?limit=20&offset=500"
```

---

## Expected Database State After Tests

After running all tests successfully, your database should contain:

**Categories:**
- Food / Food & Beverages (updated)
- Restaurants (child of Food)
- Salary
- Transportation

**Cash Flows:**
- ~5 transactions (if none deleted)
- Mix of INCOME and OUTCOME types
- Dates ranging from Dec 1-5, 2024
- Total income: ~5500
- Total expenses: ~143

---

## Next Steps

1. Run through all tests systematically
2. Verify expected responses match actual responses
3. Test error cases (invalid IDs, missing fields, etc.)
4. Document any issues found
5. Ready for Flutter integration!

---

## API Documentation Summary

For a complete list of available endpoints, hit:
```bash
curl http://localhost:8080/api/version | jq .endpoints
```

This returns all 21+ endpoints organized by category.
