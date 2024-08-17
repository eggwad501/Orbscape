//
//  ConfirmItemVC.swift
//  Orbscape
//
// Project: Orbscape
// EID: nmt736, rw28469, ss79767, nae596
// Course: CS371L

import UIKit
import CoreData
import AVFoundation

class ConfirmItemVC: UIGameplayVC {
    
    var delegate: UIGameplayVC!
    var audioPlayer: AVAudioPlayer?
    
    var itemImage: UIImage?
    var itemName: String = ""
    var itemCost: Int = -1
    var itemIndex: Int = -1
    var itemColors: Array<CGColor>!
    var itemAudio: URL!
    
    var selectedIdentifier = "selectedIdentifier"
    var types: CustomizeTypes!
    
    var buttonText = "CONFIRM"
    @IBOutlet weak var confirmButtonText: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet var tapOutlet: UITapGestureRecognizer!
    
    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popoverPresentationController?.backgroundColor = UIColor.clear
    }
    
    // override; so there would be no gradient applied in this view controller
    override func viewIsAppearing(_ animated: Bool) {
        tapOutlet.isEnabled = false
        if types == CustomizeTypes.soundEffects {
            tapOutlet.isEnabled = true
        }
    }
    
    // updates the values before the screen is shown
    override func viewWillAppear(_ animated: Bool) {
        // image
        iconView.backgroundColor = UIColor.clear
        nameLabel.text = "\(itemName)"
        costLabel.text = ""
        starCountLabel.text = "\(currentStarsCount) ★"
        confirmButtonText.setTitle(buttonText, for: .normal)

        // displays respective item information
        switch types {
        case CustomizeTypes.skins?:
            let image = imageView(view: iconView, image: itemImage!)
            iconView.addSubview(image)
            if !skinsList[itemIndex].purchased {
                costLabel.text = "\(itemCost) ★"
            }
            break
            
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
            break
            
        default:
            break
        }
    }
    
    // tap icon for sound audio 
    @IBAction func tapIconGesture(recognizer: UITapGestureRecognizer) {
        if let player = audioPlayer, player.isPlaying {
            return
        } else {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: itemAudio)
                audioPlayer?.play()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // update the game with the selected theme
    @IBAction func confirmButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        super.showNavigationBar()
        
        localStore = PurchasableItems()
        
        let vc = delegate as! ItemSelectChanger
        vc.removeBlurredBackgroundView()
                
        if itemIndex != -1 {
            switch types {
                
            //skins
            case CustomizeTypes.skins?:
                
                let savedSkins = localStore.retrieveItem(identifier: "Skin")
                
                if skinsList[itemIndex].purchased {
                    currentSkin = skinsList[itemIndex]
                    for i in 2...8{
                        savedSkins[i - 1].setValue(itemIndex, forKey: "equippedIndex")
                    }
                    localStore.saveContext()
                } else {
                    if(currentStarsCount >= itemCost){
                        currentSkin = skinsList[itemIndex]
                        skinsList[itemIndex].purchased = true
                        
                        //save updated skin to core data
                        savedSkins[itemIndex].setValue(true, forKey: "purchased")
                        currentStarsCount -= itemCost
                        localStore.retrieveItem(identifier: "Player")[0].setValue(currentStarsCount, forKey: "stars")
                        for i in 2...8{
                            savedSkins[i - 1].setValue(itemIndex, forKey: "equippedIndex")
                        }
                        localStore.saveContext()
                    }
                }
                
            //sounds
            case CustomizeTypes.soundEffects?:
                let savedSounds = localStore.retrieveItem(identifier: "Sound")
                if soundsList[itemIndex].purchased {
                    currentSound = soundsList[itemIndex]
                    for i in 2...8{
                        savedSounds[i - 1].setValue(itemIndex, forKey: "equippedIndex")
                    }
                    localStore.saveContext()
                } else {
                    if(currentStarsCount >= itemCost){
                        currentSound = soundsList[itemIndex]
                        soundsList[itemIndex].purchased = true
                        savedSounds[itemIndex].setValue(true, forKey: "purchased")
                        currentStarsCount -= itemCost
                        localStore.retrieveItem(identifier: "Player")[0].setValue(currentStarsCount, forKey: "stars")
                        for i in 2...8{
                            savedSounds[i - 1].setValue(itemIndex, forKey: "equippedIndex")
                        }
                        localStore.saveContext()
                    }
                }
                
            //themes
            case CustomizeTypes.themes?:
                
                //retrieve whether it has been purchased from core data
                let savedThemes = localStore.retrieveItem(identifier: "Theme")
                
                // check value of bool 'purchased'
                if themesList[itemIndex].purchased {
                    currentTheme = themesList[itemIndex]
                    for i in 2...8{
                        savedThemes[i - 1].setValue(itemIndex, forKey: "equippedIndex")
                    }
                    localStore.saveContext()
                    vc.updateBackground(index: itemIndex)
                } else {
                    if(currentStarsCount >= itemCost){
                        currentTheme = themesList[itemIndex]
                        themesList[itemIndex].purchased = true
                        
                        //save the value of puchased to core data
                        savedThemes[itemIndex].setValue(true, forKey: "purchased")
                        currentStarsCount -= itemCost
                        localStore.retrieveItem(identifier: "Player")[0].setValue(currentStarsCount, forKey: "stars")
                        for i in 2...8{
                            savedThemes[i - 1].setValue(itemIndex, forKey: "equippedIndex")
                        }
                        localStore.saveContext()
                        vc.updateBackground(index: itemIndex)
                    }
                }
                
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
