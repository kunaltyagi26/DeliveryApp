//
//  AppDelegate.swift
//  DeliveryApp
//
//  Created by Kunal on 14/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import Firebase

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let apiKey = "AIzaSyBf9CKepAdOD45IJPJZKlWXlIrXYVq8b30"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController: UINavigationController?
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window {
            let mainVC = HomeVC()
            navigationController = UINavigationController(rootViewController: mainVC)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        
        NavigationBarTheme.instance.changeFont()
        
        GMSServices.provideAPIKey(apiKey)
        FirebaseApp.configure()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DeliveryApp")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
