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
    var imageCell: UIImageView!
    let defaultImage = UIImage(contentsOfFile: "default.png")
    var recipeIndexInMaster: Int!
    
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
        
        for cell in editTableView.visibleCells{
            let path = editTableView.indexPath(for: cell)
            
            switch path?.section {
            case 2:
                let nameCell = cell as! NameCell
                recipe.title = nameCell.nameTextField.text!
            case 3:
                let ingredientCell = cell as! IngredientCell
                recipe.ingredients.append(ingredientCell.ingredientField.text!)
            case 5:
                let noteCell = cell as! NoteCell
                recipe.notes = noteCell.textArea.text
            default:
                break
            }
        }
        
        if recipeIndexInMaster == -1 {
            recipe.GenerateNewId()
            RecipeData.sharedData.recipes.append(recipe)
        } else {
            //Replace the recipe we already have.
            RecipeData.sharedData.recipes[recipeIndexInMaster] = recipe
        }
        
        //Load MainView.
        let navController = storyboard?.instantiateViewController(withIdentifier: "MainView") as! UINavigationController
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    
    //Delete the recipe if we are editing the recipe.
    @IBAction func DeleteRecipe(_ sender: Any) {
        //If we are editing a recipe (not adding) {
        if isEditing {
            RecipeData.sharedData.recipes.remove(at: recipeIndexInMaster)
        } else {
            return
        }
        //Either way, load the main view.
    }
    
//View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the delegate
        editTableView.delegate = self
        
        //Register the custom cell xibs
        editTableView.register(UINib(nibName: "Name", bundle: nil), forCellReuseIdentifier: "Name")
        editTableView.register(UINib(nibName: "Ingredient", bundle: nil), forCellReuseIdentifier: "Ingredient")
        editTableView.register(UINib(nibName: "Direction", bundle: nil), forCellReuseIdentifier: "Direction")
        editTableView.register(UINib(nibName: "Image", bundle: nil), forCellReuseIdentifier: "Image")
        editTableView.register(UINib(nibName: "Note", bundle: nil), forCellReuseIdentifier: "Note")
    }
    
//HELPER FUNCTIONS.
    
    //Adds a cell of either Ingredient or note.
    func AddIngredient(_ data: String) {
        recipe.ingredients.append(data)
        editTableView.reloadData()
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
        recipe.directions.append(direction)
        editTableView.reloadData()
    }
    
//Image select functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        recipe.image = image
        editTableView.reloadData()
        dismiss(animated:true, completion: nil)
    }
    
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
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return recipe.ingredients.count + 1
        case 4:
            return recipe.directions.count + 1
        case 5:
            return 1
        case 6:
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
       // case 1:
        case 2: //We are adding a Custom Recipe Name Cell
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
        case 3: //We are adding a Custom Ingredient Cell
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Ingredient", for: indexPath) as! IngredientCell
            cell.ingredientField.text = nil
            cell.ingredientField.placeholder = nil
            cell.delegate = self
            //If there are no loaded ingredients, set placeholder
            if recipe.ingredients.count == indexPath.row {
                cell.ingredientField.placeholder = "Enter Ingredient"
            } else {
                //Otherwise, add the ingredient
                cell.ingredientField.text = recipe.ingredients[indexPath.row]
            }
           return cell
        case 4: //We are adding a direction
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Direction", for: indexPath) as! DirectionCell
            cell.directionTextField.text = nil
            cell.directionTextField.placeholder = nil
            cell.ingredients = []
            cell.delegate = self
            //If we have no directions, set the placeholder direction text
            if recipe.directions.count == indexPath.row {
                cell.directionTextField.placeholder = "Enter Direction"
                cell.ingredients = recipe.ingredients
                cell.connectedIngredients = []
                cell.ingredientView.reloadData()
            } else {
                //Otherwise, set the direction text for the cell.
                cell.directionTextField.text = recipe.directions[indexPath.row].data
                cell.ingredients = recipe.ingredients
                cell.connectedIngredients = recipe.directions[indexPath.row].ingredients
                cell.ingredientView.reloadData()
            }
            cell.ingredients = recipe.ingredients
            return cell

        case 5:
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath) as! NoteCell
            cell.delegate = self
            if recipe.notes == "" {
                cell.textArea.text = "Enter Note Here"
            } else {
                cell.textArea.text = recipe.notes
            }
            return cell
    /*
        case 6:
    */
        default:    //Default cell.
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath)
            cell.textLabel?.text = "Something went wrong."
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150.0
        case 5:
            return 100.0
        default:
            return 50.0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return ""
        case 2:
            return "Recipe Name"
        case 3:
            return "Ingredients"
        case 4:
            return "Directions"
        case 5:
            return "Notes"
        case 6:
            return ""
        default:
            return ""
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            editTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension EditRecipeTableVC: IngredientCellDelegate, DirectionCellDelegate, NameCellDelegate, NoteCellDelegate {
    func noteCell(_ noteCell: NoteCell, with text: String) {
        noteCell.textArea.endEditing(true)
        EditNote(note: text)
    }
    
    func nameCell(_ nameCell: NameCell, with name: String) {
        ChangeRecipeTitle(name: name)
    }
    
    func ingredientCell(_ ingredientCell: IngredientCell, didAddIngredient ingredient: String) {
        AddIngredient(ingredient)
    }
    func directionCell(_ directionCell: DirectionCell, didAddDirection direction: Direction) {
        AddDirection(direction)
    }
}



