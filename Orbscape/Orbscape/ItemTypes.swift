//
//  Themes.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import Foundation
import UIKit
import AVFoundation
import CoreData

class PurchasableItems {
    var name: String
    var cost: Int
    var purchased: Bool = false
    
    func retrieveItem(identifier: String) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: identifier)
        var fetchedResults: [NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            print("Error occured while retrieving data")
            abort()
        }
        return fetchedResults!
    }
    
    func saveContext() {
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
    
    func clearAllEntities(from context: NSManagedObjectContext) {
        // List of all entity names
        guard let entityNames = context.persistentStoreCoordinator?.managedObjectModel.entitiesByName.keys else {
                print("Unable to fetch entity names.")
                return
            }            
            
        // Iterate over each entity
        for entityName in entityNames {
            // Create a fetch request for each entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            // Create a batch delete request
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(batchDeleteRequest)
                try context.save()
            } catch {
                print("Error clearing entity \(entityName): \(error)")
            }
        }
    }
    
    //for using above functions
    init() {
        name = ""
        cost = 0
    }
    
    //for actual initializiation
    init (name: String, cost: Int, ind: Int, id: String) {
        self.name = name
        self.cost = cost
        
        let results = retrieveItem(identifier: id)
        if let isPurchased = (results[ind].value(forKey: "purchased")) as? Bool {
            self.purchased = isPurchased
        }
    }
    
    func purchaseItem(stars: Int) -> Int {
        if stars > self.cost {
            self.purchased = true
            return stars - self.cost
        }
        return -1
    }
    
    func equals(compareTo:PurchasableItems) -> Bool {
        return
            self.name == compareTo.name &&
            self.cost == compareTo.cost &&
            self.purchased == compareTo.purchased
    }
}

class Themes: PurchasableItems {
    var colors: Array<CGColor>
    
    init (colors: Array<CGColor>, name: String, cost: Int, ind: Int, id: String) {
        self.colors = colors
        super.init(name: name, cost: cost, ind: ind, id: id)
    }
    
    init (colors: Array<CGColor>, name: String, cost: Int, ind: Int, id: String, purchase: Bool) {
        self.colors = colors
        super.init(name: name, cost: cost, ind: ind, id: id)
        self.purchased = purchase
    }
}

class Skins: PurchasableItems {
    var skin: UIImage
    
    init (skin: UIImage, name: String, cost: Int, ind: Int, id: String) {
        self.skin = skin
        super.init(name: name, cost: cost, ind: ind, id: id)
    }
    
    init (skin: UIImage, name: String, cost: Int, ind: Int, id: String, purchase: Bool) {
        self.skin = skin
        super.init(name: name, cost: cost, ind: ind, id: id)
        self.purchased = purchase
    }
}

class SoundEffects: PurchasableItems {
    var sound: URL
    var image = UIImage(named: "audioIcon")
    
    init (sound: URL, name: String, cost: Int, ind: Int, id: String) {
        self.sound = sound
        super.init(name: name, cost: cost, ind: ind, id: id)
    }
    
    init (sound: URL, name: String, cost: Int, ind: Int, id: String, purchase: Bool) {
        self.sound = sound
        super.init(name: name, cost: cost, ind: ind, id: id)
        self.purchased = purchase
    }
}
