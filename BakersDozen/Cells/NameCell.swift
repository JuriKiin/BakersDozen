//
//  TitleCell.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/11/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

protocol NameCellDelegate {
    func nameCell(_ nameCell: NameCell, with name: String)
}


class NameCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var nameTextField: UITextField!
    
    let recipe = EditRecipeTableVC()
    var delegate: NameCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextField.text != "" {
            delegate?.nameCell(self, with: nameTextField.text!)
            nameTextField.resignFirstResponder()
        }
        return true
    }
}
