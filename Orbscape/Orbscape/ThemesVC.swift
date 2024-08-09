//
//  ThemesVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit

var themesList = [
    Themes(
        colors: [CGColor(red: 0.74, green: 0.33, blue: 0.44, alpha: 1.0),
                 CGColor(red: 0.98, green: 0.64, blue: 0.44, alpha: 1.0)],
        name: "Peach Candy",
        cost: 100,
        icon: UIImage(named: "logoIcon")!
    ),
    Themes(
        colors: [CGColor(red: 0.91, green: 0.49, blue: 0.73, alpha: 1.0),
                 CGColor(red: 0.24, green: 0.28, blue: 0.85, alpha: 1.0)],
        name: "Purple Pinks",
        cost: 100,
        icon: UIImage(named: "logoIcon")!
    ),
    Themes(
        colors: [CGColor(red: 0.98, green: 0.68, blue: 0.48, alpha: 1.0),
                 CGColor(red: 0.26, green: 0.14, blue: 0.44, alpha: 1.0)],
        name: "Plums",
        cost: 100,
        icon: UIImage(named: "logoIcon")!
    ),
    Themes(
        colors: [CGColor(red: 0.19, green: 0.77, blue: 0.82, alpha: 1.0),
                 CGColor(red: 0.28, green: 0.16, blue: 0.41, alpha: 1.0)],
        name: "Galaxy",
        cost: 100,
        icon: UIImage(named: "logoIcon")!
    )
]

// rgb(74%, 33%, 44%)

protocol blurBackgroundChanger {
    func removeBlurredBackgroundView()
    func updateBackground(colors:Array<CGColor>)
}


// custom table view cell and its labels
class itemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemStatus: UILabel!
    @IBOutlet weak var itemIcon: UIImageView!
}

class ThemesVC: UIGameplayVC, UITableViewDelegate, UITableViewDataSource, blurBackgroundChanger {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: UIViewController!
    var themeCellIdentifier = "themeCellIdentifier"
    var selectedIdentifier = "selectedIdentifier"
    
    var color = CGColor(red: 0.98, green: 0.64, blue: 0.44, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // return the number of rows in a given section of a table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themesList.count
    }
    
    // the display information for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: themeCellIdentifier, for: indexPath) as! itemsTableViewCell
        let row = indexPath.row
        cell.itemName?.text = themesList[row].name
        cell.itemIcon?.image = themesList[row].icon
        cell.backgroundColor = UIColor.clear
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        
        if !themesList[row].purchased {
            cell.itemStatus?.text = String(themesList[row].cost)
        }
        return cell
    }
    
    // updates the table before the screen is shown
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // sent over necessary data to respective view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == selectedIdentifier,
           let destination = segue.destination as? ConfirmItemVC,
           let selectedIndex = tableView.indexPathForSelectedRow?.row {
            destination.delegate = self
            destination.itemCost = themesList[selectedIndex].cost
            destination.itemName = themesList[selectedIndex].name
            destination.itemIcon = themesList[selectedIndex].icon
            destination.itemIndex = selectedIndex
            
            destination.modalPresentationStyle = .overFullScreen
            self.overlayBlurredBackgroundView()
        }
    }
    
    // create the blur effect when the confirm vc shows up
    func overlayBlurredBackgroundView() {
        let blurredBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        blurredBackgroundView.frame = self.view.bounds
        view.addSubview(blurredBackgroundView)
        super.hideNavigationBar()
        }
        
    // remove the blur effect
    func removeBlurredBackgroundView() {
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
        super.showNavigationBar()
    }
    
    // immediate update of the background to the selected colors
    func updateBackground(colors:Array<CGColor>) {
        let newLayer = CAGradientLayer()
        newLayer.frame = view.bounds
        newLayer.colors = colors
        newLayer.name = "gradientLayer"
        backgroundColors = colors

        if let sublayers = view.layer.sublayers {
            for layer in sublayers {
                if layer.name == "gradientLayer" {
                    print(1)
                    view.layer.replaceSublayer(layer, with: newLayer)
                }
            }
        }
    }
}
