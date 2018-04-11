//
//  EditRecipeTableVC.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/6/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class EditRecipeTableVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   // var recipe: Recipe!
    var recipe = Recipe()
    var imageCell: UIImageView!
    
    //IBOutlets
    @IBOutlet var editTableView: UITableView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ingredientTextField: UITextField!
    @IBOutlet var directionTextField: UITextField!
    @IBOutlet var noteTextField: UITextField!
    @IBOutlet var recipeTable: UITableView!
    @IBOutlet var imageView: UIImageView!
    
    
    //IBActions
    
    //Saves recipe to RecipeData singleton.
    @IBAction func SaveRecipe(_ sender: Any) {
        
        for cell in tableView.visibleCells{
            let path = tableView.indexPath(for: cell)
            
            switch path?.section {
            case 2:
                let nameCell = cell as! NameCell
                recipe.title = nameCell.nameTextField.text!
            case 3:
                let ingredientCell = cell as! IngredientCell
                recipe.ingredients.append(ingredientCell.ingredientField.text!)
            default:
                break
            }
            
        }
        recipe.GenerateNewId()
        RecipeData.sharedData.recipes.append(recipe)
        //Load MainView.
    }
    
    
    //Delete the recipe if we are editing the recipe.
    @IBAction func DeleteRecipe(_ sender: Any) {
        
        //If we are editing a recipe (not adding) {
        for i in 0 ..< RecipeData.sharedData.recipes.count {
            if RecipeData.sharedData.recipes[i]._id == recipe._id {
                RecipeData.sharedData.recipes.remove(at: i)
            }
        }
        
        //Either way, load the mainView.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTableView.delegate = self
        
        editTableView.register(UINib(nibName: "Name", bundle: nil), forCellReuseIdentifier: "Name")
        editTableView.register(UINib(nibName: "Ingredient", bundle: nil), forCellReuseIdentifier: "Ingredient")
        editTableView.register(UINib(nibName: "Direction", bundle: nil), forCellReuseIdentifier: "Direction")
        editTableView.register(UINib(nibName: "Image", bundle: nil), forCellReuseIdentifier: "Image")
        
        //Check to see if we get passed data in (we want to edit a recipe not add one)
        //If so, make sure to change the barItemButton to Save not Add.
        
    }
    
    //HELPER FUNCTIONS.
    func AddCellOf(type: String, data: String) {
        switch type {
        case "Ingredient":
            recipe.ingredients.insert(data, at: 0)
        case "Note":
            recipe.notes.insert(data, at: 0)
        default:
            return
        }
        editTableView?.reloadData()
        print("Adding: \(data) to: \(type)")
        print("Ingredient Count: \(recipe.ingredients.count)")
    }
    
    func ChangeRecipeTitle(name: String) {
        print("Changing title to: \(name)")
        recipe.title = name
    }
    
    
    func AddDirection(data: String, ingredients: [String], hasTimer: Bool) {
        let direction = Direction(data: data, hasTimer: hasTimer, ingredients: ingredients)
        recipe.directions.insert(direction, at: 0)
        editTableView?.reloadData()
    }
    
    //Image select functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageCell.image = image
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
            return recipe.notes.count + 1
        case 6:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.section {

        case 0:
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath) as! ImageCell
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChoosePhotoFromLibrary(_:)))
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(tapGesture)
            imageCell = cell.photoImage
            return cell
            /*
        case 1:
                */
        case 2:
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Name", for: indexPath) as! NameCell
            cell.nameTextField.placeholder = "Enter Recipe Name"
            return cell
        case 3:
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Ingredient", for: indexPath) as! IngredientCell
            if recipe.ingredients.count <= 0 {
                cell.ingredientField.placeholder = "Enter Ingredient"
            } else {
                 cell.ingredientField.placeholder = recipe.ingredients[indexPath.row]
            }
           return cell
//        case 4:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Direction", for: indexPath) as! DirectionCell
//            cell.ingredients = recipe.ingredients
//            return cell
    /*
        case 5:
            
        case 6:
    */
        default:
            let cell = editTableView.dequeueReusableCell(withIdentifier: "Ingredient", for: indexPath)
            cell.textLabel?.text = "Something went wrong."
            return cell
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            editTableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
