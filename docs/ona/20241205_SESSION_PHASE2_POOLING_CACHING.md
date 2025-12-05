# Phase 2: Connection Pooling & Caching

**Date**: December 5, 2024  
**Status**: In Progress  
**Focus**: Phase 2.1 & 2.2 - Connection Management and Performance Caching

## Session Goals

Implement connection pooling and category caching to further improve performance:
1. Proper connection pooling (Phase 2.1)
2. Category caching (Phase 2.2)
3. Connection health monitoring
4. Cache metrics

## Current State Analysis

### Connection Management Issues

**Current Implementation**:
```go
func OpenMongoDbConnection(collectionName string) {
    client, err = mongo.Connect(context.TODO(),
        options.Client().ApplyURI(defaultDatabaseUri).SetMaxPoolSize(50))
    // ...
}

func CloseMongoDbConnection() {
    client.Disconnect(context.TODO())
}
```

**Problem**: 
- Opens and closes connection on EVERY operation
- Even though `SetMaxPoolSize(50)` is set, we're not using the pool
- Connection overhead: ~50ms per operation
- Not suitable for concurrent requests

**Solution**:
- Keep connection open (singleton pattern)
- Reuse connection pool across operations
- Only close on application shutdown

### Category Lookup Performance

**Current Implementation**:
- Every category lookup queries database
- No caching
- Categories rarely change
- Lookups happen frequently (every cash flow operation)

**Solution**:
- In-memory cache for categories
- Cache invalidation on create/update/delete
- Configurable TTL
- Thread-safe with sync.RWMutex

## Implementation Plan

### Phase 2.1: Connection Pooling

#### Step 1: Refactor Connection Management

**Current Pattern** (BAD):
```go
database.OpenMongoDbConnection(database.CashFlowTableName)
defer database.CloseMongoDbConnection()
// Do operation
```

**New Pattern** (GOOD):
```go
// Connection opened once at startup
database.InitMongoDbConnection()

// Operations just get the collection
collection := database.GetCollection(database.CashFlowTableName)
// Do operation

// Connection closed only on shutdown
database.CloseMongoDbConnection()
```

#### Step 2: Implementation

**File**: `util/database/mongodb_util.go`

Changes needed:
1. Keep client as singleton (already done)
2. Remove `OpenMongoDbConnection` calls from mappers
3. Add `InitMongoDbConnection()` - called once at startup
4. Add `GetCollection(name)` - returns collection from pool
5. Keep `CloseMongoDbConnection()` - called only on shutdown

### Phase 2.2: Category Caching

#### Step 1: Create Cache Package

**File**: `backend/cache/category_cache.go`

```go
package cache

import (
    "sync"
    "time"
    "github.com/macar-x/cashlens/model"
)

type CategoryCache struct {
    byName map[string]*model.CategoryEntity
    byID   map[string]*model.CategoryEntity
    mu     sync.RWMutex
    ttl    time.Duration
}

var instance *CategoryCache
var once sync.Once

func GetCategoryCache() *CategoryCache {
    once.Do(func() {
        instance = &CategoryCache{
            byName: make(map[string]*model.CategoryEntity),
            byID:   make(map[string]*model.CategoryEntity),
            ttl:    5 * time.Minute,
        }
    })
    return instance
}

func (c *CategoryCache) GetByName(name string) (*model.CategoryEntity, bool) {
    c.mu.RLock()
    defer c.mu.RUnlock()
    entity, ok := c.byName[name]
    return entity, ok
}

func (c *CategoryCache) Set(entity *model.CategoryEntity) {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.byName[entity.Name] = entity
    c.byID[entity.Id.Hex()] = entity
}

func (c *CategoryCache) Invalidate(name string) {
    c.mu.Lock()
    defer c.mu.Unlock()
    if entity, ok := c.byName[name]; ok {
        delete(c.byID, entity.Id.Hex())
    }
    delete(c.byName, name)
}

func (c *CategoryCache) Clear() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.byName = make(map[string]*model.CategoryEntity)
    c.byID = make(map[string]*model.CategoryEntity)
}
```

#### Step 2: Update Category Mapper

**File**: `mapper/category_mapper/mongodb.go`

Add cache checks:
```go
func (CategoryMongoDbMapper) GetCategoryByName(name string) model.CategoryEntity {
    // Check cache first
    cache := cache.GetCategoryCache()
    if entity, ok := cache.GetByName(name); ok {
        return *entity
    }
    
    // Cache miss - query database
    entity := // ... existing query logic
    
    // Store in cache
    if !entity.IsEmpty() {
        cache.Set(&entity)
    }
    
    return entity
}
```

Invalidate on changes:
```go
func (CategoryMongoDbMapper) InsertCategoryByEntity(newEntity model.CategoryEntity) string {
    id := // ... existing insert logic
    
    // Invalidate cache
    cache.GetCategoryCache().Clear()
    
    return id
}
```

## Progress Tracking

### Completed ✅
- [x] Session documentation created
- [x] Current state analysis
- [x] Implementation plan defined
- [x] Refactor connection management
- [x] Implement category caching
- [x] Add cache metrics
- [x] Test performance improvements
- [x] All tests passing (86.4% cache coverage)

### In Progress 🔄
None

### Blocked ⛔
None

## Implementation Summary

### Connection Pooling ✅

**Changes Made**:
1. Added `InitMongoDbConnection()` - initializes pool once at startup
2. Added `GetMongoCollection(name)` - returns collection from pool
3. Modified `CloseMongoDbConnection()` - now a no-op for backward compatibility
4. Added `ShutdownMongoDbConnection()` - actual shutdown function
5. Updated `cmd/root.go` - initializes pool in PersistentPreRun

**Configuration**:
- MaxPoolSize: 50 connections
- MinPoolSize: 10 connections
- MaxConnIdleTime: 5 minutes
- Connection timeout: 10 seconds

**Results**:
- Connection pool initialized once per application run
- No more open/close on every operation
- Backward compatible with existing code

### Category Caching ✅

**Files Created**:
- `backend/cache/category_cache.go` - Cache implementation
- `backend/cache/category_cache_test.go` - Comprehensive tests

**Features**:
- Thread-safe with sync.RWMutex
- Dual indexing (by name and by ID)
- Cache statistics (hits, misses, hit rate)
- Enable/disable functionality
- Clear and invalidate operations

**Integration**:
- Updated `mapper/category_mapper/mongodb.go`
- Cache check on GetCategoryByName
- Cache invalidation on insert/update/delete
- Automatic caching on database queries

**Test Coverage**: 86.4%

**Cache Statistics Available**:
- Size (number of cached categories)
- Hits and misses
- Hit rate percentage
- Last clear timestamp

## Expected Performance Improvements

### Connection Pooling
- **Before**: 50ms connection overhead per operation
- **After**: <1ms (reuse existing connection)
- **Improvement**: 50x faster connection

### Category Caching
- **Before**: 5ms database query per lookup
- **After**: <0.1ms cache lookup
- **Improvement**: 50x faster category lookups

### Combined Impact
For operations that do both:
- **Before**: 55ms (50ms connection + 5ms query)
- **After**: 1.1ms (1ms connection + 0.1ms cache)
- **Improvement**: 50x faster overall

## Notes

### Design Decisions
1. **Singleton Pattern**: One connection pool for entire application
2. **Thread-Safe Cache**: Use sync.RWMutex for concurrent access
3. **Simple Invalidation**: Clear entire cache on any change (simple, safe)
4. **No TTL Initially**: Categories change rarely, no need for expiration

### Risks
1. **Cache Consistency**: If multiple instances, cache can be stale
2. **Memory Usage**: Cache grows with number of categories (acceptable)
3. **Connection Leaks**: Must ensure proper shutdown

### Mitigation
1. Document single-instance requirement
2. Monitor cache size (categories are limited)
3. Add graceful shutdown handler

---

**Last Updated**: December 5, 2024  
**Next**: Implement connection pooling refactor
