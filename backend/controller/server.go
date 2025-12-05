package controller

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/macar-x/cashlens/controller/cash_flow_controller"
	"github.com/macar-x/cashlens/middleware"
	"github.com/gorilla/mux"
)

func StartServer(port int32) {
	r := mux.NewRouter()
	
	// Register routes
	registerHealthRoutes(r)
	registerCashRoute(r)

	// Apply middleware
	handler := middleware.Logging(middleware.CORS(r))

	addr := fmt.Sprintf(":%d", port)
	fmt.Printf("API server is running on http://localhost%s\n", addr)
	http.ListenAndServe(addr, handler)
}

func registerHealthRoutes(r *mux.Router) {
	r.HandleFunc("/api/health", healthCheck).Methods("GET")
	r.HandleFunc("/api/version", versionInfo).Methods("GET")
}

func registerCashRoute(r *mux.Router) {
	r.HandleFunc("/api/cash/outcome", cash_flow_controller.CreateOutcome).Methods("POST")
	r.HandleFunc("/api/cash/income", cash_flow_controller.CreateIncome).Methods("POST")
	r.HandleFunc("/api/cash/{id}", cash_flow_controller.QueryById).Methods("GET")
	r.HandleFunc("/api/cash/date/{date}", cash_flow_controller.QueryByDate).Methods("GET")
	r.HandleFunc("/api/cash/{id}", cash_flow_controller.DeleteById).Methods("DELETE")
	r.HandleFunc("/api/cash/date/{date}", cash_flow_controller.DeleteByDate).Methods("DELETE")
	// TODO: Add PUT /api/cash/{id} for updates
	// TODO: Add GET /api/cash/range for date range queries
	// TODO: Add GET /api/cash/summary/* for summaries
}

// Health check endpoint
func healthCheck(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"status":  "healthy",
		"service": "cashlens-api",
		"message": "API is running",
	})
}

// Version info endpoint
func versionInfo(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"version":     "1.0.0",
		"name":        "Cashlens API",
		"description": "Personal finance management API",
		"endpoints": map[string][]string{
			"cash_flow": {
				"POST /api/cash/outcome",
				"POST /api/cash/income",
				"GET /api/cash/{id}",
				"GET /api/cash/date/{date}",
				"DELETE /api/cash/{id}",
				"DELETE /api/cash/date/{date}",
			},
			"health": {
				"GET /api/health",
				"GET /api/version",
			},
		},
	})
}
