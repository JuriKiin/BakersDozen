//
//  RecipeTableVC.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/2/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

protocol RecipeTableDelegate {
    func reloadRecipeTable()
}

class RecipeTableVC: UITableViewController {
    
    var navController:UINavigationController!
    var recipe: Recipe!
    var shownRecipeIndex: Int!
    
    //RecipeView Variables
    let headerFontSize: CGFloat = 30
    let textFontSize: CGFloat = 20
    
    @IBOutlet var recipeTable: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    
    @IBOutlet var recipeContentView: UIView!
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeTextView: UITextView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //LoadRecipes()
        recipe = Recipe()
        recipeTable.delegate = self
        recipeTable.allowsSelectionDuringEditing = true
        recipeTable.separatorStyle = .none
        recipeTable.backgroundColor = UIColor(red: 0.28, green: 0.28, blue: 0.28, alpha: 1)
        
        recipeContentView.isHidden = true
        shownRecipeIndex = -1
        recipeContentView.center = CGPoint(x: recipeContentView.center.x, y: self.view.frame.height + recipeContentView.frame.height / 2)
        recipeTextView.text! = ""
        recipeTextView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.819, green: 0.235, blue: 0.403, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
    }
    
    //Reload the data when coming back to this view.
    @IBAction func unwindWithCancelTapped(segue: UIStoryboardSegue) {
        recipeTable.reloadData()
    }
    
    @IBAction func makeRecipe(_ sender: Any) {
        
        if recipe.directions.count == 0 || recipe.directions.count == 0 {
            
        }
        
        navController = storyboard?.instantiateViewController(withIdentifier: "MakeRecipeIdentifier") as! UINavigationController
        navController.modalPresentationStyle = .fullScreen
        let view = navController.topViewController as! MakeRecipeVC
        view.recipe = RecipeData.sharedData.recipes[shownRecipeIndex]
        present(navController, animated: true)
    }
    
    @IBAction func AddRecipe(_ sender: Any) {
        navController = storyboard?.instantiateViewController(withIdentifier: "RecipeNavigationController") as! UINavigationController
        navController.modalPresentationStyle = .fullScreen
        let view = navController.topViewController as! EditRecipeTableVC
        view.recipeIndexInMaster = -1
        view.isNewRecipe = true
        view.recipe = Recipe()
        view.receipeTableDelegate = self
        present(navController, animated: true)
    }
    
    @IBAction func editTable(_ sender: Any) {
        toggleEditTable()
    }
    
//helper functions
    
    func ReloadTable(){
        recipeTable.reloadData()
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
        if indexPath.section == shownRecipeIndex {
            cell.layer.cornerRadius = 0
        } else {
            cell.layer.cornerRadius = 8
        }
        
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
        
        } else {    //Load Recipe View
            recipe = RecipeData.sharedData.recipes[indexPath.section]
            //Populate Recipe View
            populateRecipeView(atIndex: indexPath.section)
            
            //TriggerAnimation
            recipeViewShow(recipe: RecipeData.sharedData.recipes[indexPath.section], atIndex: indexPath.section)
            
        }
    }
    
    func populateRecipeView(atIndex: Int){
        let tempRecipe = RecipeData.sharedData.recipes[atIndex] //Get the Recipe
        recipeImage.image = tempRecipe.image   //Set the Recipe Image
        let recipeString = NSMutableAttributedString()
        //Add Ingredient Header
        recipeString.append(createHeader(text: "Ingredients"))
        //Add Ingredients
        for i in 0 ..< tempRecipe.ingredients.count {
            recipeString.append(createData(data: tempRecipe.ingredients[i].data, isList: true))
        }
        //Add Direction Header
        recipeString.append(createHeader(text: "Directions"))
        //Add Directions
        
        for i in 0 ..< tempRecipe.directions.count {
            recipeString.append(createData(data: tempRecipe.directions[i].data, isList: true))
        }
        //Add Note Header
        recipeString.append(createHeader(text: "Notes"))
        //Add Notes
        recipeString.append(createData(data: tempRecipe.notes, isList: false))
        
        //Add Final String to the view.
        recipeTextView.attributedText! = recipeString
    }
    
    func createData(data: String, isList: Bool) -> NSAttributedString {
        let ingredientAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font: UIFont(name: "HiraKakuProN-W3", size: textFontSize)!
        ]
        if isList {
            return NSAttributedString(string: "\u{2022} \(data) \n\n", attributes: ingredientAttributes)
        } else {
            return NSAttributedString(string: "\(data) \n", attributes: ingredientAttributes)
        }
    }
    
    func createHeader(text: String) -> NSAttributedString{
        
        let headerAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: headerFontSize)!
        ]
        return NSAttributedString(string: "\(text) \n", attributes: headerAttributes)
    }
    
    func recipeViewShow(recipe: Recipe, atIndex: Int){
        if atIndex == shownRecipeIndex {
             recipeContentView.isHidden = !recipeContentView.isHidden
             shownRecipeIndex = -1
        } else {
            recipeContentView.isHidden = false
             shownRecipeIndex = atIndex
        }
       
       
        let cell = recipeTable.visibleCells[atIndex]
        if !recipeContentView.isHidden {
            animateRecipeView(true, atIndex: atIndex)
            cell.layer.cornerRadius = 0
        } else {
            animateRecipeView(false, atIndex: atIndex)
            cell.layer.cornerRadius = 8
        }
    }
    
    func animateRecipeView(_ transitionOn: Bool, atIndex: Int){
        UIView.animate(withDuration:0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [],
            animations: {
                self.recipeContentView.center = CGPoint(x: self.recipeContentView.center.x, y: self.tableView.visibleCells[atIndex].frame.maxY + self.recipeContentView.frame.height / 2)
            
        }, completion: nil)
    }
    
    @IBAction func shareRecipe(_ sender: Any) {
        let shareText = "Check out the recipe I made for \(recipe.title) on Baker's Dozen!"
        let objectsToShare = [recipe.image!, shareText] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
        activityVC.popoverPresentationController?.sourceView = view
        self.present(activityVC, animated: true, completion: nil)
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

extension RecipeTableVC: RecipeTableDelegate{
    func reloadRecipeTable(){
        recipeTable.reloadData()
    }
}




