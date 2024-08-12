//
//  Themes.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import Foundation
import UIKit
import AVFoundation

class PurchasableItems {
    var name: String
    var cost: Int
    var purchased: Bool = false
    
    init(name: String, cost: Int) {
        self.name = name
        self.cost = cost
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
    
    init (colors: Array<CGColor>, name: String, cost: Int) {
        self.colors = colors
        super.init(name: name, cost: cost)
    }
}

class Skins: PurchasableItems {
    var skin: UIImage
    
    init (skin: UIImage, name: String, cost: Int) {
        self.skin = skin
        super.init(name: name, cost: cost)
    }
}

class SoundEffects: PurchasableItems {
    var sound: URL
    
    init (sound: URL, name: String, cost: Int) {
        self.sound = sound
        super.init(name: name, cost: cost)
    }
}
