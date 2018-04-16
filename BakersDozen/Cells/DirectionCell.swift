//
//  DirectionCell.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/10/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit


protocol DirectionCellDelegate {
    func directionCell (_ directionCell: DirectionCell, didAddDirection direction: Direction)
}

class DirectionCell: UITableViewCell, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var directionTextField: UITextField!
    @IBOutlet var ingredientView: UICollectionView!
    @IBOutlet var timerImage: UIImageView!
    
    let timerOnImage = UIImage(named: "timerOn")
    let timerOffImage = UIImage(named: "timerOff")
    var hasTimer: Bool = false
    
    var delegate: DirectionCellDelegate?
    
    var ingredients: [String] = []
    var connectedIngredients: [String] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("Creating Cells")
        
        let cell = ingredientView.dequeueReusableCell(withReuseIdentifier: "ingredientCell", for: indexPath) as! IngredientCollectionCell
        cell.name.text = ingredients[indexPath.row]
        cell.name.layer.borderColor = UIColor.black.cgColor
        cell.name.layer.borderWidth = 2.0
        
        //Add touch hold recognizer
        let pressRecognizer = UITapGestureRecognizer(target: self, action: #selector(ToggleIngredientSelected(press:)))
        cell.addGestureRecognizer(pressRecognizer)
        
        return cell
    }
    
    @objc func ToggleIngredientSelected(press: UITapGestureRecognizer) {
        let cell = press.view as! IngredientCollectionCell
        for i in 0 ..< ingredients.count {
            if ingredients[i] == cell.name.text! {
                ingredients.remove(at: i)
            } else {
                ingredients.append(cell.name.text!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("In View")
        ingredientView.delegate = self
        ingredientView.dataSource = self
        
        ingredientView.register(UINib(nibName: "ingredientCell", bundle: nil), forCellWithReuseIdentifier: "ingredientCell")
        ingredientView.reloadData()
        
        directionTextField.delegate = self
        directionTextField.returnKeyType = .done
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ToggleTimer))
        timerImage?.isUserInteractionEnabled = true
        timerImage?.addGestureRecognizer(tapGesture)
    }
    
    @objc func ToggleTimer() {
        if hasTimer {
            timerImage.image = timerOnImage
        } else {
            timerImage.image = timerOffImage
        }
        hasTimer = !hasTimer
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if directionTextField.text != "" {
            let newDirection = Direction()
            newDirection.data = directionTextField.text!
            newDirection.hasTimer = hasTimer
            newDirection.ingredients = connectedIngredients
            delegate?.directionCell(self, didAddDirection: newDirection)
        }
        return true
    }

}
