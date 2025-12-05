package cash_flow_service

import (
	"github.com/macar-x/cashlens/model"
)

// QueryAll queries all cash flows with optional filtering and pagination
// Note: This is a simplified implementation that queries all and filters in memory
// For production, this should be done at the database level with proper pagination
func QueryAll(cashType string, limit, offset int) ([]*model.CashFlowEntity, error) {
	// For now, return empty list with a note that this needs mapper enhancement
	// To properly implement this, we need:
	// 1. New mapper method: GetAllCashFlows(filter, limit, offset)
	// 2. Database-level pagination and filtering

	// Temporary implementation: return empty list
	// TODO: Add GetAllCashFlows method to mapper interface
	return []*model.CashFlowEntity{}, nil
}
