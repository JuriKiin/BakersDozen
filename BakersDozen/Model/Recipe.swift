//
//  Recipe.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/2/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class Direction {
    var data: String
    var ingredients: [Ingredient]
    var hasTimer: Bool
    var isNewDirection: Bool
    var index: Int
    
    init() {
        data = ""
        hasTimer = false
        ingredients = []
        isNewDirection = true
        index = -1
    }
    init(data: String, hasTimer: Bool, ingredients: [Ingredient]) {
        self.data = data
        self.hasTimer = hasTimer
        self.ingredients = ingredients
        isNewDirection = true
        index = -1
    }
}

class Ingredient {
    var data: String
    var isNewIngredient: Bool
    var index: Int
    
    init() {
        data = ""
        isNewIngredient = true
        index = -1
    }
    
    init(data: String, isNew: Bool) {
        self.data = data
        self.isNewIngredient = isNew
        self.index = -1
    }
}

class Recipe {
    
    var title: String
    var image: UIImage?
    var rating: Int {
        didSet{
            if oldValue < 0 {
                rating = 0
            }
        }
    }
    var _id: String
    var ingredients:[Ingredient]
    var directions:[Direction]
    var notes:String
    
    //App vars (for displaying recipe)
    var color: UIColor
    
    //Default init.
    init(){
        title = ""
        rating = 0
        ingredients = []
        directions = []
        notes = ""
        _id = ""
        color = .white
    }
    
    //Helper init
    init(title: String, rating: Int, ingredients: [Ingredient], directions: [Direction], notes: String, image: UIImage){
        self.title = title
        self.rating = rating
        self.ingredients = ingredients
        self.directions = directions
        self.notes = notes
        self._id = ""
        self.image = image
        color = .white
    }
    
    //Generates a new ID for the recipe.
    func GenerateNewId() {
        self._id = NSUUID().uuidString
    }
    
    func SetColor(){
        
        let colors:[UIColor] = [
            UIColor(red: 219/255, green: 213/255, blue: 110/255, alpha: 1),
            UIColor(red: 136/255, green: 171/255, blue: 117/255, alpha: 1),
            UIColor(red: 45/255, green: 147/255, blue: 173/255, alpha: 1),
            UIColor(red: 125/255, green: 124/255, blue: 132/255, alpha: 1),
            UIColor(red: 136/255, green: 171/255, blue: 117/255, alpha: 1),
            UIColor(red: 222/255, green: 143/255, blue: 110/255, alpha: 1),
            ]
        let random = Int(arc4random_uniform(UInt32(colors.count)))
        self.color = colors[random]
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

