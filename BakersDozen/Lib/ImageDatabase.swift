//
//  ImageDatabase.swift
//  BakersDozen
//
//  Created by Juri Kiin on 5/2/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import Foundation

class ImageDatabase {
    
    static let imageDatabase = ImageDatabase()
    var images: [String] = []
    
    func addImage(name: String) {
        images.append(name)
    }
    
    
}
