//
//  ConfirmItemVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit
import CoreData

class ConfirmItemVC: UIGameplayVC {
    
    func retrieveItem(identifier: String) -> [NSManagedObject] {
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
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
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
            let image = imageView(view: iconView, image: itemImage!)
            iconView.addSubview(image)
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
                
                let savedSkins = retrieveItem(identifier: "Skin")
                
                if skinsList[itemIndex].purchased {
                    currentSkin = skinsList[itemIndex]
                } else {
                    currentSkin = skinsList[itemIndex]
                    skinsList[itemIndex].purchased = true
                    
                    //save updated skin to core data
                    savedSkins[itemIndex].setValue(true, forKey: "purchased")
                    saveContext()
                    currentStarsCount -= itemCost
                    retrieveItem(identifier: "Player")[0].setValue(currentStarsCount, forKey: "stars")
                    saveContext()
                }
                
                for i in 2...8{
                    savedSkins[i - 1].setValue(itemIndex, forKey: "equippedIndex")
                }
                saveContext()
                
            case CustomizeTypes.soundEffects?:
                let savedSounds = retrieveItem(identifier: "Sound")
                if soundsList[itemIndex].purchased {
                    currentSound = soundsList[itemIndex]
                } else {
                    currentSound = soundsList[itemIndex]
                    soundsList[itemIndex].purchased = true
                    savedSounds[itemIndex].setValue(true, forKey: "purchased")
                    currentStarsCount -= itemCost
                    retrieveItem(identifier: "Player")[0].setValue(currentStarsCount, forKey: "stars")
                    saveContext()
                }
                for i in 2...8{
                    savedSounds[i - 1].setValue(itemIndex, forKey: "equippedIndex")
                }
                saveContext()
                
            case CustomizeTypes.themes?:
                
                //retrieve whwther it has been purchased from core data
                
                let savedThemes = retrieveItem(identifier: "Theme")
                
                // check value of bool 'purchased'
                if themesList[itemIndex].purchased {
                    currentTheme = themesList[itemIndex]
                } else {
                    
                    currentTheme = themesList[itemIndex]
                    themesList[itemIndex].purchased = true
                    
                    //save the value of puchased to core data
                    savedThemes[itemIndex].setValue(true, forKey: "purchased")
                    saveContext()
                    currentStarsCount -= itemCost
                    retrieveItem(identifier: "Player")[0].setValue(currentStarsCount, forKey: "stars")
                    saveContext()
                }
                
                //save last equipped into core data
                for i in 2...8{
                    savedThemes[i - 1].setValue(itemIndex, forKey: "equippedIndex")
                }
                saveContext()
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
