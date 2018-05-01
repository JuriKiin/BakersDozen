//
//  Recipe.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/2/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class Direction: NSObject, Codable {
    var data: String
    var ingredients: [Ingredient]
    var hasTimer: Bool
    var isNewDirection: Bool
    var index: Int
    
    enum CodingKeys: String, CodingKey {
        case data
        case ingredients
        case hasTimer
        case isNewDirection
        case index
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.data = try values.decode(String.self, forKey: CodingKeys.data)
        self.ingredients = try values.decode([Ingredient].self, forKey: CodingKeys.ingredients)
        self.hasTimer = try values.decode(Bool.self, forKey: CodingKeys.hasTimer)
        self.isNewDirection = try values.decode(Bool.self, forKey: CodingKeys.isNewDirection)
        self.index = try values.decode(Int.self, forKey: CodingKeys.index)
    }
    
    
    override init() {
        data = ""
        hasTimer = false
        ingredients = []
        isNewDirection = true
        index = -1
    }
    init(data: String, hasTimer: Bool, ingredients: [Ingredient]) {
        self.data = data
        self.hasTimer = hasTimer
        self.ingredients = ingredients
        isNewDirection = true
        index = -1
    }
}

class Ingredient: NSObject, Codable {
    var data: String
    var isNewIngredient: Bool
    var index: Int
    
    
    enum CodingKeys: String, CodingKey {
        case data
        case isNewIngredient
        case index
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.data = try values.decode(String.self, forKey: CodingKeys.data)
        self.isNewIngredient = try values.decode(Bool.self, forKey: CodingKeys.isNewIngredient)
        self.index = try values.decode(Int.self, forKey: CodingKeys.index)
    }
    
    override init() {
        data = ""
        isNewIngredient = true
        index = -1
    }
    
    init(data: String, isNew: Bool, atIndex: Int) {
        self.data = data
        self.isNewIngredient = isNew
        self.index = atIndex
    }
    
    func isEqual(other: Ingredient) -> Bool {
        return data == other.data && isNewIngredient == other.isNewIngredient
    }
    
}


public struct RecipeList {
    var recipes: [Recipe]
    init() {
        recipes = [Recipe]()
    }
}

class Recipe: NSObject {
    
    var title: String
    var image: UIImage?
    var rating: Int {
        didSet{
            if oldValue < 0 {
                rating = 0
            }
        }
    }
    var _id: String
    var ingredients:[Ingredient]
    var directions:[Direction]
    var notes:String
    
    //App vars (for displaying recipe)
    var color: UIColor
    
    enum CodingKeys: String, CodingKey {
        case title
        case image
        case rating
        case _id
        case ingredients
        case directions
        case notes
        case color
    }
    //Default init.
    override init(){
        title = ""
        rating = 0
        ingredients = []
        directions = []
        notes = ""
        _id = ""
        color = .white
    }
    
    //Helper init
    init(title: String, rating: Int, ingredients: [Ingredient], directions: [Direction], notes: String, image: UIImage){
        self.title = title
        self.rating = rating
        self.ingredients = ingredients
        self.directions = directions
        self.notes = notes
        self._id = ""
        self.image = image
        self.color = .white
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.title = try values.decode(String.self, forKey: CodingKeys.title)
        } catch {
            self.title = "New Recipe"
        }
        self.rating = try values.decode(Int.self, forKey: CodingKeys.rating)
        self.ingredients = try values.decode([Ingredient].self, forKey: CodingKeys.ingredients)
        self.directions = try values.decode([Direction].self, forKey: CodingKeys.directions)
        self.notes = try values.decode(String.self, forKey: CodingKeys.notes)
        self._id = try values.decode(String.self, forKey: CodingKeys._id)
        
        let imageURL = try values.decode(String.self, forKey: CodingKeys.image)
        self.image = UIImage(named: imageURL)
        let color = try values.decode([CGFloat].self, forKey: CodingKeys.color)
        self.color = UIColor(red: color[0], green: color[1], blue: color[2], alpha: color[3])
    }
    
    
    //Generates a new ID for the recipe.
    func GenerateNewId() {
        self._id = NSUUID().uuidString
    }
    
    func SetColor(){
        
        let colors:[UIColor] = [
            UIColor(red: 219/255, green: 213/255, blue: 110/255, alpha: 1),
            UIColor(red: 136/255, green: 171/255, blue: 117/255, alpha: 1),
            UIColor(red: 45/255, green: 147/255, blue: 173/255, alpha: 1),
            UIColor(red: 125/255, green: 124/255, blue: 132/255, alpha: 1),
            UIColor(red: 136/255, green: 171/255, blue: 117/255, alpha: 1),
            UIColor(red: 222/255, green: 143/255, blue: 110/255, alpha: 1),
            ]
        let random = Int(arc4random_uniform(UInt32(colors.count)))
        self.color = colors[random]
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

