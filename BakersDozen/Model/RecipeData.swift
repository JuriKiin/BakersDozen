//
//  RecipeData.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/2/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import Foundation

public class RecipeData {
    
    static let sharedData = RecipeData()
    
    var recipes = [Recipe]()
    
    private init(){
        let testCell = Recipe(title: "Test1", rating: 0, ingredients: [], directions: [], notes: [])
        recipes.append(testCell)
    }
    
}
