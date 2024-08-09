//
//  UIGameplayVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit
import SwiftUI

var backgroundColors: Array<CGColor> = [
    CGColor(red: 0.74, green: 0.33, blue: 0.44, alpha: 1.0),
    CGColor(red: 0.98, green: 0.64, blue: 0.44, alpha: 1.0)]


class UIGameplayVC: UIViewController {
    var gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = backgroundColors
        gradientLayer.name = "gradientLayer"
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // hide Navigation Bar
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // show Navigation Bar
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
