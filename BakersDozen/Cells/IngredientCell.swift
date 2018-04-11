//
//  InputCell.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/6/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell, UITextFieldDelegate {

    
    @IBOutlet var ingredientField: UITextField!
    
    let recipe = EditRecipeTableVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ingredientField.delegate = self
        ingredientField.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if ingredientField.text != "" {
            recipe.AddCellOf(type: "Ingredient", data: ingredientField.text ?? "")
        }
        return true
    }
}
