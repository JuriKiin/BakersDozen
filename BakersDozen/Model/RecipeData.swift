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
        testCell.ingredients = ["Milk", "Eggs"]
        testCell.directions = [Direction(data: "Bake", hasTimer: false, ingredients: ["Milk"])]
        testCell.notes = "Testing NOte.."
        testCell.image = UIImage(contentsOfFile: "default.png")
        
        recipes.append(testCell)
    }
    
}
