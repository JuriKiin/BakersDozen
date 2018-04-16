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
    let verticalPadding: CGFloat = 15
    let sectionPadding: CGFloat = 20
    var lastLabel: UILabel!
    @IBOutlet var pageTitle: UINavigationItem!
    
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Based on rating, disable the correct number of stars.
        
        //Load content
        pageTitle.title = recipe.title
        imageView.image = recipe.image
        FillContent(name: "Ingredients", with: recipe.ingredients)
        FillContent(name: "Directions", with: recipe.directions)
        AddNotes(notes: recipe.notes)
    }
    
    func FillContent(name: String, with: [Any]) {
        //Create header
        let headerLabel = UILabel()
        headerLabel.text = name
        headerLabel.font = headerLabel.font.withSize(headerFontSize)
        
        //Set headerPosition
        if lastLabel == nil {
            headerLabel.center = CGPoint(x: 10, y: imageView.frame.maxY + sectionPadding)
        } else {
            headerLabel.center = CGPoint(x: 10, y: lastLabel.center.y + sectionPadding)
        }
        lastLabel = headerLabel
        headerLabel.sizeToFit()
        view.addSubview(headerLabel)
        
        if name == "Directions" {
            let directions = with as! [Direction]
            for i in 0 ..< with.count {
                let dataLabel = UILabel()
                //Format string (possibly attributed string formatting HERE.
                dataLabel.text = directions[i].data
                dataLabel.font = dataLabel.font.withSize(dataLabelFontSize)
                dataLabel.center = CGPoint(x: 15, y: lastLabel.center.y + verticalPadding)
                lastLabel = dataLabel   //Set the last label so we can access it's position next time we loop through to set!
                dataLabel.sizeToFit()
                view.addSubview(dataLabel)
            }
        } else {
            let content = with as! [String]
            //loop through array and create list with array data
            for i in 0 ..< with.count {
                let dataLabel = UILabel()
                //Format string (possibly attributed string formatting HERE.
                dataLabel.text = content[i]
                dataLabel.font = dataLabel.font.withSize(dataLabelFontSize)
                dataLabel.center = CGPoint(x: 15, y: lastLabel.center.y + verticalPadding)
                lastLabel = dataLabel   //Set the last label so we can access it's position next time we loop through to set!
                dataLabel.sizeToFit()
                view.addSubview(dataLabel)
            }
        }
    }
    
    func AddNotes(notes: String) {
        let headerLabel = UILabel()
        headerLabel.text = "Notes"
        headerLabel.font = headerLabel.font.withSize(headerFontSize)
        
        //Set headerPosition
        if lastLabel == nil {
            headerLabel.center = CGPoint(x: 10, y: imageView.frame.maxY + sectionPadding)
        } else {
            headerLabel.center = CGPoint(x: 10, y: lastLabel.center.y + sectionPadding)
        }
        lastLabel = headerLabel
        
        let noteText = UITextView()
        noteText.text = notes
        
        noteText.center = CGPoint(x: 10, y: lastLabel.frame.maxY + verticalPadding + 20)
        
        headerLabel.sizeToFit()
        noteText.sizeToFit()
        view.addSubview(headerLabel)
        view.addSubview(noteText)
    }
    
    //End Of Class
}
