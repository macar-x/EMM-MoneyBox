package category_service

import (
	"errors"
	"fmt"

	"github.com/macar-x/cashlens/mapper/category_mapper"
	"github.com/macar-x/cashlens/model"
	"github.com/macar-x/cashlens/util"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func CreateService(parentPlainId, categoryName string) error {

	if !isCreateRequiredFiledSatisfied(categoryName) {
		return errors.New("some required fields are empty")
	}

	var categoryEntity = model.CategoryEntity{
		ParentId: primitive.NilObjectID,
		Name:     categoryName,
	}
	if parentPlainId != "" {
		categoryEntity.ParentId = util.Convert2ObjectId(parentPlainId)
	}

	var newCategoryPlainId = category_mapper.INSTANCE.InsertCategoryByEntity(categoryEntity)
	if newCategoryPlainId == "" {
		return errors.New("category create failed")
	}

	var newCategoryEntity = category_mapper.INSTANCE.GetCategoryByObjectId(newCategoryPlainId)
	fmt.Println("category ", 0, ": ", newCategoryEntity.ToString())
	return nil
}

func isCreateRequiredFiledSatisfied(categoryName string) bool {

	return categoryName != ""
}
