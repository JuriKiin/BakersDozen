//
//  Recipe.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/2/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

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
    var directions:[String]
    var notes:[String]
    
    init(){
        title = "Recipe"
        rating = 0
        ingredients = []
        directions = []
        notes = []
        _id = ""
    }
    
    init(title: String, rating: Int, ingredients: [String], directions: [String], notes: [String]){
        self.title = title
        self.rating = rating
        self.ingredients = ingredients
        self.directions = directions
        self.notes = notes
        self._id = ""
    }
    
}
