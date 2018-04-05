//
//  FileManagerExtension.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/3/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

extension FileManager {
    
    static var documentsDirectory:URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
    }
    
    static var cachesDirectory:URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as URL
    }
    
    static var  tempDirectory:URL {
        return FileManager.default.temporaryDirectory
    }
    
    static func filePathInDocumentsDirectory(fileName:String) ->URL{
        return FileManager.documentsDirectory.appendingPathComponent(fileName)
    }
    
    static func fileExistsInDocumentsDirectory(fileName:String) -> Bool {
        let path = filePathInDocumentsDirectory(fileName: fileName).path
        return FileManager.default.fileExists(atPath:path)
    }
    
    static func deleteFileInDocumentsDirectory(fileName:String) {
        let path = filePathInDocumentsDirectory(fileName: fileName).path
        do {
            try FileManager.default.removeItem(atPath: path)
            print("FILE: \(path) was deleted.")
        } catch {
            print("Error: \(error) - FOR FILE: \(path)")
        }
    }
    
    static func contentsOfDir(url:URL) -> [String] {
        do {
            if let paths = try FileManager.default.contentsOfDirectory(atPath: url.path) as [String]? {
                return paths
            } else {
                print("Nothing found.")
                return [String]()
            }
        } catch {
            print("ERROR: \(error)")
            return [String]()
        }
    }
    
    static func clearDocumentsFolder() {
        let fileManager = FileManager.default
        let docsFolderPath = FileManager.documentsDirectory.path
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: docsFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: docsFolderPath + "/" + filePath)
            }
            print("Cleared documents folder")
        } catch {
            print("could not clear documents folder: \(error)")
        }
    }
}

extension UIImage{
    func saveImageAsPNG(url:URL) {
        let pngData = UIImagePNGRepresentation(self)
        do{
            try pngData?.write(to: url)
        } catch {
            print("Error: saving \(url) - error=\(error)")
        }
    }
}
