//
//  ViewController.swift
//  Orbscape
//
//  Created by Nhat Tran on 7/25/24.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

class ViewController: UIViewController {

    var player: Player?
    override func viewDidLoad() {
        super.viewDidLoad()
        player = Player(context: context)
        player?.stars = 0
        player?.runTime = 0.0
        // Do any additional setup after loading the view.
    }
    
    func saveContext () {
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
    
    func storePlayer(stars: Int, runTime: Double){
        let curPlayer = NSEntityDescription.insertNewObject(forEntityName: "Players", into: context)
        curPlayer.setValue(stars, forKey: "stars")
        curPlayer.setValue(runTime, forKey: "runTime")
        saveContext()
    }
    
    func storeTheme(themeName: String, themeCost: Int){
        let curTheme = NSEntityDescription.insertNewObject(forEntityName: "Theme", into: context)
        curTheme.setValue(themeName, forKey: "themeName")
        curTheme.setValue(themeCost, forKey: "themeCost")
        saveContext()
    }
    
    func storeSkin(skinName: String, skinCost: Int){
        let curSkin = NSEntityDescription.insertNewObject(forEntityName: "Skin", into: context)
        curSkin.setValue(skinName, forKey: "skinName")
        curSkin.setValue(skinCost, forKey: "skinCost")
        saveContext()
    }
    
    func storeSound(soundName: String, soundCost: Int){
        let curSound = NSEntityDescription.insertNewObject(forEntityName: "Sound", into: context)
        curSound.setValue(soundName, forKey: "soundName")
        curSound.setValue(soundCost, forKey: "soundCost")
        saveContext()
    }
    
    func buyTheme(curTheme: Theme?){
        if(player!.stars > curTheme!.themeCost){
            player?.addToAvailableThemes(curTheme!)
            player?.stars -= curTheme!.themeCost
        }
        else {
            print("insufficient stars")
        }
        saveContext()
    }
    
    func buySkin(curSkin: Skin?){
        if(player!.stars > curSkin!.skinCost){
            player?.addToAvailableSkins(curSkin!)
            player?.stars -= curSkin!.skinCost
        }
        else {
            print("insufficient stars")
        }
        saveContext()
        
    }
    
    func buySound(curSound: Sound?){
        if(player!.stars > curSound!.soundCost){
            player?.addToAvailableSounds(curSound!)
            player?.stars -= curSound!.soundCost
        }
        else {
            print("insufficient stars")
        }
        saveContext()
    }
    
    func equipTheme(curTheme: Theme?){
        player?.selectedTheme = curTheme
        saveContext()
    }
    
    func equipSound(curSound: Sound?){
        player?.selectedSound = curSound
        saveContext()
    }
    
    func equipSkin(curSkin: Skin?){
        player?.selectedSkin = curSkin
        saveContext()
    }
    
    func retrievePlayer() -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        var fetchedResults: [NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            print("Error occured while retrieving data")
            abort()
        }
        return fetchedResults!
    }
    
    func retrieveTheme() -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Theme")
        var fetchedResults: [NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            print("Error occured while retrieving data")
            abort()
        }
        return fetchedResults!
    }
    
    func retrieveSound() -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sound")
        var fetchedResults: [NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            print("Error occured while retrieving data")
            abort()
        }
        return fetchedResults!
    }
    
    func retrieveSkin() -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Skin")
        var fetchedResults: [NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            print("Error occured while retrieving data")
            abort()
        }
        return fetchedResults!
    }

}
