package category_service

import (
	"errors"

	"github.com/macar-x/cashlens/mapper/category_mapper"
)

// UpdateService updates a category by ID
func UpdateService(plainId, parentPlainId, categoryName string) error {
	if plainId == "" {
		return errors.New("id cannot be empty")
	}

	// Query existing category
	existingCategory := category_mapper.INSTANCE.GetCategoryByObjectId(plainId)
	if existingCategory.IsEmpty() {
		return errors.New("category not found")
	}

	// Validate parent if provided
	if parentPlainId != "" {
		parentCategory := category_mapper.INSTANCE.GetCategoryByObjectId(parentPlainId)
		if parentCategory.IsEmpty() {
			return errors.New("parent category does not exist")
		}
		// Prevent circular reference
		if parentPlainId == plainId {
			return errors.New("category cannot be its own parent")
		}
	}

	// Note: Similar to cash_flow update, the mapper's UpdateCategoryByEntity
	// doesn't accept the updated entity fields
	// TODO: Enhance mapper to accept updated entity fields

	return errors.New("category update functionality requires mapper enhancement - mapper.UpdateCategoryByEntity needs to accept entity parameter")
}
