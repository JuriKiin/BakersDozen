//
//  NoteCell.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/12/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet var textArea: UITextView!
    
    let recipeVC = EditRecipeTableVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textArea.delegate = self
        textArea.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        recipeVC.EditNote(note: textArea.text)
        return true
    }
}
