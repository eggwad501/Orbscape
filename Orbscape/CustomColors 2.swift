//
//  CustomColors.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/15/24.
//

import Foundation
import UIKit

extension UIColor {
    
    // create a similar color for maze edges
    func edgeColors() -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(
                red: min(red * 0.9, 1.0),
                green: min(green * 0.8, 1.0),
                blue: min(blue * 0.9, 1.0),
                alpha: alpha)
         } else {
             return self
         }
    }
}


