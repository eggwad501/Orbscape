//
//  EndGameVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/12/24.
//

import UIKit

class EndGameVC: UIGameplayVC {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var collectedStarsLabel: UILabel!
    
    var gameDelegate: UIGameplayVC!
    var starCountRun: Int!
    var timeRun: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.text = timeRun
        totalStarsLabel.text = String(currentStarsCount) + "★"
        collectedStarsLabel.text = "+ " + String(starCountRun) + "★"
        // We all need to update their total stars
        currentStarsCount = currentStarsCount + starCountRun
    }
}
