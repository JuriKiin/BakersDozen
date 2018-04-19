//
//  RecipeTableVC.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/2/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class RecipeTableVC: UITableViewController {
    
    var navController:UINavigationController!
    var recipe: Recipe!
    
    @IBOutlet var recipeTable: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //LoadRecipes()
        recipe = Recipe()
        recipeTable.delegate = self
        recipeTable.allowsSelectionDuringEditing = true
        recipeTable.separatorStyle = .none
        recipeTable.backgroundColor = UIColor(red: 0.28, green: 0.28, blue: 0.28, alpha: 1)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.819, green: 0.235, blue: 0.403, alpha: 1)
        navigationController?.navigationBar.tintColor = .white    }
    
    //Reload the data when coming back to this view.
    @IBAction func unwindWithCancelTapped(segue: UIStoryboardSegue) {
        recipeTable.reloadData()
    }
    
    @IBAction func AddRecipe(_ sender: Any) {
        navController = storyboard?.instantiateViewController(withIdentifier: "RecipeNavigationController") as! UINavigationController
        navController.modalPresentationStyle = .fullScreen
        let view = navController.topViewController as! EditRecipeTableVC
        view.recipeIndexInMaster = -1
        view.isNewRecipe = true
        view.recipe = Recipe()
        present(navController, animated: true)
    }
    
    @IBAction func editTable(_ sender: Any) {
        toggleEditTable()
    }
    
//helper functions
    func LoadRecipes() -> [Recipe] {
        //Load recipes from storage
        return []
    }
    
    func toggleEditTable() {
        recipeTable.isEditing = !recipeTable.isEditing
        if recipeTable.isEditing {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(RecipeTableVC.editTable(_:)))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(RecipeTableVC.editTable(_:)))
        }
    }

    //We only want 1 section right now.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return RecipeData.sharedData.recipes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView()
        returnedView.backgroundColor = UIColor.clear
        
        return returnedView
    }

    //Number of rows = number of recipes
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //For each row, set the text and the backgroundColors
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        cell.recipe = RecipeData.sharedData.recipes[indexPath.section]
        cell.layer.cornerRadius = 8
        cell.textLabel?.text = RecipeData.sharedData.recipes[indexPath.section].title
        cell.backgroundColor = RecipeData.sharedData.recipes[indexPath.section].color
        return cell
    }
    
    //If we select a row, set data and then switch view controllers.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //If we're editing the table, load the Edit View with the recipe selected
        if recipeTable.isEditing {
            navController = storyboard?.instantiateViewController(withIdentifier: "RecipeNavigationController") as! UINavigationController
            navController.modalPresentationStyle = .fullScreen
            let view = navController.topViewController as! EditRecipeTableVC
            view.recipeIndexInMaster = indexPath.section
            view.isNewRecipe = false
            view.recipe = RecipeData.sharedData.recipes[indexPath.section]
            present(navController, animated: true)
        
        } else {    //Load View Recipe VC with selected Recipe.
            navController = storyboard?.instantiateViewController(withIdentifier: "ViewRecipeNavigation") as! UINavigationController
            navController.modalPresentationStyle = .fullScreen
            let view = navController.topViewController as! ViewRecipeVC
            view.recipe = RecipeData.sharedData.recipes[indexPath.section]
            present(navController, animated: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RecipeData.sharedData.recipes.remove(at: indexPath.section)
            toggleEditTable()
            recipeTable.reloadData()
        }
    }
    
    //End of Controller
}
