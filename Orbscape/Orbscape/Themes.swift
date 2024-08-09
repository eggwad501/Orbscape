//
//  Themes.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import Foundation
import UIKit

class Themes {
    var colors: Array<CGColor>
    var name: String
    var cost: Int
    var purchased: Bool = false
    var icon: UIImage
    
    init (colors: Array<CGColor>, name: String, cost: Int, icon: UIImage) {
        self.colors = colors
        self.name = name
        self.cost = cost
        self.icon = icon
    }
    
    func purchaseItem(stars: Int) -> Int {
        if stars > self.cost {
            self.purchased = true
            return stars - self.cost
        }
        return -1
    }
}
