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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTable.delegate = self
        recipeTable.reloadData()
    }
    
    @IBAction func unwindWithCancelTapped(segue: UIStoryboardSegue) {
        recipeTable.reloadData()
        print(RecipeData.sharedData.recipes.count)
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
        print(RecipeData.sharedData.recipes)
        print(RecipeData.sharedData.recipes.count)
        return RecipeData.sharedData.recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        cell.textLabel?.text = RecipeData.sharedData.recipes[indexPath.row].title
        cell.backgroundColor = RecipeData.sharedData.recipes[indexPath.row].color
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }

}
