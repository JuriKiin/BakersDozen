//
//  InputCell.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/6/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

protocol IngredientCellDelegate {
    func ingredientCell (_ ingredientCell: IngredientCell, didAddIngredient ingredient: Ingredient)
}

class IngredientCell: UITableViewCell, UITextFieldDelegate {

    
    @IBOutlet var ingredientField: UITextField!
    var delegate: IngredientCellDelegate?
    var hasBeenCreated: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ingredientField.delegate = self
        ingredientField.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let ingredient = Ingredient(data: ingredientField.text!, isNew: false)
        delegate?.ingredientCell(self, didAddIngredient: ingredient)
        return true
    }
}
