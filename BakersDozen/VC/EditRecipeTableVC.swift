//
//  EditRecipeTableVC.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/6/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class EditRecipeTableVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var recipe = Recipe()
    var isNewRecipe: Bool!
    let defaultImage = UIImage(named: "DefaultImage")
    var recipeIndexInMaster: Int!
    
    //Helper vars for saving/editing a recipe
    var previousIngredients: Int!
    var previousDirections: Int!
    
//IBOutlets
    @IBOutlet var editTableView: UITableView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ingredientTextField: UITextField!
    @IBOutlet var directionTextField: UITextField!
    @IBOutlet var noteTextField: UITextField!
    
    @IBOutlet var pageTitle: UINavigationItem!
    
//IBActions
    
    //Saves recipe to RecipeData singleton.
    @IBAction func SaveRecipe(_ sender: Any) {
        if isNewRecipe {  //Load some default options if its a new cell.
            if recipe.title == "" {
                recipe.title = "New Recipe"
            }
            //Generate a new ID and add to the singleton data.
            recipe.SetColor()
            recipe.GenerateNewId()
            RecipeData.sharedData.recipes.append(recipe)
        } else {
            //Replace the recipe we already have.
            RecipeData.sharedData.recipes[recipeIndexInMaster] = recipe
        }
        
        //Load MainView.
        dismiss(animated: true, completion: nil)
    }
    
//View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the delegate
        editTableView.delegate = self
        
        editTableView.estimatedRowHeight = 100.0
        editTableView.rowHeight = UITableViewAutomaticDimension
        editTableView.separatorStyle = .none
        
        //Set helper variables
        previousIngredients = recipe.ingredients.count
        previousDirections = recipe.directions.count
        
        //Register the custom cell xibs
        editTableView.register(UINib(nibName: "Name", bundle: nil), forCellReuseIdentifier: "Name")
        editTableView.register(UINib(nibName: "Ingredient", bundle: nil), forCellReuseIdentifier: "Ingredient")
        editTableView.register(UINib(nibName: "Direction", bundle: nil), forCellReuseIdentifier: "Direction")
        editTableView.register(UINib(nibName: "Image", bundle: nil), forCellReuseIdentifier: "Image")
        editTableView.register(UINib(nibName: "Note", bundle: nil), forCellReuseIdentifier: "Note")
        editTableView.register(UINib(nibName: "DeleteCell", bundle: nil), forCellReuseIdentifier: "Delete")
        editTableView.register(UINib(nibName: "DefaultCell", bundle: nil), forCellReuseIdentifier: "DefaultCell")
    }
    
//HELPER FUNCTIONS.
    
    //Adds a cell of either Ingredient or note.
    func AddIngredient(_ data: Ingredient) {
        
        if recipe.ingredients.count == 0 {
            recipe.ingredients.append(data)
        }
        else if data.isNewIngredient {
            recipe.ingredients.append(data)
        } else {
            recipe.ingredients[data.index].data = data.data
        }
        editTableView.reloadData()
        //Update the ingredient views for each direction.
        for cell in editTableView.visibleCells {
            let path = editTableView.indexPath(for: cell)
            if path?.section == 3 {
                let dirCell = cell as! DirectionCell
                dirCell.ReloadIngredientData(data: recipe.ingredients)
            }
        }
    }
    
    //Changes the recipe name
    func ChangeRecipeTitle(name: String) {
        recipe.title = name
        pageTitle.title = name
    }
    
    func EditNote(note: String) {
        recipe.notes = note
    }
    
    //Adds a direction, and then reloads the table.
    func AddDirection(_ direction: Direction) {
        if recipe.directions.count == 0 {
            recipe.directions.append(direction)
        }
        else if direction.isNewDirection {
            recipe.directions.append(direction)
        } else {
            recipe.directions[direction.index] = direction
        }
        editTableView.reloadData()
    }
    
//Image select functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        recipe.image = image
        editTableView.reloadData()
        dismiss(animated:true, completion: nil)
    }
    
    //Lets user choose a photo from their library.
    @objc func ChoosePhotoFromLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
//UITableView Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return recipe.ingredients.count + 1
        case 3:
            return recipe.directions.count + 1
        case 4:
            return 1
        case 5:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {

        case 0: // We are adding a Custom Image cell
            //Create the cell
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath) as! ImageCell
            if recipe.image == nil {
                cell.photoImage.image = defaultImage
            } else {
                cell.photoImage.image = recipe.image
            }
            //Add the gesture
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChoosePhotoFromLibrary(_:)))
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(tapGesture)

            //If our recipe is nil, load a default image
            if recipe.image != nil {
                cell.photoImage.image = recipe.image
            } else { //Load the saved image.
               cell.photoImage.image = defaultImage
            }
            return cell
        case 1: //We are adding a Custom Recipe Name Cell
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Name", for: indexPath) as! NameCell
            //If our recipe name is the default, set placeholder text
            cell.delegate = self
            if recipe.title == ""{
                cell.nameTextField.placeholder = "Enter Recipe Name"
            } else {
                //Otherwise, set the text to the loaded name
                cell.nameTextField.text = recipe.title
            }
            return cell
        case 2: //We are adding a Custom Ingredient Cell
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Ingredient", for: indexPath) as! IngredientCell
            cell.ingredientField.text = nil
            cell.ingredientField.placeholder = nil
            cell.ingredient.index = indexPath.row
            cell.delegate = self
            //If there are no loaded ingredients, set placeholder
            if recipe.ingredients.count == indexPath.row {
                cell.ingredientField.placeholder = "Enter Ingredient"
                cell.ingredient.isNewIngredient = true
            } else {
                //Otherwise, add the ingredient
                cell.ingredient.isNewIngredient = false
                cell.ingredientField.text = recipe.ingredients[indexPath.row].data
            }
           return cell
        case 3: //We are adding a direction
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Direction", for: indexPath) as! DirectionCell
            cell.directionTextField.text = nil
            cell.directionTextField.placeholder = nil
            cell.ingredients = []
            cell.delegate = self
            //If we have no directions, set the placeholder direction text
            if recipe.directions.count == indexPath.row {
                cell.directionTextField.placeholder = "Enter Direction"
                cell.direction = Direction()
                cell.direction.index = 0
                cell.direction.isNewDirection = true
                cell.connectedIngredients = []
                cell.ingredientView.reloadData()
            } else {
                //Otherwise, set the direction text for the cell.
                cell.direction = recipe.directions[indexPath.row]
                cell.direction.index = indexPath.row
            }
            
            cell.ingredients = recipe.ingredients
            cell.initDirection()
            return cell

        case 4:
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath) as! NoteCell
            cell.delegate = self
            if recipe.notes == "" {
                cell.textArea.text = "Enter Note Here"
            } else {
                cell.textArea.text = recipe.notes
            }
            return cell
        case 5:
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Delete", for: indexPath) as! DeleteCell
            cell.delegate = self
            return cell
        default:    //Default cell.
            let cell = editTableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = "Cell template not yet created."
            return cell
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//            return 150.0
//        case 4:
//            return 100.0
//        case 3:
//            return 300.0
//        default:
//            return 50.0
//        }
//    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Recipe Name"
        case 2:
            return "Ingredients"
        case 3:
            return "Directions"
        case 4:
            return "Notes"
        default:
            return ""
        }
    }
    
    //Distinguish which sections we can edit the table rows.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 2:
            return true
        case 3:
            return true
        default:
            return false
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            switch indexPath.section {
            case 2:
                if indexPath.row < recipe.ingredients.count {
                    recipe.ingredients.remove(at: indexPath.row)
                }
            case 3:
                if indexPath.row < recipe.directions.count {
                    recipe.directions.remove(at: indexPath.row)
                }
            default:
                return
            }
        }
        editTableView.reloadData()
    }
    
    //End of controller
}

extension EditRecipeTableVC: IngredientCellDelegate, DirectionCellDelegate, NameCellDelegate, NoteCellDelegate, DeleteCellDelegate {
    func updateDirectionTimer(_ atIndex: Int, with value: Bool) {
        if recipe.directions.count == 0 {
            //Set back our updated cell
            let indexPath = IndexPath(row: atIndex, section: 3)
            let cell = editTableView.cellForRow(at: indexPath) as! DirectionCell
            cell.direction.isNewDirection = false
            cell.direction.hasTimer = value
            cell.direction.index = 0
        } else{
            recipe.directions[atIndex].hasTimer = value
        }
    }
    
    func deleteCell(_ cell: DeleteCell) {
        if isEditing {
            RecipeData.sharedData.recipes.remove(at: recipeIndexInMaster)
        } else {
            //Load MainView.
            let navController = storyboard?.instantiateViewController(withIdentifier: "MainView") as! UINavigationController
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    func noteCell(_ noteCell: NoteCell, with text: String) {
        noteCell.textArea.endEditing(true)
        EditNote(note: text)
    }
    
    func nameCell(_ nameCell: NameCell, with name: String) {
        ChangeRecipeTitle(name: name)
    }
    
    func ingredientCell(_ ingredientCell: IngredientCell, didAddIngredient ingredient: Ingredient) {
        AddIngredient(ingredient)
    }
    func directionCell(_ directionCell: DirectionCell, didAddDirection direction: Direction) {
        AddDirection(direction)
    }
}



