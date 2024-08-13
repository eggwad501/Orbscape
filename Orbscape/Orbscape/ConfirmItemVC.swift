//
//  ConfirmItemVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit

class ConfirmItemVC: UIGameplayVC {
    var delegate: UIGameplayVC!
    
    var itemImage: UIImage?
    var itemName: String = ""
    var itemCost: Int = -1
    var itemIndex: Int = -1
    var itemColors: Array<CGColor>!
    
    var selectedIdentifier = "selectedIdentifier"
    var types: CustomizeTypes!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var iconView: UIView!
    
    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popoverPresentationController?.backgroundColor = UIColor.clear
    }
    
    // empty; so there would be no gradient applied in this view controller
    override func viewIsAppearing(_ animated: Bool) {
    }
    
    // updates the values before the screen is shown
    override func viewWillAppear(_ animated: Bool) {
        // image
        iconView.backgroundColor = UIColor.clear
        nameLabel.text = "\(itemName)"
        costLabel.text = ""
        starCountLabel.text = "\(currentStarsCount) ★"
        
        switch types {
        case CustomizeTypes.skins?:
            let image = imageView(view: iconView, image: itemImage!)
            iconView.addSubview(image)
            if !skinsList[itemIndex].purchased {
                costLabel.text = "\(itemCost) ★"
            }
            
        case CustomizeTypes.soundEffects?:
            if !soundsList[itemIndex].purchased {
                costLabel.text = "\(itemCost) ★"
            }
            break
            
        case CustomizeTypes.themes?:
            let gradient = gradientView(view: iconView, colors: itemColors)
            iconView.layer.insertSublayer(gradient, at: 0)
            if !themesList[itemIndex].purchased {
                costLabel.text = "\(itemCost) ★"
            }
            
        default:
            break
        }
    }
    
    // update the game with the selected theme
    @IBAction func confirmButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        super.showNavigationBar()
        
        let vc = delegate as! ItemSelectChanger
        vc.removeBlurredBackgroundView()
                
        if itemIndex != -1 {
            switch types {
            case CustomizeTypes.skins?:
                if skinsList[itemIndex].purchased {
                    currentSkin = skinsList[itemIndex]
                } else {
                    currentSkin = skinsList[itemIndex]
                    skinsList[itemIndex].purchased = true
                    currentStarsCount -= itemCost
                }
                
            case CustomizeTypes.soundEffects?:
                if soundsList[itemIndex].purchased {
                    currentSound = soundsList[itemIndex]
                } else {
                    currentSound = soundsList[itemIndex]
                    soundsList[itemIndex].purchased = true
                    currentStarsCount -= itemCost
                }
                
            case CustomizeTypes.themes?:
                if themesList[itemIndex].purchased {
                    currentTheme = themesList[itemIndex]
                } else {
                    currentTheme = themesList[itemIndex]
                    themesList[itemIndex].purchased = true
                    currentStarsCount -= itemCost
                }
                vc.updateBackground(index: itemIndex)
                
            default:
                break
            }
            vc.updateScreen(starCount: currentStarsCount)
        }
    }
    
    // dismiss the confirmation
    @IBAction func quitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        let themeVC = delegate as! ItemSelectChanger
        themeVC.removeBlurredBackgroundView()
    }

}
