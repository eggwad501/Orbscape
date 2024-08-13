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
    var indexx: Int
    var purchased: Bool = false
    
    func retrieveItem(identifier: String) -> [NSManagedObject]{
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
    
    init(name: String, cost: Int, ind: Int, id: String) {
        
        self.name = name
        self.cost = cost
        self.indexx = ind
        
        let results = retrieveItem(identifier: id)
        if let isPurchased = (results[ind].value(forKey: "purchased")) as? Bool{
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
}

class Skins: PurchasableItems {
    var skin: UIImage
    
    init (skin: UIImage, name: String, cost: Int, ind: Int, id: String) {
        self.skin = skin
        super.init(name: name, cost: cost, ind: ind, id: id)
    }
}

class SoundEffects: PurchasableItems {
    var sound: URL
    
    init (sound: URL, name: String, cost: Int, ind: Int, id: String) {
        self.sound = sound
        super.init(name: name, cost: cost, ind: ind, id: id)
    }
}
