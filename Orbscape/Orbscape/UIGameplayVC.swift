//
//  UIGameplayVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit
import SwiftUI

// the parent of most vc in this game
// controls the gradient background in every vc
class UIGameplayVC: UIViewController {
    var gradientLayer = CAGradientLayer()

    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // updates gradient in every vc
    override func viewIsAppearing(_ animated: Bool) {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = currentTheme.colors
        gradientLayer.name = "gradientLayer"
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // ball display rotation animation
    func ballAnimation(view: UIView) {
        UIView.animate (
            withDuration: 4.0,
            delay: 0.0,
            options: [.repeat, .autoreverse, .curveEaseInOut],
            animations: {
                view.transform = view.transform.rotated(by: CGFloat(Double.pi))
            }
        )
    }
    
    // hide Navigation Bar
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // show Navigation Bar
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // converts image; processed to be add to a UIView
    func imageView(view: UIView, image: UIImage) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.frame = view.bounds
        imageView.backgroundColor = UIColor.clear
        return imageView
    }
    
    // converts gradient; processed to be add to a UIVie
    func gradientView(view: UIView, colors: Array<CGColor>) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colors
        gradient.cornerRadius = 20.0
        view.layer.cornerRadius = 20.0
        return gradient
    }
}
