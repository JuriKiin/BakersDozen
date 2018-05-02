//
//  MakeRecipeVC.swift
//  BakersDozen
//
//  Created by Juri Kiin on 5/1/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class MakeRecipeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var recipe: Recipe!
    var currentStep: Direction!
    var count: Int = 0
    
    @IBOutlet var pageHeader: UINavigationItem!
    @IBOutlet var relatedIngredientsTable: UITableView!
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var directionLabel: UILabel!
    
    @IBAction func swipeRightGesture(_ sender: Any) {
        updateCount(withValue: -1)
        currentStep = recipe.directions[count]
        loadStep()
    }
    
    @IBAction func swipeLeftGesture(_ sender: Any) {
        updateCount(withValue: 1)
        currentStep = recipe.directions[count]
        loadStep()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageHeader.title = recipe.title
        relatedIngredientsTable.delegate = self
        relatedIngredientsTable.dataSource = self
        stepLabel.text = "Step \(count+1) out of \(recipe.directions.count)"
        stepLabel.sizeToFit()
        directionLabel.text = recipe.directions[0].data
        currentStep = recipe.directions[0]
        view.backgroundColor = recipe.color
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentStep.ingredients.count == 0 {
            return 1
        } else {
             return currentStep.ingredients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = relatedIngredientsTable.dequeueReusableCell(withIdentifier: "relatedIngredientIdentifier", for: indexPath)
        
        if currentStep.ingredients.count == 0 {
             cell.textLabel?.text = "No Ingredients"
        } else {
            cell.textLabel?.text = currentStep.ingredients[indexPath.row].data
        }
        return cell
    }
    
    //Helper func
    
    func loadStep() {
        currentStep = recipe.directions[count]
        if currentStep.hasTimer {
            drawTimer()
        }
        stepLabel.text = "Step \(count+1) out of \(recipe.directions.count)"
       // stepLabel.sizeToFit()
        directionLabel.text = recipe.directions[count].data
        relatedIngredientsTable.reloadData()
    }
    
    func drawTimer() {
        //Creating the timer
        let shapeLayer = CAShapeLayer()
        view.layer.addSublayer(shapeLayer)
        
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = recipe.color.cgColor
    }
    
    
    func updateCount(withValue: Int) {
        count += withValue
        if count <= 0 {
            count = 0
        } else if count >= recipe.directions.count {
            count = recipe.directions.count-1
        }
    }
}
