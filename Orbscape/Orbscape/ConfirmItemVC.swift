//
//  ConfirmItemVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit

class ConfirmItemVC: UIGameplayVC {
    var delegate: UIViewController!
    
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
        //super.gradientLayer

        // Do any additional setup after loading the view.
    }
    
    // updates the values before the screen is shown
    override func viewWillAppear(_ animated: Bool) {
        iconImageView.image = itemIcon
        nameLabel.text = "\(itemName)"
        costLabel.text = "\(itemCost)"
    }
    
    
    @IBAction func confirmButton(_ sender: Any) {
        if itemIndex != -1 {
            super.updateBackground(colors: themesList[itemIndex].colors)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == addSegueIdentifier,
//           let destination = segue.destination as? AddTimerVC {
//            destination.delegate = self
//        }
        if segue.identifier == selectedIdentifier,
           let destination = segue.destination as? ThemesVC {
            destination.delegate = self
            destination.colorsSelected = themesList[itemIndex].colors
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
