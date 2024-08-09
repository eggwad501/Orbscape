//
//  ConfirmItemVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit

class ConfirmItemVC: UIGameplayVC {
    var delegate: UIGameplayVC!
    
    var itemIcon: UIImage?
    var itemName: String = ""
    var itemCost: Int = -1
    var itemIndex: Int = -1
    
    var selectedIdentifier = "selectedIdentifier"
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popoverPresentationController?.backgroundColor = UIColor.clear
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        // so there would be no gradient applied in this view controller
    }
    
    // updates the values before the screen is shown
    override func viewWillAppear(_ animated: Bool) {
        iconImageView.image = itemIcon
        nameLabel.text = "\(itemName)"
        costLabel.text = "\(itemCost) ★"
    }
    
    // update the game with the selected theme
    @IBAction func confirmButton(_ sender: Any) {
        if itemIndex != -1 {
            backgroundColors = themesList[itemIndex].colors
            self.dismiss(animated: true, completion: nil)
            super.showNavigationBar()
            
            let themeVC = delegate as! blurBackgroundChanger
            themeVC.removeBlurredBackgroundView()
            themeVC.updateBackground(colors: backgroundColors)
        }
    }
    
    // dismiss the confirmation
    @IBAction func quitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        let themeVC = delegate as! blurBackgroundChanger
        themeVC.removeBlurredBackgroundView()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == selectedIdentifier,
           let destination = segue.destination as? ThemesVC {
            destination.delegate = self
            //destination.colorsSelected = themesList[itemIndex].colors
        }
    }

}
