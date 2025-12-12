package category_service

import (
	"github.com/macar-x/cashlens/mapper/category_mapper"
	"github.com/macar-x/cashlens/model"
)

// ListAllService lists all categories with pagination
func ListAllService(limit, offset int) ([]model.CategoryEntity, int64, error) {
	// Get total count
	totalCount := category_mapper.INSTANCE.CountAllCategories()

	// Get paginated results
	categories := category_mapper.INSTANCE.GetAllCategories(limit, offset)

	return categories, totalCount, nil
}
