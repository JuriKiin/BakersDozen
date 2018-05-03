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
        case data = "data"
        case ingredients = "ingredients"
        case hasTimer = "hasTimer"
        case isNewDirection = "isNewDirection"
        case index = "index"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.data = try values.decode(String.self, forKey: CodingKeys.data)
        self.ingredients = try values.decode([Ingredient].self, forKey: CodingKeys.ingredients)
        self.hasTimer = try values.decode(Bool.self, forKey: CodingKeys.hasTimer)
        self.isNewDirection = try values.decode(Bool.self, forKey: CodingKeys.isNewDirection)
        self.index = try values.decode(Int.self, forKey: CodingKeys.index)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(data, forKey: CodingKeys.data.rawValue)
        aCoder.encode(ingredients, forKey: CodingKeys.ingredients.rawValue)
        aCoder.encode(hasTimer, forKey: CodingKeys.hasTimer.rawValue)
        aCoder.encode(isNewDirection, forKey: CodingKeys.isNewDirection.rawValue)
        aCoder.encode(index, forKey: CodingKeys.index.rawValue)
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
    var isSelected: Bool
    var index: Int
    
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case isNewIngredient = "isNewIngredient"
        case index = "index"
        case isSelected = "isSelected"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(data, forKey: CodingKeys.data.rawValue)
        aCoder.encode(isNewIngredient, forKey: CodingKeys.isNewIngredient.rawValue)
        aCoder.encode(index, forKey: CodingKeys.index.rawValue)
        aCoder.encode(isSelected, forKey: CodingKeys.isSelected.rawValue)
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.data = try values.decode(String.self, forKey: CodingKeys.data)
        self.isNewIngredient = try values.decode(Bool.self, forKey: CodingKeys.isNewIngredient)
        self.index = try values.decode(Int.self, forKey: CodingKeys.index)
        self.isSelected = try values.decode(Bool.self, forKey: CodingKeys.isSelected)
    }
    
    override init() {
        data = ""
        isNewIngredient = true
        index = -1
        isSelected = false
    }
    
    init(data: String, isNew: Bool, atIndex: Int, isSelected: Bool) {
        self.data = data
        self.isNewIngredient = isNew
        self.index = atIndex
        self.isSelected = isSelected
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

class Recipe: NSObject, Codable {
    
    var title: String
    var image: Data
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
    var color: [CGFloat]
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case image = "image"
        case rating = "rating"
        case _id = "_id"
        case ingredients = "ingredients"
        case directions = "directions"
        case notes = "notes"
        case color = "color"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(title, forKey: CodingKeys.title.rawValue)
        aCoder.encode(image, forKey: CodingKeys.image.rawValue)
        aCoder.encode(rating, forKey: CodingKeys.rating.rawValue)
        aCoder.encode(_id, forKey: CodingKeys._id.rawValue)
        aCoder.encode(ingredients, forKey: CodingKeys.ingredients.rawValue)
        aCoder.encode(directions, forKey: CodingKeys.directions.rawValue)
        aCoder.encode(notes, forKey: CodingKeys.notes.rawValue)
        aCoder.encode(color, forKey: CodingKeys.color.rawValue)
    }
    
    
    //Default init.
    override init(){
        title = ""
        rating = 0
        ingredients = []
        directions = []
        notes = ""
        _id = ""
        color = [1,1,1,1] as [CGFloat]
        image = Data.init()
    }
    
    //Helper init
    init(title: String, rating: Int, ingredients: [Ingredient], directions: [Direction], notes: String, image: Data){
        self.title = title
        self.rating = rating
        self.ingredients = ingredients
        self.directions = directions
        self.notes = notes
        self._id = ""
        self.image = image
        self.color = [1,1,1,1] as [CGFloat]
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
        self.image = try values.decode(Data.self, forKey: CodingKeys.image)
        self.color = try values.decode([CGFloat].self, forKey: CodingKeys.color)
    }
    
    
    //Generates a new ID for the recipe.
    func GenerateNewId() {
        self._id = NSUUID().uuidString
    }
    
    func SetColor(){
        
        let colors:[[CGFloat]] = [
            [CGFloat(219.0/255.0), CGFloat(213.0/255.0), CGFloat(110.0/255.0), CGFloat(1.0)],
            [CGFloat(136.0/255.0),CGFloat(171.0/255.0),CGFloat(117.0/255.0),CGFloat(1.0)],
            [CGFloat(45.0/255.0),CGFloat(147.0/255.0),CGFloat(173.0/255.0),CGFloat(1.0)],
            [CGFloat(125.0/255.0),CGFloat(124.0/255.0),CGFloat(132.0/255.0),CGFloat(1.0)],
            [CGFloat(222.0/255.0),CGFloat(143.0/255.0),CGFloat(110.0/255.0),CGFloat(1.0)]
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
    static func random() -> [CGFloat] {
        
        return [CGFloat(.random()),CGFloat(.random()),CGFloat(.random()),CGFloat(1.0)]
    }
}

