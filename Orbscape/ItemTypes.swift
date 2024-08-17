//
//  Themes.swift
//  Orbscape
//
// Project: Orbscape
// EID: nmt736, rw28469, ss79767, nae596
// Course: CS371L

import Foundation
import UIKit
import AVFoundation
import CoreData

// parent class for all the purchasable items
class PurchasableItems {
    var name: String
    var cost: Int
    var purchased: Bool = false
    
    // retrieves the item from core data
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
    
    // saves to core data
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // TODO: delete?
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
    init(){
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
    
    // checks if an item if they're the same item
    func equals(compareTo: PurchasableItems) -> Bool {
        return
            self.name == compareTo.name &&
            self.cost == compareTo.cost &&
            self.purchased == compareTo.purchased
    }
}

// theme object
class Themes: PurchasableItems {
    var colors: Array<CGColor>
    
    // initialize theme object
    init (colors: Array<CGColor>, name: String, cost: Int, ind: Int, id: String) {
        self.colors = colors
        super.init(name: name, cost: cost, ind: ind, id: id)
    }
    
    // initialize purchased theme object
    init (colors: Array<CGColor>, name: String, cost: Int, ind: Int, id: String, purchase: Bool) {
        self.colors = colors
        super.init(name: name, cost: cost, ind: ind, id: id)
        self.purchased = purchase
    }
}

// skin object
class Skins: PurchasableItems {
    var skin: UIImage
    
    // initialize skin object
    init (skin: UIImage, name: String, cost: Int, ind: Int, id: String) {
        self.skin = skin
        super.init(name: name, cost: cost, ind: ind, id: id)
    }
    
    // initialize purchased skin object
    init (skin: UIImage, name: String, cost: Int, ind: Int, id: String, purchase: Bool) {
        self.skin = skin
        super.init(name: name, cost: cost, ind: ind, id: id)
        self.purchased = purchase
    }
}

// sound object
class SoundEffects: PurchasableItems {
    var sound: URL
    var image = UIImage(named: "audioIcon")
    
    // initialize sound object
    init (sound: URL, name: String, cost: Int, ind: Int, id: String) {
        self.sound = sound
        super.init(name: name, cost: cost, ind: ind, id: id)
    }
    
    // initialize purchased sound object
    init (sound: URL, name: String, cost: Int, ind: Int, id: String, purchase: Bool) {
        self.sound = sound
        super.init(name: name, cost: cost, ind: ind, id: id)
        self.purchased = purchase
    }
}
