# Cashlens Refactoring & Performance Enhancement Roadmap

**Version**: 1.1  
**Last Updated**: December 5, 2024  
**Status**: Phase 1 Complete, Phase 2-3 In Progress

## Overview

This document provides a comprehensive roadmap for refactoring and performance enhancements to the Cashlens backend. The roadmap is organized into phases with clear priorities, estimated effort, and expected impact.

## Current State Assessment

### Strengths ✅
- Clear separation of concerns (Command → Service → Mapper → Database)
- Database abstraction supporting MongoDB and MySQL
- Interface-based mapper design
- Structured logging with Zap
- Well-organized CLI with Cobra
- All 23 CLI commands implemented (15 fully functional, 8 awaiting mapper enhancements)

### Critical Issues 🔴
1. **Performance**: Date range queries use N queries instead of 1
2. **Performance**: No connection pooling (connection overhead on every operation)
3. **Performance**: No database indexes (full collection scans)
4. **Code Quality**: No validation layer
5. **Code Quality**: No unit tests
6. **Architecture**: No context propagation for cancellation/timeout

### Medium Issues 🟡
1. Inconsistent error handling patterns
2. No dependency injection
3. No graceful shutdown
4. No retry logic or circuit breaker
5. Summary calculations in memory instead of database aggregation

## Progress Summary

### Completed (December 5, 2024)
- ✅ Phase 1.1: Database Indexes
- ✅ Phase 1.2: Date Range Query Optimization
- ✅ Phase 1.3: Constants (Previously completed)
- ✅ Phase 3.1: Validation Layer
- ✅ Phase 3.2: Error Handling Standardization

### In Progress
- 🔄 Phase 3.3: Unit Testing (validation and errors complete)

### Pending
- Phase 2.1: Connection Pooling
- Phase 2.2: Category Caching
- Phase 2.3: Batch Operations
- Phase 3.3: Full Unit Test Coverage
- Phase 3.4: Integration Testing
- Phase 4.1: Context Propagation
- Phase 4.2: Dependency Injection
- Phase 4.3: Graceful Shutdown
- Phase 4.4: Structured Logging Standards
- Phase 5: Resilience & Monitoring
- Phase 6: Advanced Features

## Roadmap Phases

### Phase 1: Quick Wins & Critical Performance (1-2 weeks)

**Goal**: Address critical performance bottlenecks with minimal code changes

#### 1.1 Database Indexes (High Impact, Low Effort) ✅ COMPLETED

**Tasks**:
- [x] Create index on `cash_flow.belongs_date`
- [x] Create index on `cash_flow.flow_type`
- [x] Create compound index on `cash_flow(belongs_date, flow_type)`
- [x] Create unique index on `category.name`
- [x] Create migration script for index creation
- [x] Document index strategy
- [x] Add CLI command `cashlens manage indexes`

**Expected Impact**:
- Date queries: 100x faster
- Type filtering: 50x faster
- Category lookups: 10x faster

**Implementation**:
```javascript
// backend/migrations/001_add_indexes.js
db.cash_flow.createIndex({ "belongs_date": 1 })
db.cash_flow.createIndex({ "flow_type": 1 })
db.cash_flow.createIndex({ "belongs_date": 1, "flow_type": 1 })
db.category.createIndex({ "name": 1 }, { unique: true })
```

#### 1.2 Optimize Date Range Queries (High Impact, Medium Effort) ✅ COMPLETED

**Tasks**:
- [x] Add `GetCashFlowsByDateRange(from, to)` to mapper interface
- [x] Implement in MongoDB mapper using `$gte` and `$lte`
- [x] Implement in MySQL mapper using `BETWEEN`
- [x] Update `QueryByDateRange` service to use new method
- [x] Add tests for date range queries
- [x] Add validation for date range inputs

**Current**:
```go
// N queries (one per day)
for !currentDate.After(to) {
    dayResults := mapper.GetCashFlowsByBelongsDate(currentDate)
    results = append(results, dayResults...)
    currentDate = currentDate.AddDate(0, 0, 1)
}
```

**After**:
```go
// 1 query
results := mapper.GetCashFlowsByDateRange(from, to)
```

**Expected Impact**:
- 30-day range: 30 queries → 1 query (30x faster)
- 365-day range: 365 queries → 1 query (365x faster)

#### 1.3 Add Constants (Completed ✅)

**Status**: DONE
- ✅ Created `model/constants.go`
- ✅ Added FlowType, DateFormat, TableName constants
- ✅ Updated 5 files to use constants

---

### Phase 2: Connection Management & Caching (2-3 weeks)

**Goal**: Reduce connection overhead and add caching for frequently accessed data

#### 2.1 Connection Pooling (High Impact, Medium Effort)

**Tasks**:
- [ ] Refactor MongoDB connection to use connection pool
- [ ] Refactor MySQL connection to use connection pool
- [ ] Add pool configuration (min/max connections, timeout)
- [ ] Add connection health checks
- [ ] Add connection metrics (active, idle, wait time)
- [ ] Update all mappers to use pooled connections

**Configuration**:
```go
type PoolConfig struct {
    MinConnections int
    MaxConnections int
    MaxIdleTime    time.Duration
    ConnectTimeout time.Duration
}
```

**Expected Impact**:
- Connection overhead: 50ms → 5ms (10x faster)
- Support for concurrent requests
- Better resource utilization

#### 2.2 Category Caching (Medium Impact, Low Effort)

**Tasks**:
- [ ] Add in-memory cache for categories
- [ ] Implement cache invalidation on create/update/delete
- [ ] Add cache TTL configuration
- [ ] Add cache hit/miss metrics
- [ ] Consider Redis for distributed caching (future)

**Implementation**:
```go
type CategoryCache struct {
    cache map[string]*model.CategoryEntity
    mu    sync.RWMutex
    ttl   time.Duration
}
```

**Expected Impact**:
- Category lookups: 5ms → 0.1ms (50x faster)
- Reduced database load
- Better summary calculation performance

#### 2.3 Batch Operations (Medium Impact, Medium Effort)

**Tasks**:
- [ ] Add `BulkInsertCashFlows(entities)` to mapper interface
- [ ] Implement in MongoDB mapper using `insertMany`
- [ ] Implement in MySQL mapper using batch insert
- [ ] Update import service to use bulk insert
- [ ] Add batch size configuration

**Expected Impact**:
- Import 100 records: 5s → 0.5s (10x faster)
- Reduced transaction overhead
- Better import performance

---

### Phase 3: Code Quality & Testing (3-4 weeks)

**Goal**: Improve code quality, add tests, and standardize patterns

#### 3.1 Validation Layer (Medium Impact, Medium Effort) ✅ COMPLETED

**Tasks**:
- [x] Create validation package
- [x] Add validators for common types (ID, date, amount, etc.)
- [x] Add validation in service layer
- [x] Add custom error types for validation failures
- [x] Create comprehensive test suite (50+ tests)
- [ ] Add validation middleware for API (deferred)
- [ ] Apply validation to all service methods (in progress)

**Structure**:
```go
package validation

type Validator interface {
    Validate(value interface{}) error
}

type IDValidator struct{}
type DateValidator struct{}
type AmountValidator struct{}
type CategoryNameValidator struct{}
```

#### 3.2 Error Handling Standardization (Medium Impact, Low Effort) ✅ COMPLETED

**Tasks**:
- [x] Create error package with standard error types
- [x] Implement error wrapping with context
- [x] Add error codes for API responses
- [x] Create comprehensive test suite
- [ ] Standardize error logging (in progress)
- [ ] Add error recovery middleware (deferred)

**Error Types**:
```go
type ErrorCode string

const (
    ErrNotFound      ErrorCode = "NOT_FOUND"
    ErrInvalidInput  ErrorCode = "INVALID_INPUT"
    ErrDatabase      ErrorCode = "DATABASE_ERROR"
    ErrUnauthorized  ErrorCode = "UNAUTHORIZED"
)

type AppError struct {
    Code    ErrorCode
    Message string
    Cause   error
}
```

#### 3.3 Unit Testing (High Impact, High Effort)

**Tasks**:
- [ ] Add unit tests for all services (target: 80% coverage)
- [ ] Add unit tests for all mappers
- [ ] Add unit tests for utilities
- [ ] Set up test fixtures and helpers
- [ ] Add table-driven tests for edge cases
- [ ] Set up CI/CD for automated testing

**Test Structure**:
```
backend/
├── service/
│   └── cash_flow_service/
│       ├── income.go
│       └── income_test.go
├── mapper/
│   └── cash_flow_mapper/
│       ├── mongodb.go
│       └── mongodb_test.go
└── test/
    ├── fixtures/
    └── helpers/
```

#### 3.4 Integration Testing (Medium Impact, High Effort)

**Tasks**:
- [ ] Add integration tests for CLI commands
- [ ] Add integration tests for API endpoints
- [ ] Add integration tests for database operations
- [ ] Set up test database (Docker)
- [ ] Add end-to-end test scenarios

---

### Phase 4: Modern Patterns & Architecture (4-6 weeks)

**Goal**: Adopt modern Go patterns and improve architecture

#### 4.1 Context Propagation (Medium Impact, Medium Effort)

**Tasks**:
- [ ] Add context parameter to all service methods
- [ ] Add context parameter to all mapper methods
- [ ] Implement timeout handling
- [ ] Implement cancellation handling
- [ ] Add context-aware logging

**Before**:
```go
func SaveIncome(date, category string, amount float64, desc string) error
```

**After**:
```go
func SaveIncome(ctx context.Context, date, category string, amount float64, desc string) error
```

#### 4.2 Dependency Injection (Medium Impact, High Effort)

**Tasks**:
- [ ] Refactor services to use constructor injection
- [ ] Refactor mappers to use constructor injection
- [ ] Remove global singletons
- [ ] Add DI container (wire or dig)
- [ ] Update CLI commands to use DI

**Before**:
```go
// Global singleton
cash_flow_mapper.INSTANCE.GetCashFlowByObjectId(id)
```

**After**:
```go
type CashFlowService struct {
    mapper CashFlowMapper
    logger *zap.Logger
}

func NewCashFlowService(mapper CashFlowMapper, logger *zap.Logger) *CashFlowService {
    return &CashFlowService{mapper: mapper, logger: logger}
}
```

#### 4.3 Graceful Shutdown (Low Impact, Low Effort)

**Tasks**:
- [ ] Add signal handling (SIGTERM, SIGINT)
- [ ] Implement graceful server shutdown
- [ ] Close database connections on shutdown
- [ ] Wait for in-flight requests to complete
- [ ] Add shutdown timeout configuration

**Implementation**:
```go
func (s *Server) Shutdown(ctx context.Context) error {
    // Stop accepting new requests
    // Wait for in-flight requests
    // Close database connections
    // Cleanup resources
}
```

#### 4.4 Structured Logging Standards (Low Impact, Medium Effort)

**Tasks**:
- [ ] Standardize log levels across codebase
- [ ] Add structured fields to all logs
- [ ] Add request ID/correlation ID
- [ ] Add log sampling for high-volume logs
- [ ] Add log aggregation configuration

**Standard Fields**:
```go
logger.Info("operation completed",
    zap.String("operation", "save_income"),
    zap.String("user_id", userID),
    zap.String("request_id", requestID),
    zap.Duration("duration", elapsed),
    zap.Error(err),
)
```

---

### Phase 5: Resilience & Monitoring (4-6 weeks)

**Goal**: Add resilience patterns and monitoring capabilities

#### 5.1 Retry Logic (Medium Impact, Medium Effort)

**Tasks**:
- [ ] Add retry package with exponential backoff
- [ ] Add retry for database operations
- [ ] Add retry for external API calls
- [ ] Add retry configuration (max attempts, backoff)
- [ ] Add retry metrics

**Implementation**:
```go
type RetryConfig struct {
    MaxAttempts int
    InitialDelay time.Duration
    MaxDelay time.Duration
    Multiplier float64
}

func WithRetry(ctx context.Context, config RetryConfig, fn func() error) error
```

#### 5.2 Circuit Breaker (Medium Impact, Medium Effort)

**Tasks**:
- [ ] Add circuit breaker package
- [ ] Add circuit breaker for database calls
- [ ] Add circuit breaker configuration
- [ ] Add circuit breaker state monitoring
- [ ] Add circuit breaker metrics

**States**: Closed → Open → Half-Open → Closed

#### 5.3 Metrics & Monitoring (High Impact, High Effort)

**Tasks**:
- [ ] Add Prometheus metrics
- [ ] Add metrics for all operations (count, duration, errors)
- [ ] Add database metrics (connections, queries, latency)
- [ ] Add business metrics (transactions, categories, summaries)
- [ ] Create Grafana dashboards

**Metrics**:
```go
var (
    cashFlowCreated = prometheus.NewCounterVec(...)
    queryDuration = prometheus.NewHistogramVec(...)
    dbConnections = prometheus.NewGaugeVec(...)
)
```

#### 5.4 Health Checks (Low Impact, Low Effort)

**Tasks**:
- [ ] Enhance health check endpoint
- [ ] Add database health check
- [ ] Add dependency health checks
- [ ] Add readiness vs liveness probes
- [ ] Add health check metrics

**Response**:
```json
{
  "status": "healthy",
  "checks": {
    "database": "healthy",
    "cache": "healthy"
  },
  "uptime": "24h30m",
  "version": "1.0.0"
}
```

---

### Phase 6: Advanced Features (Future)

**Goal**: Add advanced features for production readiness

#### 6.1 Database Migrations

**Tasks**:
- [ ] Add migration framework (golang-migrate)
- [ ] Create migration scripts for schema changes
- [ ] Add rollback support
- [ ] Add migration versioning
- [ ] Document migration process

#### 6.2 API Rate Limiting

**Tasks**:
- [ ] Add rate limiting middleware
- [ ] Add per-user rate limits
- [ ] Add per-endpoint rate limits
- [ ] Add rate limit headers
- [ ] Add rate limit metrics

#### 6.3 Authentication & Authorization

**Tasks**:
- [ ] Add JWT authentication
- [ ] Add user management
- [ ] Add role-based access control
- [ ] Add API key authentication
- [ ] Add OAuth2 support

#### 6.4 Distributed Caching

**Tasks**:
- [ ] Add Redis integration
- [ ] Migrate category cache to Redis
- [ ] Add cache warming
- [ ] Add cache invalidation strategies
- [ ] Add cache metrics

---

## Implementation Guidelines

### Code Review Checklist

Before merging any refactoring PR:
- [ ] All tests pass
- [ ] Code coverage maintained or improved
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
- [ ] Performance benchmarks run
- [ ] Error handling reviewed
- [ ] Logging added appropriately

### Testing Strategy

1. **Unit Tests**: Test individual functions in isolation
2. **Integration Tests**: Test component interactions
3. **End-to-End Tests**: Test complete user workflows
4. **Performance Tests**: Benchmark critical paths
5. **Load Tests**: Test under high concurrency

### Performance Benchmarking

Run benchmarks before and after changes:
```bash
go test -bench=. -benchmem ./...
```

Track metrics:
- Operations per second
- Memory allocations
- Latency (p50, p95, p99)

### Migration Strategy

1. **Backward Compatibility**: Maintain during transition
2. **Feature Flags**: Enable gradual rollout
3. **Monitoring**: Watch metrics during migration
4. **Rollback Plan**: Have rollback strategy ready

---

## Priority Matrix

### High Priority (Do First)
1. Database indexes (Phase 1.1)
2. Date range query optimization (Phase 1.2)
3. Connection pooling (Phase 2.1)
4. Unit testing (Phase 3.3)

### Medium Priority (Do Next)
5. Category caching (Phase 2.2)
6. Validation layer (Phase 3.1)
7. Error handling (Phase 3.2)
8. Context propagation (Phase 4.1)

### Low Priority (Do Later)
9. Batch operations (Phase 2.3)
10. Dependency injection (Phase 4.2)
11. Graceful shutdown (Phase 4.3)
12. Retry logic (Phase 5.1)

---

## Success Metrics

### Performance Targets
- Date range queries: < 100ms for 30-day range
- Category lookups: < 1ms (cached)
- API response time: p95 < 200ms
- Database connection time: < 10ms

### Quality Targets
- Test coverage: > 80%
- Code duplication: < 5%
- Cyclomatic complexity: < 15
- Documentation coverage: 100% for public APIs

### Reliability Targets
- Uptime: > 99.9%
- Error rate: < 0.1%
- Database connection success: > 99.9%
- Cache hit rate: > 90%

---

## Resources

### Documentation
- [Go Best Practices](https://golang.org/doc/effective_go)
- [MongoDB Performance](https://docs.mongodb.com/manual/administration/analyzing-mongodb-performance/)
- [Testing in Go](https://golang.org/pkg/testing/)

### Tools
- [golangci-lint](https://golangci-lint.run/) - Linting
- [go-migrate](https://github.com/golang-migrate/migrate) - Migrations
- [testify](https://github.com/stretchr/testify) - Testing
- [wire](https://github.com/google/wire) - Dependency injection
- [prometheus](https://prometheus.io/) - Metrics

### References
- Current implementation: `backend/`
- Analysis document: `docs/ona/20241205_SESSION_REFACTORING_ANALYSIS.md`
- TODO list: `docs/TODO.md`

---

## Conclusion

This roadmap provides a structured approach to refactoring and performance enhancement. The phases are designed to deliver incremental value while maintaining system stability.

**Key Principles**:
1. **Measure First**: Benchmark before optimizing
2. **Incremental Changes**: Small, testable improvements
3. **Backward Compatibility**: Don't break existing functionality
4. **Test Everything**: Maintain high test coverage
5. **Document Changes**: Keep documentation up to date

**Next Steps**:
1. Review and approve roadmap
2. Create GitHub issues for Phase 1 tasks
3. Assign owners and set deadlines
4. Begin implementation with Phase 1.1 (Database Indexes)

---

**Roadmap Version**: 1.1  
**Last Updated**: December 5, 2024  
**Status**: Phase 1 Complete - 40% of High Priority Items Done

**Recent Session**: [CLI Refactoring Session](ona/20241205_SESSION_CLI_REFACTORING.md)
