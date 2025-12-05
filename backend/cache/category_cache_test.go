package cache

import (
	"testing"

	"github.com/macar-x/cashlens/model"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func TestCategoryCache_SetAndGet(t *testing.T) {
	cache := GetCategoryCache()
	cache.Clear()

	entity := &model.CategoryEntity{
		Id:   primitive.NewObjectID(),
		Name: "TestCategory",
	}

	// Set category
	cache.Set(entity)

	// Get by name
	retrieved, ok := cache.GetByName("TestCategory")
	if !ok {
		t.Error("Expected to find category by name")
	}
	if retrieved.Name != "TestCategory" {
		t.Errorf("Expected name 'TestCategory', got '%s'", retrieved.Name)
	}

	// Get by ID
	retrieved, ok = cache.GetByID(entity.Id.Hex())
	if !ok {
		t.Error("Expected to find category by ID")
	}
	if retrieved.Id != entity.Id {
		t.Error("Expected same ID")
	}
}

func TestCategoryCache_Invalidate(t *testing.T) {
	cache := GetCategoryCache()
	cache.Clear()

	entity := &model.CategoryEntity{
		Id:   primitive.NewObjectID(),
		Name: "TestCategory",
	}

	cache.Set(entity)

	// Verify it's cached
	_, ok := cache.GetByName("TestCategory")
	if !ok {
		t.Error("Expected category to be cached")
	}

	// Invalidate
	cache.Invalidate("TestCategory")

	// Verify it's removed
	_, ok = cache.GetByName("TestCategory")
	if ok {
		t.Error("Expected category to be removed from cache")
	}
}

func TestCategoryCache_Clear(t *testing.T) {
	cache := GetCategoryCache()
	cache.Clear()

	// Add multiple categories
	for i := 0; i < 5; i++ {
		entity := &model.CategoryEntity{
			Id:   primitive.NewObjectID(),
			Name: "Category" + string(rune(i)),
		}
		cache.Set(entity)
	}

	stats := cache.GetStats()
	if stats["size"].(int) != 5 {
		t.Errorf("Expected cache size 5, got %d", stats["size"])
	}

	// Clear cache
	cache.Clear()

	stats = cache.GetStats()
	if stats["size"].(int) != 0 {
		t.Errorf("Expected cache size 0 after clear, got %d", stats["size"])
	}
}

func TestCategoryCache_Stats(t *testing.T) {
	cache := GetCategoryCache()
	cache.Clear()

	entity := &model.CategoryEntity{
		Id:   primitive.NewObjectID(),
		Name: "TestCategory",
	}
	cache.Set(entity)

	// Generate some hits and misses
	cache.GetByName("TestCategory") // hit
	cache.GetByName("TestCategory") // hit
	cache.GetByName("NonExistent")  // miss

	stats := cache.GetStats()

	if stats["hits"].(int64) < 2 {
		t.Errorf("Expected at least 2 hits, got %d", stats["hits"])
	}

	if stats["misses"].(int64) < 1 {
		t.Errorf("Expected at least 1 miss, got %d", stats["misses"])
	}

	hitRate := stats["hit_rate"].(float64)
	if hitRate <= 0 || hitRate > 100 {
		t.Errorf("Expected hit rate between 0 and 100, got %f", hitRate)
	}
}

func TestCategoryCache_Disable(t *testing.T) {
	cache := GetCategoryCache()
	cache.Clear()
	cache.Enable()

	entity := &model.CategoryEntity{
		Id:   primitive.NewObjectID(),
		Name: "TestCategory",
	}
	cache.Set(entity)

	// Disable cache
	cache.Disable()

	// Try to get - should return false
	_, ok := cache.GetByName("TestCategory")
	if ok {
		t.Error("Expected cache to be disabled")
	}

	// Re-enable for other tests
	cache.Enable()
}
