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
        testCell.ingredients = [
            Ingredient(data: "1 1/2 cups all-purpose flour", isNew: false, atIndex:0),
            Ingredient(data: "3/4 cup granulated sugar", isNew: false,atIndex:1),
            Ingredient(data: "1 tablespoon granulated sugar (for muffin tops)", isNew: false,atIndex:2),
            Ingredient(data: "1/2 teaspoon kosher salt", isNew: false,atIndex:3),
            Ingredient(data: "2 teaspoons baking powder", isNew: false,atIndex:4),
            Ingredient(data: "1/3 cup vegetable oil", isNew: false,atIndex:5),
            Ingredient(data: "1 large egg", isNew: false,atIndex:6),
            Ingredient(data: "1/3-1/2 cup milk", isNew: false,atIndex:7),
            Ingredient(data: "1 1/2 teaspoons vanilla extract", isNew: false,atIndex:8),
            Ingredient(data: "6-8 ounces fresh blueberries", isNew: false,atIndex:9)
        ]
        testCell.directions = [
            Direction(data: "Heat oven to 400 degrees F", hasTimer: false, ingredients: []),
            Direction(data: "Line muffin tin with cups", hasTimer: false, ingredients: []),
            Direction(data: "Whisk flour, sugar, baking powder, and salt in a large bowl", hasTimer: false, ingredients: [Ingredient(data: "1 1/2 cups all-purpose flour", isNew: false, atIndex:0),
                    Ingredient(data: "3/4 cup granulated sugar", isNew: false, atIndex:1),
                    Ingredient(data: "1/2 teaspoon kosher salt", isNew: false, atIndex:3),
                    Ingredient(data: "2 teaspoons baking powder", isNew: false, atIndex:4)]),
            Direction(data: "Add oil to 1 Cup measuring cup", hasTimer: false, ingredients: [Ingredient(data: "1/3 cup vegetable oil", isNew: false, atIndex:5)]),
            Direction(data: "Add the egg then fill the measuring cup with the milk", hasTimer: false, ingredients: [Ingredient(data: "1 large egg", isNew: false, atIndex:6),
                    Ingredient(data: "1/3-1/2 cup milk", isNew: false, atIndex:7)]),
            Direction(data: "Add vanilla extract and whisk to combine", hasTimer: false, ingredients: [Ingredient(data: "1 1/2 teaspoons vanilla extract", isNew: false, atIndex:8)]),
            Direction(data: "Add milk mixture to the bowl with dry ingredients and combine with a fork (Do Not Overmix)", hasTimer: false, ingredients: []),
            Direction(data: "Fold in the blueberries", hasTimer: false, ingredients: [Ingredient(data: "6-8 ounces fresh blueberries", isNew: false, atIndex:9)]),
            Direction(data: "Divide the batter between muffin cups", hasTimer: false, ingredients: []),
            Direction(data: "Sprinkle the remaining 1 tablespoon sugar over the top of each muffin", hasTimer: false, ingredients: [Ingredient(data: "1 tablespoon granulated sugar (for muffin tops)", isNew: false, atIndex:2)]),
             Direction(data: "Bake muffins for 15-20 minutes, or until tops are no longer wet and a knife or toothpick comes out clean", hasTimer: false, ingredients: []),
             Direction(data: "Transfer muffins to a cooling rack", hasTimer: false, ingredients: []),
            
        ]
        testCell.notes = "These can be stored for 2-3 days at room temperature if in a sealed bag. They can also freeze up to 3 months. These can also be used with any type of berry you like!"
        let imageData = UIImage(named: "muffin")
        testCell.image = UIImagePNGRepresentation(imageData!)!
        testCell.color =  [CGFloat(219.0/255.0), CGFloat(213.0/255.0), CGFloat(110.0/255.0), CGFloat(1.0)]
        recipes.append(testCell)
    }
    
}
