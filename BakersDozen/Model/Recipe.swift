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
    var ingredients: [String]
    var hasTimer: Bool
    
    init() {
        data = ""
        hasTimer = false
        ingredients = []
    }
    init(data: String, hasTimer: Bool, ingredients: [String]) {
        self.data = data
        self.hasTimer = hasTimer
        self.ingredients = ingredients
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
    var ingredients:[String]
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
    init(title: String, rating: Int, ingredients: [String], directions: [Direction], notes: String){
        self.title = title
        self.rating = rating
        self.ingredients = ingredients
        self.directions = directions
        self.notes = notes
        self._id = ""
        color = .white
    }
    
    //Generates a new ID for the recipe.
    func GenerateNewId() {
        self._id = NSUUID().uuidString
    }
    
    func SetColor(){
        
        //Change once decided on how to display color.
        self.color = .red
    }
    
}
