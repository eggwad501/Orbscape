//
//  ballAnimationView.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/7/24.
//

import Foundation
import UIKit

// creating balls for home screen VC
class ballAnimationView: UIView {
    var fillColor: UIColor
    var horzPos: Int
    var distance: Int
    var duration: Float
    
    // initializes values for the ball
    required init(fillColor: UIColor, horzPos: Int, distance: Int, duration: Float) {
        self.fillColor = fillColor
        self.horzPos = horzPos
        self.distance = distance
        self.duration = duration
        super.init(frame: .zero)
    }
    
    // catch error
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // draw the ball
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
    }
}
