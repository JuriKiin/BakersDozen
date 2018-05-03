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
        
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: "recipes.json")
        do {
            print(pathToFile.path)
            let data = try Data.init(contentsOf: pathToFile, options: [])
            let recipes = try JSONDecoder().decode([Recipe].self, from: data)
            print("Success Getting something")
            RecipeData.sharedData.recipes = recipes
        } catch {
            print("Retrieve Failed")
            print(error)
            RecipeData.sharedData.recipes = []  //If we fail, make it empty...
        }
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
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: "recipes.json")
        let recipes = RecipeData.sharedData.recipes
        do {
            let data = try JSONEncoder().encode(recipes)
            try data.write(to: pathToFile)
            print(pathToFile.path)
        } catch {
            print("Save Failed")
        }
    }


}
