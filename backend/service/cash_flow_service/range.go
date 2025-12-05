package cash_flow_service

import (
	"github.com/macar-x/cashlens/mapper/cash_flow_mapper"
	"github.com/macar-x/cashlens/model"
	"github.com/macar-x/cashlens/util"
	"github.com/macar-x/cashlens/validation"
)

// QueryByDateRange queries cash flows within a date range
func QueryByDateRange(fromDate, toDate string) ([]*model.CashFlowEntity, error) {
	// Validate date range
	if err := validation.ValidateDateRange(fromDate, toDate); err != nil {
		return nil, err
	}

	// Parse dates
	from := util.FormatDateFromStringWithoutDash(fromDate)
	to := util.FormatDateFromStringWithoutDash(toDate)

	// Single query for entire date range
	results := cash_flow_mapper.INSTANCE.GetCashFlowsByDateRange(from, to)

	// Convert to pointer slice
	var resultPtrs []*model.CashFlowEntity
	for i := range results {
		resultPtrs = append(resultPtrs, &results[i])
	}

	return resultPtrs, nil
}
