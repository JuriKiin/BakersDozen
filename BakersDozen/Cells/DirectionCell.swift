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
    func updateDirectionCell (_ directionCell: DirectionCell, withDirection: Direction)
    func updateDirectionTimer (_ atIndex: Int, with value: Bool)
}

class DirectionCell: UITableViewCell, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var directionTextField: UITextField!
    @IBOutlet var ingredientView: UICollectionView!
    @IBOutlet var timerImage: UIImageView!
    
    let timerOnImage = UIImage(named: "Timer_On")
    let timerOffImage = UIImage(named: "Timer_Off")
    
    var delegate: DirectionCellDelegate?
    
    var direction: Direction!
    var ingredients: [Ingredient] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
       // return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Create cell
        let cell = ingredientView.dequeueReusableCell(withReuseIdentifier: "ingredientCell", for: indexPath) as! IngredientCollectionCell
        cell.ingredient = ingredients[indexPath.row]
        cell.name.text = cell.ingredient.data
        cell.name.layer.borderColor = UIColor.black.cgColor
        for i in 0 ..< direction.ingredients.count {
            if cell.ingredient.isEqual(other: direction.ingredients[i]) {
                cell.name.layer.borderColor = UIColor.blue.cgColor
            }
        }
        cell.name.layer.borderWidth = 2.0
        
        //Add touch hold recognizer
        let pressRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleIngredientSelected(press:)))
        cell.addGestureRecognizer(pressRecognizer)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 500, height: 50)
    }
    
    @objc func toggleIngredientSelected(press: UITapGestureRecognizer) {
        //Create cell.
        let cell = press.view as! IngredientCollectionCell
        //If direction's ingredients is 0, simeply add it.
        if direction.ingredients.count == 0 {
            cell.ingredient.isSelected = true
            cell.ingredient.index = direction.ingredients.count
            direction.ingredients.append(cell.ingredient)
            ingredientView.reloadData()
            print("Adding: \(cell.name.text!) at index: \(0)")
        } else {    //Otherwise, check if it exists so we can toggle it.
            
            if cell.ingredient.isSelected {
                //Unselect it
                cell.ingredient.isSelected = false
                print("removing: \(cell.ingredient.data)")
                direction.ingredients.remove(at: cell.ingredient.index)
                for i in 0 ..< direction.ingredients.count {    //decrement the index for everything after it.
                    if direction.ingredients[i].index > cell.ingredient.index {
                         direction.ingredients[i].index -= 1
                    }
                }
            } else {
                //Select it
                cell.ingredient.isSelected = true
                cell.ingredient.index = direction.ingredients.count
                print("Adding: \(cell.name.text!) at index: \(direction.ingredients.count-1)")
                direction.ingredients.append(cell.ingredient)
            }
            
            
            
            
//            for i in 0 ..< direction.ingredients.count {
//                if  direction.ingredients[direction.index].isEqual(other: cell.ingredient) {
//                    print("removing: \(direction.ingredients[i].data)")
//                    direction.ingredients.remove(at: i)
//                    ingredientView.reloadData()
//                } else {
//                    direction.ingredients.append(Ingredient(data: cell.name.text!, isNew: false, atIndex: direction.ingredients.count-1, isSelected: true))
//                    print("Adding: \(cell.name.text!) at index: \(direction.ingredients.count-1)")
//                    ingredientView.reloadData()
//                }
//            }
            delegate?.updateDirectionCell(self, withDirection: direction)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ingredientView.delegate = self
        ingredientView.dataSource = self
        
        ingredientView.register(UINib(nibName: "ingredientCell", bundle: nil), forCellWithReuseIdentifier: "ingredientCell")
        
        directionTextField.delegate = self
        directionTextField.returnKeyType = .done
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleTimer))
        
        timerImage?.isUserInteractionEnabled = true
        timerImage?.addGestureRecognizer(tapGesture)
    }
    
    @objc func toggleTimer() {
        direction.hasTimer = !direction.hasTimer
        delegate?.updateDirectionCell(self, withDirection: direction)
        //checkTimer()

    }
    
    func initDirection(){
        directionTextField.text = direction.data
        //checkTimer()
        ingredientView.reloadData()
    }
    
    func checkTimer() {
        if direction.hasTimer {
            timerImage.image = timerOnImage
        } else {
            timerImage.image = timerOffImage
        }
    }
    
    func reloadIngredientData(data: [Ingredient]){
        ingredients = data
        ingredientView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if directionTextField.text != "" {
            direction.data = directionTextField.text!
            delegate?.directionCell(self, didAddDirection: direction)
        }
        return true
    }
}
