//
//  ThemesVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit

var themesList = [
    Themes(colors: [UIColor.systemBlue.cgColor, UIColor.systemGreen.cgColor], name: "Blue", cost: 100, icon: UIImage(named: "logoIcon")!),
    Themes(colors: [UIColor.systemOrange.cgColor, UIColor.systemPink.cgColor], name: "Pink", cost: 100, icon: UIImage(named: "logoIcon")!)
]

// custom table view cell and its labels
class itemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemStatus: UILabel!
    @IBOutlet weak var itemIcon: UIImageView!
}

class ThemesVC: UIGameplayVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: UIViewController!
    var themeCellIdentifier = "themeCellIdentifier"
    var selectedIdentifier = "selectedIdentifier"
    var colorsSelected: Array<CGColor> = []
    
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
        if !themesList[row].purchased {
            cell.itemStatus?.text = String(themesList[row].cost)
        }
        return cell
    }
    
    // updates the table before the screen is shown
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        //let index = view.layer.add
        
        //updateBackground(colors: colorsSelected)

    }
    
    // sent over necessary data to respective view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == addSegueIdentifier,
//           let destination = segue.destination as? AddTimerVC {
//            destination.delegate = self
//        }
        if segue.identifier == selectedIdentifier,
           let destination = segue.destination as? ConfirmItemVC,
           let selectedIndex = tableView.indexPathForSelectedRow?.row {
            destination.delegate = self
            destination.itemCost = themesList[selectedIndex].cost
            destination.itemName = themesList[selectedIndex].name
            destination.itemIcon = themesList[selectedIndex].icon
            destination.itemIndex = selectedIndex
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
