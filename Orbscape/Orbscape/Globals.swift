//
//  Globals.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/10/24.
//

import Foundation
import UIKit
import AVFoundation
import CoreData

var localStore = PurchasableItems()
var currentTheme: Themes = themesList[localStore.retrieveItem(identifier: "Theme")[1].value(forKey: "equippedIndex") as! Int]
var currentSkin: Skins = skinsList[localStore.retrieveItem(identifier: "Skin")[1].value(forKey: "equippedIndex") as! Int]
var currentSound: SoundEffects = soundsList[localStore.retrieveItem(identifier: "Sound")[1].value(forKey: "equippedIndex") as! Int]
var currentStarsCount = localStore.retrieveItem(identifier: "Player")[0].value(forKey: "stars") as! Int

var soundVolume: Float = localStore.retrieveItem(identifier: "Insets")[0].value(forKey: "soundVal") as! Float
var musicVolume: Float = localStore.retrieveItem(identifier: "Insets")[0].value(forKey: "musicVal") as! Float

// all the skins available to purchase
var skinsList = [
    Skins(
        skin: UIImage(named: "blueSkin")!,
        name: "Blue",
        cost: 100,
        ind: 0,
        id: "Skin",
        purchase: true
    ),
    Skins(
        skin: UIImage(named: "greenSkin")!,
        name: "Green",
        cost: 100,
        ind: 1,
        id: "Skin"
    ),
    Skins(
        skin: UIImage(named: "yellowSkin")!,
        name: "Yellow",
        cost: 100,
        ind: 2,
        id: "Skin"
    ),
    Skins(
        skin: UIImage(named: "rainbowSkin")!,
        name: "Rainbow",
        cost: 100,
        ind: 3,
        id: "Skin"
    ),
    Skins(
        skin: UIImage(named: "elmoSkin")!,
        name: "Elmo",
        cost: 100,
        ind: 4,
        id: "Skin"
    ),
    Skins(
        skin: UIImage(named: "doggySkin")!,
        name: "Doggy",
        cost: 100,
        ind: 5,
        id: "Skin"
    ),
    Skins(
        skin: UIImage(named: "kittySkin")!,
        name: "Kitty",
        cost: 100,
        ind: 6,
        id: "Skin"
    ),
    Skins(
        skin: UIImage(named: "piggySkin")!,
        name: "Piggy",
        cost: 100,
        ind: 7,
        id: "Skin"
    )
]

// all the sounds available to purchase
var soundsList = [
    SoundEffects(
        sound: Bundle.main.url(forResource: "HappyPopsSound", withExtension: "mp3")!,
        name: "Pop",
        cost: 100,
        ind: 0,
        id: "Sound",
        purchase: true
    ),
    SoundEffects(
        sound: Bundle.main.url(forResource: "beam", withExtension: "wav")!,
        name: "Laser",
        cost: 100,
        ind: 1,
        id: "Sound"
    ),
    SoundEffects(
        sound: Bundle.main.url(forResource: "fairy", withExtension: "wav")!,
        name: "Fairy",
        cost: 100,
        ind: 2,
        id: "Sound"
    ),
    SoundEffects(
        sound: Bundle.main.url(forResource: "coin", withExtension: "wav")!,
        name: "Coin",
        cost: 100,
        ind: 3,
        id: "Sound"
    ),
    SoundEffects(
        sound: Bundle.main.url(forResource: "tap", withExtension: "wav")!,
        name: "Tap",
        cost: 100,
        ind: 4,
        id: "Sound"
    ),
    SoundEffects(
        sound: Bundle.main.url(forResource: "dog", withExtension: "wav")!,
        name: "Bark",
        cost: 100,
        ind: 5,
        id: "Sound"
    ),
    SoundEffects(
        sound: Bundle.main.url(forResource: "cat", withExtension: "wav")!,
        name: "Meow",
        cost: 100,
        ind: 6,
        id: "Sound"
    ),
    SoundEffects(
        sound: Bundle.main.url(forResource: "pig", withExtension: "wav")!,
        name: "Oink",
        cost: 100,
        ind: 7,
        id: "Sound"
    )
]

// all the theme available to purchase
var themesList = [
    Themes(
        colors: [CGColor(red: 0.74, green: 0.33, blue: 0.44, alpha: 1.0),
                 CGColor(red: 0.98, green: 0.64, blue: 0.44, alpha: 1.0)],
        name: "Peach",
        cost: 100,
        ind: 0,
        id: "Theme",
        purchase: true
    ),
    Themes(
        colors: [CGColor(red: 0.91, green: 0.49, blue: 0.73, alpha: 1.0),
                 CGColor(red: 0.24, green: 0.28, blue: 0.85, alpha: 1.0)],
        name: "Purples",
        cost: 100,
        ind: 1,
        id: "Theme"
    ),
    Themes(
        colors: [CGColor(red: 0.98, green: 0.68, blue: 0.48, alpha: 1.0),
                 CGColor(red: 0.26, green: 0.14, blue: 0.44, alpha: 1.0)],
        name: "Plums",
        cost: 100,
        ind: 2,
        id: "Theme"
    ),
    Themes(
        colors: [CGColor(red: 0.19, green: 0.77, blue: 0.82, alpha: 1.0),
                 CGColor(red: 0.28, green: 0.16, blue: 0.41, alpha: 1.0)],
        name: "Galaxy",
        cost: 100,
        ind: 3,
        id: "Theme"
    ),
    Themes(
        colors: [CGColor(red: 0.07, green: 0.15, blue: 0.21, alpha: 1.0),
                 CGColor(red: 0.01, green: 0.80, blue: 0.69, alpha: 1.0)],
        name: "Ocean",
        cost: 100,
        ind: 4,
        id: "Theme"
    ),
    Themes(
        colors: [CGColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.0),
                 CGColor(red: 0.04, green: 0.08, blue: 0.15, alpha: 1.0)],
        name: "Grey",
        cost: 100,
        ind: 5,
        id: "Theme"
    ),
    Themes(
        colors: [CGColor(red: 0.82, green: 1, blue: 0.61, alpha: 1.0),
                 CGColor(red: 0.04, green: 0.37, blue: 0.48, alpha: 1.0)],
        name: "Nature",
        cost: 100,
        ind: 6,
        id: "Theme"
    ),
    Themes(
        colors: [CGColor(red: 1, green: 0.78, blue: 0.34, alpha: 1.0),
                 CGColor(red: 0.78, green: 0.11, blue: 0.11, alpha: 1.0)],
        name: "Sunset",
        cost: 100,
        ind: 7,
        id: "Theme"
    )
]




