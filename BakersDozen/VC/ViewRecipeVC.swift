//
//  ViewRecipeVC.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/9/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class ViewRecipeVC: UIViewController {

    var recipe:Recipe!
    
    let headerFontSize: CGFloat = 30
    let dataLabelFontSize: CGFloat = 20
    let verticalPadding: CGFloat = 10
    let sectionPadding: CGFloat = 20
    var lastLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Replace with the object we're passed from the MainView.
        recipe = Recipe()
        //Based on rating, disable the correct number of stars.
        
        //Load content
        imageView.image = recipe.image
        FillContent(name: "Ingredients", with: recipe.ingredients)
        FillContent(name: "Directions", with: recipe.directions)
        FillContent(name: "Notes", with: recipe.notes)
    }
    
    func FillContent(name: String, with: [String]) {
        //Create header
        let headerLabel = UILabel()
        headerLabel.text = name
        headerLabel.font = headerLabel.font.withSize(headerFontSize)
        
        //Set headerPosition
        headerLabel.center = CGPoint(x: 10, y: lastLabel.center.y + sectionPadding)
        view.addSubview(headerLabel)
        
        //loop through array and create list with array data
        for i in 0 ..< with.count {
            let dataLabel = UILabel()
            //Format string (possibly attributed string formatting HERE.
            dataLabel.text = with[i]
            dataLabel.font = dataLabel.font.withSize(dataLabelFontSize)
            dataLabel.center = CGPoint(x: 15, y: lastLabel.center.y + verticalPadding)
            lastLabel = dataLabel   //Set the last label so we can access it's position next time we loop through to set!
            view.addSubview(dataLabel)
        }
    }

}
