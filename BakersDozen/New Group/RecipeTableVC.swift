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
    func resetRecipeTable()
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
        //Set the recipe to a new recipe by default
        recipe = Recipe()
        //Set the delegates for our recipe table
        recipeTable.delegate = self
        recipeTable.allowsSelectionDuringEditing = true //Let user edit table
        recipeTable.separatorStyle = .none  //No lines in between each cell
        recipeTable.backgroundColor = UIColor(red: 0.28, green: 0.28, blue: 0.28, alpha: 1) //Set the background color
        
        recipeContentView.isHidden = true   //Set our content view to hidden by default
        shownRecipeIndex = -1               //Set our index to -1 (default value)
        //Set the center of our content view to be at the bottom of the window.
        recipeContentView.center = CGPoint(x: recipeContentView.center.x, y: self.view.frame.height + recipeContentView.frame.height / 2)
        //Set the recipe table text
        recipeTextView.text! = ""
        //Set the margins for our content view
        recipeTextView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        //Customize the navigation controller bar.
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.819, green: 0.235, blue: 0.403, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
    }
    
    //Reload the data when coming back to this view.
    @IBAction func unwindWithCancelTapped(segue: UIStoryboardSegue) {
        recipeTable.reloadData()
    }
    
    //
    @IBAction func makeRecipe(_ sender: Any) {
        //Don't let the user to to make recipe if the recipe is blank.
        if recipe.directions.count == 0 || recipe.directions.count == 0 {
            return
        }
        //OTherwise, load the MakeRecipeView
        navController = storyboard?.instantiateViewController(withIdentifier: "MakeRecipeIdentifier") as! UINavigationController
        //Set the presentation style
        navController.modalPresentationStyle = .fullScreen
        //Set the VC's recipe object so it can load the correct data
        let view = navController.topViewController as! MakeRecipeVC
        view.recipe = RecipeData.sharedData.recipes[shownRecipeIndex]
        //Present the VC
        present(navController, animated: true)
    }
    
    //This button brings the user to the addRecipe view
    @IBAction func addRecipe(_ sender: Any) {
        //Set the navController
        navController = storyboard?.instantiateViewController(withIdentifier: "RecipeNavigationController") as! UINavigationController
        navController.modalPresentationStyle = .fullScreen
        //Init the new view to the proper VC type
        let view = navController.topViewController as! EditRecipeTableVC
        //Set those VC values that let the user interact with the correct data.
        view.recipeIndexInMaster = -1
        view.isNewRecipe = true
        view.recipe = Recipe()
        view.receipeTableDelegate = self
        present(navController, animated: true)
    }
    
    //Toggles whether the user can edit the table
    @IBAction func editTable(_ sender: Any) {
        toggleEditTable()
    }
    
//helper functions
    
    //Reloads the cells of the table (used in the protocol)
    func reloadTable() {
        recipeTable.reloadData()
    }
    
    //Sets the bar item of the navController based on if we are editing the table or not
    func toggleEditTable() {
        recipeTable.isEditing = !recipeTable.isEditing
        if recipeTable.isEditing {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(RecipeTableVC.editTable(_:)))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(RecipeTableVC.editTable(_:)))
        }
    }
    
    //The following are the delegate functions of the TableView
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

    //Number of rows = number of recipes in each section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //For each row, set the text and the backgroundColors
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create a new cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        //Set the cell recipe to the correct recipe
        cell.recipe = RecipeData.sharedData.recipes[indexPath.section]
        cell.selectionStyle = .none
        //If we have selected this recipe to show, change the corner radius.
        if indexPath.section == shownRecipeIndex {
            cell.layer.cornerRadius = 0
        } else {
            cell.layer.cornerRadius = 8
        }
        //Set the text and color of the cell.
        cell.textLabel?.text = cell.recipe.title
        cell.backgroundColor = cell.recipe.color
        return cell
    }
    
    //If we select a row, set data and then switch view controllers.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If we're editing the table, load the Edit View with the recipe selected
        recipeTable.visibleCells[indexPath.section].layer.backgroundColor = RecipeData.sharedData.recipes[indexPath.section].color.cgColor
        if recipeTable.isEditing {
            //Set the navigationController
            navController = storyboard?.instantiateViewController(withIdentifier: "RecipeNavigationController") as! UINavigationController
            navController.modalPresentationStyle = .fullScreen
            //Create the new VC
            let view = navController.topViewController as! EditRecipeTableVC
            //Set the variables that VC needs to interact correctly with the data.
            view.recipeIndexInMaster = indexPath.section
            view.isNewRecipe = false
            view.recipe = RecipeData.sharedData.recipes[indexPath.section]
            view.receipeTableDelegate = self
            present(navController, animated: true)
        
        } else {    //Load Recipe View
            recipe = RecipeData.sharedData.recipes[indexPath.section]
            //Populate Recipe View
            populateRecipeView(atIndex: indexPath.section)
            //TriggerAnimation
            recipeViewShow(recipe: RecipeData.sharedData.recipes[indexPath.section], atIndex: indexPath.section)
            
        }
    }
    
    //This function loads the correct recipe data into the content view.
    func populateRecipeView(atIndex: Int) {
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
    
    //This function creates and returns an attributed string to add to our contentView content.
    func createData(data: String, isList: Bool) -> NSAttributedString {
        //Set the data attributes for the string.
        let ingredientAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font: UIFont(name: "HiraKakuProN-W3", size: textFontSize)!
        ]
        //If this is a list, add the bullet points (ingredients/directions)
        if isList {
            return NSAttributedString(string: "\u{2022} \(data) \n\n", attributes: ingredientAttributes)
        } else {    //Otherwise, just normal text (notes)
            return NSAttributedString(string: "\(data) \n", attributes: ingredientAttributes)
        }
    }
    
    func createHeader(text: String) -> NSAttributedString {
        //Set the header text attributes
        let headerAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: headerFontSize)!
        ]
        //Return the new string with the text and the attributes.
        return NSAttributedString(string: "\(text) \n", attributes: headerAttributes)
    }
    
    //Toggle the contentView of the recipe.
    func recipeViewShow(recipe: Recipe, atIndex: Int) {
        //If we are already displaying the recipe for this cell, stop displaying it
        if atIndex == shownRecipeIndex {
             recipeContentView.isHidden = !recipeContentView.isHidden
             shownRecipeIndex = -1
        } else {    //Otherwise, display it.
            recipeContentView.isHidden = false
             shownRecipeIndex = atIndex
        }
       
        //Get the cell for telling the content view where to move to,
        let cell = recipeTable.visibleCells[atIndex]
        if !recipeContentView.isHidden {
            animateRecipeView(true, atIndex: atIndex)
            cell.layer.cornerRadius = 0
        } else {
            animateRecipeView(false, atIndex: atIndex)
            cell.layer.cornerRadius = 8
        }
    }
    
    //This function animates the contentView.
    func animateRecipeView(_ transitionOn: Bool, atIndex: Int) {
        UIView.animate(withDuration:0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [],
            animations: {
                self.recipeContentView.center = CGPoint(x: self.recipeContentView.center.x, y: self.tableView.visibleCells[atIndex].frame.maxY + self.recipeContentView.frame.height / 2)
            
        }, completion: nil)
    }
    
    //This recipe shrares the data of the recipe with social media/notes/messages.
    @IBAction func shareRecipe(_ sender: Any) {
        //Creating the basic text
        let shareText = "Check out the recipe I made for \(recipe.title) on Baker's Dozen!"
        //Creating a string for all of the ingredients in the recipe.
        var ingredientArray = "Ingredients: \n"
        for i in 0 ..< recipe.ingredients.count {   //Adding the ingredients onto the ingredientString
            ingredientArray += "\(recipe.ingredients[i].data) \n"
        }
        //Creating a string for all directions
        var directionArray = "Directions: \n"
        for i in 0 ..< recipe.directions.count {    //Populating the directions string with all the direction steps.
            directionArray += "\(recipe.directions[i].data) \n"
        }
        //Adding the objects to share array so the activity controller knows what to share
        let objectsToShare = [recipe.image!, shareText, ingredientArray, directionArray] as [Any]
        //Present the activity controller.
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
        activityVC.popoverPresentationController?.sourceView = view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    //This sets the editing style of the recipe table.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RecipeData.sharedData.recipes.remove(at: indexPath.section)
            toggleEditTable()
            recipeTable.reloadData()
        }
    }
    
    //End of Controller
}

//This extension is used and called from editRecipe, used on save to reload the recipeTable data.
extension RecipeTableVC: RecipeTableDelegate{
    func reloadRecipeTable(){
        recipeTable.reloadData()
    }
    func resetRecipeTable() {
        recipeContentView.isHidden = false
        toggleEditTable()
        recipeTable.reloadData()
    }
}




