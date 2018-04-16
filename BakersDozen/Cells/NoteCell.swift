//
//  NoteCell.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/12/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

protocol NoteCellDelegate {
    func noteCell(_ noteCell: NoteCell, with text: String)
}


class NoteCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet var textArea: UITextView!
    
    let recipeVC = EditRecipeTableVC()
    var delegate: NoteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textArea.delegate = self
        textArea.returnKeyType = .done
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("In Here")
        delegate?.noteCell(self, with: textArea.text)
        return true
    }
    
}
