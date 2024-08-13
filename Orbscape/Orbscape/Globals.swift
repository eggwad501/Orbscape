//
//  Globals.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/10/24.
//

import Foundation
import UIKit
import AVFoundation

// the following will be saved in coredata

var currentSkin: Skins = skinsList[0]
var currentSound: SoundEffects = soundsList[0]
var currentTheme: Themes = themesList[0]
var currentStarsCount = 1000

var skinsList = [
    Skins(
        skin: UIImage(named: "blueSkin")!,
        name: "Blue",
        cost: 100
    ),
    Skins(
        skin: UIImage(named: "greenSkin")!,
        name: "Green",
        cost: 100
    ),
    Skins(
        skin: UIImage(named: "yellowSkin")!,
        name: "Yellow",
        cost: 100
    ),
    Skins(
        skin: UIImage(named: "rainbowSkin")!,
        name: "Rainbow",
        cost: 100
    ),
    Skins(
        skin: UIImage(named: "elmoSkin")!,
        name: "Elmo",
        cost: 100
    ),
    Skins(
        skin: UIImage(named: "doggySkin")!,
        name: "Doggy",
        cost: 100
    ),
    Skins(
        skin: UIImage(named: "kittySkin")!,
        name: "Kitty",
        cost: 100
    ),
    Skins(
        skin: UIImage(named: "piggySkin")!,
        name: "Piggy",
        cost: 100
    )
]

var soundsList = [
    SoundEffects(
        sound: Bundle.main.url(forResource: "HappyPopsSound", withExtension: "mp3")!,
        name: "Pop",
        cost: 100
    )
]

var themesList = [
    Themes(
        colors: [CGColor(red: 0.74, green: 0.33, blue: 0.44, alpha: 1.0),
                 CGColor(red: 0.98, green: 0.64, blue: 0.44, alpha: 1.0)],
        name: "Peach",
        cost: 100
    ),
    Themes(
        colors: [CGColor(red: 0.91, green: 0.49, blue: 0.73, alpha: 1.0),
                 CGColor(red: 0.24, green: 0.28, blue: 0.85, alpha: 1.0)],
        name: "Purples",
        cost: 100
    ),
    Themes(
        colors: [CGColor(red: 0.98, green: 0.68, blue: 0.48, alpha: 1.0),
                 CGColor(red: 0.26, green: 0.14, blue: 0.44, alpha: 1.0)],
        name: "Plums",
        cost: 100
    ),
    Themes(
        colors: [CGColor(red: 0.19, green: 0.77, blue: 0.82, alpha: 1.0),
                 CGColor(red: 0.28, green: 0.16, blue: 0.41, alpha: 1.0)],
        name: "Galaxy",
        cost: 100
    ),
    Themes(
        colors: [CGColor(red: 0.07, green: 0.15, blue: 0.21, alpha: 1.0),
                 CGColor(red: 0.01, green: 0.80, blue: 0.69, alpha: 1.0)],
        name: "Ocean",
        cost: 100
    ),
    Themes(
        colors: [CGColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.0),
                 CGColor(red: 0.04, green: 0.08, blue: 0.15, alpha: 1.0)],
        name: "Grey",
        cost: 100
    ),
    Themes(
        colors: [CGColor(red: 0.82, green: 1, blue: 0.61, alpha: 1.0),
                 CGColor(red: 0.04, green: 0.37, blue: 0.48, alpha: 1.0)],
        name: "Nature",
        cost: 100
    ),
    Themes(
        colors: [CGColor(red: 1, green: 0.78, blue: 0.34, alpha: 1.0),
                 CGColor(red: 0.78, green: 0.11, blue: 0.11, alpha: 1.0)],
        name: "Sunset",
        cost: 100
    )
]

