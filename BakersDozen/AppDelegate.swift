//
//  AppDelegate.swift
//  BakersDozen
//
//  Created by Juri Kiin on 4/2/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //Thread.sleep(forTimeInterval: 1.5)
        
//        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: "recipes.json")
//        let success = NSKeyedArchiver.archiveRootObject(RecipeData.sharedData.recipes, toFile: pathToFile.path)
//        if success {
//            RecipeData.sharedData.recipes = NSArray(contentsOf: pathToFile) as! [Recipe]
//            print(RecipeData.sharedData.recipes.count)
//        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("About to close")
//        let recipes = RecipeData.sharedData.recipes
//        // Get the url of Persons.json in document directory
//        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        let fileUrl = documentDirectoryUrl.appendingPathComponent("recipes.json")
//        
//        // Transform array into data and save it into file
//        do {
//            let data = try JSONSerialization.data(withJSONObject: recipes, options: [])
//            try data.write(to: fileUrl, options: [])
//            print("Successfully saved recipes: \(recipes.count)")
//        } catch {
//            print(error)
//        }
    }


}
