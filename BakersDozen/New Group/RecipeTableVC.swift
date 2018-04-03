//
//  RecipeTableVC.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/2/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class RecipeTableVC: UITableViewController {

    var recipes: [Recipe]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testCell = Recipe(title: "Test1", rating: 0, ingredients: [], directions: [], notes: [])
        
        RecipeData.sharedData.recipes.append(testCell)
    }
    
    func LoadRecipes() -> [Recipe] {
        //Load recipes from storage
        return []
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return RecipeData.sharedData.recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        cell.textLabel?.text = RecipeData.sharedData.recipes[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }

}
