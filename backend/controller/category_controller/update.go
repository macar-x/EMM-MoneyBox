package category_controller

import (
	"net/http"

	"github.com/macar-x/cashlens/service/category_service"
	"github.com/macar-x/cashlens/util"
	"github.com/gorilla/mux"
)

// UpdateById updates a category by ID
func UpdateById(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	plainId := vars["id"]

	if plainId == "" {
		util.ComposeJSONResponse(w, http.StatusBadRequest, map[string]string{"error": "id is required"})
		return
	}

	// Parse JSON body for update fields
	var requestBody map[string]interface{}
	if err := util.ParseJSONRequest(r, &requestBody); err != nil {
		util.ComposeJSONResponse(w, http.StatusBadRequest, map[string]string{"error": "invalid request body"})
		return
	}

	// Extract optional fields
	parentPlainId, _ := requestBody["parent_id"].(string)
	categoryName, _ := requestBody["name"].(string)

	// Call service to update
	err := category_service.UpdateService(plainId, parentPlainId, categoryName)
	if err != nil {
		util.ComposeJSONResponse(w, http.StatusBadRequest, map[string]string{"error": err.Error()})
		return
	}

	util.ComposeJSONResponse(w, http.StatusOK, map[string]string{"message": "category updated successfully"})
}
