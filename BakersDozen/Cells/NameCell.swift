//
//  TitleCell.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/11/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class NameCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var nameTextField: UITextField!
    
    let recipe = EditRecipeTableVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextField.text != "" {
            recipe.ChangeRecipeTitle(name: nameTextField.text!)
            print("Did change title")
        }
        return true
    }

}
