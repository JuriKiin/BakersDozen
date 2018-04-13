//
//  RecipeTableVC.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/2/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class RecipeTableVC: UITableViewController {
    
    @IBOutlet var recipeTable: UITableView!
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //LoadRecipes()
        recipe = Recipe()
        recipeTable.delegate = self
        recipeTable.reloadData()
    }
    
    //Reload the data when coming back to this view.
    @IBAction func unwindWithCancelTapped(segue: UIStoryboardSegue) {
        recipeTable.reloadData()
    }
    
    func LoadRecipes() -> [Recipe] {
        //Load recipes from storage
        return []
    }

    //We only want 1 section right now.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Number of rows = number of recipes
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeData.sharedData.recipes.count
    }
    
    //For each row, set the text and the backgroundColors
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        cell.recipe = RecipeData.sharedData.recipes[indexPath.row]
        cell.textLabel?.text = RecipeData.sharedData.recipes[indexPath.row].title
        cell.backgroundColor = RecipeData.sharedData.recipes[indexPath.row].color
        return cell
    }
    
    var navController:UINavigationController!
    
    @IBAction func AddRecipe(_ sender: Any) {
        navController = storyboard?.instantiateViewController(withIdentifier: "RecipeNavigationController") as! UINavigationController
        navController.modalPresentationStyle = .fullScreen
        let view = navController.topViewController as! EditRecipeTableVC
        view.recipe = Recipe()
        present(navController, animated: true)
    }
    
    //If we select a row, set data and then switch view controllers.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //If we're editing the table, load the Edit View with the recipe selected
        if recipeTable.isEditing {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Edit") as! EditRecipeTableVC
            vc.modalPresentationStyle = .fullScreen
            recipe = RecipeData.sharedData.recipes[indexPath.row]
            present(vc, animated: true)
        
        } else {    //Load View Recipe VC with selected Recipe.
            let vc = storyboard?.instantiateViewController(withIdentifier: "View") as! ViewRecipeVC
            vc.modalPresentationStyle = .fullScreen
            recipe = RecipeData.sharedData.recipes[indexPath.row]
            present(vc, animated: true)
        }
    }
    
    //End of Controller
}
