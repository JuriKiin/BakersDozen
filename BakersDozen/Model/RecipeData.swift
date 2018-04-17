//
//  RecipeData.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/2/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

public class RecipeData {
    
    static let sharedData = RecipeData()
    
    var recipes = [Recipe]()
    
    private init(){
        let testCell = Recipe()
        
        testCell.title = "Blueberry Muffins"
        testCell.ingredients = [Ingredient(data: "Milk", isNew: false),Ingredient(data: "Eggs", isNew: false)]
        testCell.directions = [Direction(data: "Bake", hasTimer: false, ingredients: [Ingredient(data: "Milk", isNew: false)])]
        testCell.notes = "Testing Note.."
        testCell.image = UIImage(contentsOfFile: "default.png")
        
        recipes.append(testCell)
    }
    
}
