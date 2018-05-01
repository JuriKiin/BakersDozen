//
//  DeleteCell.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/16/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

protocol DeleteCellDelegate {
    func deleteCell(_ cell: DeleteCell)
}
class DeleteCell: UITableViewCell {

    var delegate: DeleteCellDelegate?

    @IBAction func deleteCell(_ sender: Any) {
        delegate?.deleteCell(self)
    }
}
