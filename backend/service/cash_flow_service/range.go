package cash_flow_service

import (
	"errors"

	"github.com/macar-x/cashlens/mapper/cash_flow_mapper"
	"github.com/macar-x/cashlens/model"
	"github.com/macar-x/cashlens/util"
)

// QueryByDateRange queries cash flows within a date range
func QueryByDateRange(fromDate, toDate string) ([]*model.CashFlowEntity, error) {
	if fromDate == "" || toDate == "" {
		return nil, errors.New("both from and to dates are required")
	}

	// Parse dates
	from := util.FormatDateFromStringWithoutDash(fromDate)
	to := util.FormatDateFromStringWithoutDash(toDate)

	if from.IsZero() || to.IsZero() {
		return nil, errors.New("invalid date format, use YYYY-MM-DD or YYYYMMDD")
	}

	if from.After(to) {
		return nil, errors.New("from date must be before or equal to to date")
	}

	// Query all dates in range
	var results []*model.CashFlowEntity
	currentDate := from

	for !currentDate.After(to) {
		dayResults := cash_flow_mapper.INSTANCE.GetCashFlowsByBelongsDate(currentDate)
		for i := range dayResults {
			results = append(results, &dayResults[i])
		}
		currentDate = currentDate.AddDate(0, 0, 1)
	}

	return results, nil
}
