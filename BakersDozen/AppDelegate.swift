//
//  AppDelegate.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/2/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: "recipes.json")
        do {
            print(pathToFile.path)
            let data = try Data.init(contentsOf: pathToFile, options: [])
            let recipes = try JSONDecoder().decode([Recipe].self, from: data)
            let defaults = UserDefaults.standard
            if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
                addDefaultRecipe()
                print(isAppAlreadyLaunchedOnce)
            }else{
                defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            }
            RecipeData.sharedData.recipes = recipes
        } catch {
            print("Retrieve Failed")
            print(error)
            RecipeData.sharedData.recipes = []  //If we fail, make it empty...
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func addDefaultRecipe() {
        let defaultRecipe = Recipe()
        
        defaultRecipe.title = "Blueberry Muffins"
        defaultRecipe.ingredients = [
            Ingredient(data: "1 1/2 cups all-purpose flour", isNew: false, atIndex:0,isSelected:false),
            Ingredient(data: "3/4 cup granulated sugar", isNew: false,atIndex:1,isSelected:false),
            Ingredient(data: "1 tablespoon granulated sugar (for muffin tops)", isNew: false,atIndex:2,isSelected:false),
            Ingredient(data: "1/2 teaspoon kosher salt", isNew: false,atIndex:3,isSelected:false),
            Ingredient(data: "2 teaspoons baking powder", isNew: false,atIndex:4,isSelected:false),
            Ingredient(data: "1/3 cup vegetable oil", isNew: false,atIndex:5,isSelected:false),
            Ingredient(data: "1 large egg", isNew: false,atIndex:6,isSelected:false),
            Ingredient(data: "1/3-1/2 cup milk", isNew: false,atIndex:7,isSelected:false),
            Ingredient(data: "1 1/2 teaspoons vanilla extract", isNew: false,atIndex:8,isSelected:false),
            Ingredient(data: "6-8 ounces fresh blueberries", isNew: false,atIndex:9,isSelected:false)
        ]
        defaultRecipe.directions = [
            Direction(data: "Heat oven to 400 degrees F", hasTimer: false, ingredients: []),
            Direction(data: "Line muffin tin with cups", hasTimer: false, ingredients: []),
            Direction(data: "Whisk flour, sugar, baking powder, and salt in a large bowl", hasTimer: false, ingredients: [Ingredient(data: "1 1/2 cups all-purpose flour", isNew: false, atIndex:0,isSelected:true),
                                                                                                                          Ingredient(data: "3/4 cup granulated sugar", isNew: false, atIndex:1,isSelected:true),
                                                                                                                          Ingredient(data: "1/2 teaspoon kosher salt", isNew: false, atIndex:3,isSelected:true),
                                                                                                                          Ingredient(data: "2 teaspoons baking powder", isNew: false, atIndex:4,isSelected:true)]),
            Direction(data: "Add oil to 1 Cup measuring cup", hasTimer: false, ingredients: [Ingredient(data: "1/3 cup vegetable oil", isNew: false, atIndex:5,isSelected:true)]),
            Direction(data: "Add the egg then fill the measuring cup with the milk", hasTimer: false, ingredients: [Ingredient(data: "1 large egg", isNew: false, atIndex:6,isSelected:true),
                                                                                                                    Ingredient(data: "1/3-1/2 cup milk", isNew: false, atIndex:7,isSelected:true)]),
            Direction(data: "Add vanilla extract and whisk to combine", hasTimer: false, ingredients: [Ingredient(data: "1 1/2 teaspoons vanilla extract", isNew: false, atIndex:8,isSelected:true)]),
            Direction(data: "Add milk mixture to the bowl with dry ingredients and combine with a fork (Do Not Overmix)", hasTimer: false, ingredients: []),
            Direction(data: "Fold in the blueberries", hasTimer: false, ingredients: [Ingredient(data: "6-8 ounces fresh blueberries", isNew: false, atIndex:9,isSelected:true)]),
            Direction(data: "Divide the batter between muffin cups", hasTimer: false, ingredients: []),
            Direction(data: "Sprinkle the remaining 1 tablespoon sugar over the top of each muffin", hasTimer: false, ingredients: [Ingredient(data: "1 tablespoon granulated sugar (for muffin tops)", isNew: false, atIndex:2,isSelected:true)]),
            Direction(data: "Bake muffins for 15-20 minutes, or until tops are no longer wet and a knife or toothpick comes out clean", hasTimer: false, ingredients: []),
            Direction(data: "Transfer muffins to a cooling rack", hasTimer: false, ingredients: []),
            
        ]
        defaultRecipe.notes = "These can be stored for 2-3 days at room temperature if in a sealed bag. They can also freeze up to 3 months. These can also be used with any type of berry you like!"
        let imageData = UIImage(named: "muffin")
        defaultRecipe.image = UIImagePNGRepresentation(imageData!)!
        defaultRecipe.color =  [CGFloat(219.0/255.0), CGFloat(213.0/255.0), CGFloat(110.0/255.0), CGFloat(1.0)]
        defaultRecipe._id = "defaultRecipe"
        RecipeData.sharedData.recipes.append(defaultRecipe)
    }


}
