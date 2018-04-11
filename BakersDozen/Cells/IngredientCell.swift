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
    
    let recipeVC = EditRecipeTableVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ingredientField.delegate = self
        ingredientField.returnKeyType = .done
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        recipeVC.AddCellOf(type: "Ingredient", data: ingredientField.text ?? "")
        return true
    }
}
