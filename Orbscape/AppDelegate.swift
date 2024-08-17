//
//  AppDelegate.swift
//  Orbscape
//
//  Created by Nhat Tran on 7/25/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        localStore = PurchasableItems()
        // fetches user's background themes
        let request: NSFetchRequest<Theme> = Theme.fetchRequest()
        do {
            
            //creating core data
            let count = try context.count(for: request)
            if count == 0 {
                // No data found, initialize default data
                for _ in 1...8 {
                    let newObject = Theme(context: context)
                    newObject.purchased = false
                    newObject.equippedIndex = 0
                }
                localStore.saveContext()
            }
        } catch {
            print("Failed to fetch count: \(error.localizedDescription)")
        }
        // fetches user's ball skin
        let requestTwo: NSFetchRequest<Skin> = Skin.fetchRequest()
        do {
            let count = try context.count(for: requestTwo)
            if count == 0 {
                // No data found, initialize default data
                for _ in 1...8 {
                    let newObject = Skin(context: context)
                    newObject.purchased = false
                    newObject.equippedIndex = 0
                }
                localStore.saveContext()
            }
        } catch {
            print("Failed to fetch count: \(error.localizedDescription)")
        }
        // fetches user's sound effects
        let requestThree: NSFetchRequest<Sound> = Sound.fetchRequest()
        do {
            let count = try context.count(for: requestThree)
            if count == 0 {
                // No data found, initialize default data
                for _ in 1...8 {
                    let newObject = Sound(context: context)
                    newObject.purchased = false
                    newObject.equippedIndex = 0
                }
                localStore.saveContext()
            }
        } catch {
            print("Failed to fetch count: \(error.localizedDescription)")
        }
        // fetches player's saved stars
        let requestFour: NSFetchRequest<Player> = Player.fetchRequest()
        do {
            let count = try context.count(for: requestFour)
            if count == 0 {
                let newObject = Player(context: context)
                newObject.stars = 1000
                newObject.runTime = 0
                localStore.saveContext()
            }
        } catch {
            print("Failed to fetch count: \(error.localizedDescription)")
        }
        // fetches music and sound volume
        let requestFive: NSFetchRequest<Insets> = Insets.fetchRequest()
        do {
            let count = try context.count(for: requestFive)
            if count == 0 {
                // No data found, initialize default data
                for _ in 1...8 {
                    let newObject = Insets(context: context)
                    newObject.musicVal = 0.5
                    newObject.soundVal = 0.5
                }
                localStore.saveContext()
            }
        } catch {
            print("Failed to fetch count: \(error.localizedDescription)")
        }
        
        
        
        // Override point for customization after application launch.
        // PLay background music
        BackgroundMusic.shared.playMusic()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        BackgroundMusic.shared.stopMusic()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        BackgroundMusic.shared.playMusic()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Orbscape")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

