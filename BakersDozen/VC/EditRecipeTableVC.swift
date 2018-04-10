//
//  EditRecipeTableVC.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/6/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class EditRecipeTableVC: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    var recipe = Recipe()
    
    
    @IBOutlet var nameTextField: InputTextField!
    @IBOutlet var ingredientTextField: InputTextField!
    @IBOutlet var directionTextField: InputTextField!
    @IBOutlet var noteTextField: InputTextField!
    
    @IBOutlet var recipeTable: UITableView!
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTable = UITableView()
        
        recipeTable.delegate = self
        nameTextField.delegate = self
        ingredientTextField.delegate = self
        directionTextField.delegate = self
        noteTextField.delegate = self
        
        
        //Check to see if we get passed data in (we want to edit a recipe not add one)
        //If so, make sure to change the barItemButton to Save not Add.
        
    }
    
    //IBActions
    
    @IBAction func ChoosePhotoFromLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Delete the recipe if we are editing the recipe.
    @IBAction func DeleteRecipe(_ sender: Any) {
        for i in 0 ..< RecipeData.sharedData.recipes.count {
            if RecipeData.sharedData.recipes[i]._id == recipe._id {
                RecipeData.sharedData.recipes.remove(at: i)
            }
        }
    }
    
    //helper functions
    
    func AddCellOf(type: String, data: String, cell: InputCell) {
        switch type {
        case "Ingredient":
            recipe.ingredients.insert(data, at: 0)
        case "Direction":
            recipe.directions.insert(data, at: 0)
        case "Note":
            recipe.notes.insert(data, at: 0)
        default:
            return
        }
        print("Adding: \(data) to: \(type)")
    }
    
    func SaveRecipe() {
        recipe._id = GenerateNewId()
        RecipeData.sharedData.recipes.append(recipe)
    }
    
    //Generates a new ID for each recipe
    func GenerateNewId() -> String {
        return NSUUID().uuidString
    }
    
    //Image select functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        dismiss(animated:true, completion: nil)
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
            return recipe.notes.count + 1
        default:
            return 1
        }
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = UITableViewCell()
//        
//        switch indexPath.section {
//        case 0:
//            cell = tableView.dequeueReusableCell(withIdentifier: "PhotoSelect", for: indexPath) as! InputCell
//        case 1:
//            cell = tableView.dequeueReusableCell(withIdentifier: "RecipeRating", for: indexPath) as! InputCell
//        case 2:
//            cell = tableView.dequeueReusableCell(withIdentifier: "RecipeName", for: indexPath) as! InputCell
//        case 3:
//            cell = tableView.dequeueReusableCell(withIdentifier: "RecipeIngredients", for: indexPath) as! InputCell
//        case 4:
//            cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDirections", for: indexPath) as! InputCell
//        case 5:
//            cell = tableView.dequeueReusableCell(withIdentifier: "RecipeNotes", for: indexPath) as! InputCell
//        default:
//            cell = tableView.dequeueReusableCell(withIdentifier: "RecipeName", for: indexPath) as! InputCell
//        }
//        return cell
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let parent = textField.superview
        let parentCell = parent?.superview as! InputCell
        AddCellOf(type: parentCell.reuseIdentifier!, data: textField.text ?? "", cell: parentCell)
        textField.resignFirstResponder()
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
