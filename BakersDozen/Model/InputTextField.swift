//
//  InputTextField.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/6/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class InputTextField: UITextField, UITextFieldDelegate {
    
    let view = EditRecipeTableVC()
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("In here")
        self.returnKeyType = .done
    }
}
