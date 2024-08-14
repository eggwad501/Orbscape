//
//  ThemesVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit

protocol ItemSelectChanger {
    func removeBlurredBackgroundView()
    func updateBackground(index: Int)
    func updateScreen(starCount: Int)
}

// custom table view cell and its labels
class itemsTableViewCell: UITableViewCell {
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemStatus: UILabel!
    @IBOutlet weak var itemImage: UIView!
}

class ThemesVC: UIGameplayVC, UITableViewDelegate, UITableViewDataSource, ItemSelectChanger {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var starCountLabel: UILabel!
    
    var delegate: UIViewController!
    var themeCellIdentifier = "themeCellIdentifier"
    var selectedIdentifier = "selectedIdentifier"
    
    var types: CustomizeTypes!
    
    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        starCountLabel.text = "\(currentStarsCount) ★"
        
        switch types {
        case CustomizeTypes.skins?:
            self.title = "SKINS"
        case CustomizeTypes.soundEffects?:
            self.title = "SOUNDS"
        case CustomizeTypes.themes?:
            self.title = "THEMES"
        default:
            break
        }
    }
    
    // return the number of rows in a given section of a table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch types {
        case CustomizeTypes.skins?:
            return skinsList.count
        case CustomizeTypes.soundEffects?:
            return soundsList.count
        case CustomizeTypes.themes?:
            return themesList.count
        default:
            break
        }
        return 0
    }
    
    // the display information for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: themeCellIdentifier, for: indexPath) as! itemsTableViewCell
        
        // make cell background clear
        cell.backgroundColor = UIColor.clear
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        cell.itemImage.backgroundColor = UIColor.clear
        return cellAppearance(row: indexPath.row, cell: cell)
    }
    
    // the cell appearance for each item type
    private func cellAppearance(row: Int, cell: itemsTableViewCell) -> itemsTableViewCell {
        for view in cell.itemImage.subviews {
            view.removeFromSuperview()
        }
        switch types {
        case CustomizeTypes.skins?:
            cell.itemName?.text = skinsList[row].name
                        
            let image = imageView(view: cell.itemImage, image: skinsList[row].skin)
            if !skinsList[row].purchased {
                image.layer.opacity = 0.5
            }
            
            cell.itemImage?.addSubview(image)
            cell.itemStatus?.text = lockedDisplay(item: skinsList[row], itemImage: cell.itemImage)

        case CustomizeTypes.soundEffects?:
            cell.itemName?.text = soundsList[row].name
            
            let image = imageView(view: cell.itemImage, image: soundsList[row].image!)
            if !soundsList[row].purchased {
                image.layer.opacity = 0.5
            }
            cell.itemImage?.addSubview(image)
            cell.itemStatus?.text = lockedDisplay(item: soundsList[row], itemImage: cell.itemImage)
            
        case CustomizeTypes.themes?:
            cell.itemName?.text = themesList[row].name
            
            // convert the gradient into an image
            let gradient = gradientView(view: cell.itemImage, colors: themesList[row].colors)
            UIGraphicsBeginImageContext(gradient.bounds.size)
            gradient.render(in: UIGraphicsGetCurrentContext()!)
            let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let image = imageView(view: cell.itemImage, image: gradientImage!)
            
            if !themesList[row].purchased {
                image.layer.opacity = 0.5
            }
            cell.itemImage?.addSubview(image)
            cell.itemStatus?.text = lockedDisplay(item: themesList[row], itemImage: cell.itemImage)
            
        default:
            break
        }
        return cell
    }
    
    // display lock image and return status of the item
    private func lockedDisplay(item: PurchasableItems, itemImage: UIView) -> String {
        if !item.purchased {
            let lock = UIImageView(image: UIImage(named: "Lock"))
            lock.frame = itemImage.bounds
            itemImage.addSubview(lock)

            return "\(item.cost) ★"
        } else {
            if currentSkin.equals(compareTo: item) 
                || currentSound.equals(compareTo: item)
                || currentTheme.equals(compareTo: item) {
                return "EQUIPPED"
            }
            return "AVAILABLE"
        }
    }
    
    // sent over necessary data to respective view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == selectedIdentifier,
           let destination = segue.destination as? ConfirmItemVC,
           let selectedIndex = tableView.indexPathForSelectedRow?.row {
            destination.delegate = self
            destination.types = types
            destination.itemIndex = selectedIndex
            //destination.itemsTableViewCell = tableView.cellForRow(at: selectedIndex)
            
            switch types {
            case CustomizeTypes.skins?:
                destination.itemCost = skinsList[selectedIndex].cost
                destination.itemName = skinsList[selectedIndex].name
                destination.itemImage = skinsList[selectedIndex].skin
                
            case CustomizeTypes.soundEffects?:
                destination.itemCost = soundsList[selectedIndex].cost
                destination.itemName = soundsList[selectedIndex].name
                destination.itemImage = soundsList[selectedIndex].image
                
            case CustomizeTypes.themes?:
                destination.itemCost = themesList[selectedIndex].cost
                destination.itemName = themesList[selectedIndex].name
                destination.itemColors = themesList[selectedIndex].colors
            default:
                break
            }
                
            //destination.modalPresentationStyle = .overFullScreen
            self.overlayBlurredBackgroundView()
        }
        if segue.identifier == selectedIdentifier {
            
        }
    }
    
    // immediate update of the background to the selected colors
    func updateBackground(index: Int) {
        let newLayer = CAGradientLayer()
        newLayer.frame = view.bounds
        newLayer.colors = themesList[index].colors
        newLayer.name = "gradientLayer"

        if let sublayers = view.layer.sublayers {
            for layer in sublayers {
                if layer.name == newLayer.name {
                    view.layer.replaceSublayer(layer, with: newLayer)
                }
            }
        }
    }
    
    // immediate update of the star count
    func updateScreen(starCount: Int) {
        starCountLabel.text = "\(starCount) ★"
        tableView.reloadData()

    }
}
