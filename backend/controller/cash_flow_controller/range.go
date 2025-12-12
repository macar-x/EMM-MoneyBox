package cash_flow_controller

import (
	"net/http"

	"github.com/macar-x/cashlens/service/cash_flow_service"
	"github.com/macar-x/cashlens/util"
)

// QueryByDateRange queries cash flows between two dates
func QueryByDateRange(w http.ResponseWriter, r *http.Request) {
	// Parse query parameters
	fromDate := r.URL.Query().Get("from")
	toDate := r.URL.Query().Get("to")

	if fromDate == "" || toDate == "" {
		util.ComposeJSONResponse(w, http.StatusBadRequest, map[string]string{"error": "from and to dates are required"})
		return
	}

	// Call service to get records in range
	cashFlowEntities, err := cash_flow_service.QueryByRange(fromDate, toDate)
	if err != nil {
		util.ComposeJSONResponse(w, http.StatusBadRequest, map[string]string{"error": err.Error()})
		return
	}

	util.ComposeJSONResponse(w, http.StatusOK, cashFlowEntities)
}
