package manage_service

import (
	"errors"
)

// ResetDatabase clears all data from the database
// TODO: Implement actual reset logic
func ResetDatabase() error {
	// TODO: Implement database reset
	// 1. Delete all cash flow records
	// 2. Delete all categories
	// 3. Reset any sequences/counters

	return errors.New("database reset functionality not yet implemented - requires database integration")
}
