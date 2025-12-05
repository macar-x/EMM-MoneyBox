package cash_flow_service

import (
	"errors"
	"time"

	"github.com/macar-x/cashlens/mapper/cash_flow_mapper"
	"github.com/macar-x/cashlens/mapper/category_mapper"
	"github.com/macar-x/cashlens/model"
	"github.com/macar-x/cashlens/util"
	"github.com/shopspring/decimal"
)

// UpdateById updates a cash flow record by ID
func UpdateById(plainId, belongsDate, categoryName string, amount float64, description string) (model.CashFlowEntity, error) {
	if plainId == "" {
		return model.CashFlowEntity{}, errors.New("id cannot be empty")
	}

	// Query existing record
	existingEntity := cash_flow_mapper.INSTANCE.GetCashFlowByObjectId(plainId)
	if existingEntity.IsEmpty() {
		return model.CashFlowEntity{}, errors.New("cash_flow not found")
	}

	// Update fields that are provided
	if belongsDate != "" {
		date := util.FormatDateFromStringWithoutDash(belongsDate)
		if date.IsZero() {
			return model.CashFlowEntity{}, errors.New("invalid date format")
		}
		existingEntity.BelongsDate = date
	}

	if categoryName != "" {
		categoryEntity := category_mapper.INSTANCE.GetCategoryByName(categoryName)
		if categoryEntity.IsEmpty() {
			return model.CashFlowEntity{}, errors.New("category does not exist")
		}
		existingEntity.CategoryId = categoryEntity.Id
	}

	if amount != 0 {
		// Round to 2 decimal places
		amount, _ = decimal.NewFromFloat(amount).Round(2).Float64()
		existingEntity.Amount = amount
	}

	if description != "" {
		existingEntity.Description = description
	}

	// Update modify time
	existingEntity.ModifyTime = time.Now()

	// Note: The current mapper's UpdateCashFlowByEntity doesn't accept the entity
	// It only takes ID and updates the modify time
	// For now, we return an error indicating this limitation
	// TODO: Enhance mapper to accept updated entity fields
	
	return model.CashFlowEntity{}, errors.New("update functionality requires mapper enhancement - mapper.UpdateCashFlowByEntity needs to accept entity parameter")
}
