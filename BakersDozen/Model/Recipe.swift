//
//  Recipe.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/2/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class Direction: Codable {
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(hasTimer, forKey: .hasTimer)
        try container.encode(isNewDirection, forKey: .isNewDirection)
        try container.encode(index, forKey: .index)
    }
    
    init() {
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

class Ingredient: Codable {
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(isNewIngredient, forKey: .isNewIngredient)
        try container.encode(isSelected, forKey: .isSelected)
        try container.encode(index, forKey: .index)
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.data = try values.decode(String.self, forKey: CodingKeys.data)
        self.isNewIngredient = try values.decode(Bool.self, forKey: CodingKeys.isNewIngredient)
        self.index = try values.decode(Int.self, forKey: CodingKeys.index)
        self.isSelected = try values.decode(Bool.self, forKey: CodingKeys.isSelected)
    }
    
    init() {
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

class Recipe: Codable {
    
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
    
    //Default init.
    init(){
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(rating, forKey: .rating)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(directions, forKey: .directions)
        try container.encode(notes, forKey: .notes)
        try container.encode(_id, forKey: ._id)
        try container.encode(image, forKey: .image)
        try container.encode(color, forKey: .color)
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

