//
//  DetailController.swift
//  ColemanJustin_WearableProject
//
//  Created by Justin Coleman on 5/16/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import WatchKit
import Foundation

class DetailController: WKInterfaceController {
    
    //MARK: - Outlets
    @IBOutlet var nameLabel: WKInterfaceLabel!
    @IBOutlet var distanceLabel: WKInterfaceLabel!
    @IBOutlet var faveBtn: WKInterfaceButton!
    
    //MARK: - Variables
    let appGroupID = "group.com.colemanjustin.dvp5.wearable"
    var selectedTrail: Trail!
    var location: CLLocation!
    var isFave: Bool = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let contextData = context as? [String: Any]{
            selectedTrail = contextData["Trail"] as? Trail
            location = contextData["Current Location"] as? CLLocation
        }
        
        if selectedTrail != nil{
            nameLabel.setText(selectedTrail.name)
            
            let trailLoc = CLLocation(latitude: selectedTrail.latitude!, longitude: selectedTrail.longitude!)
            
            let distance = location.distance(from: trailLoc).rounded()
            let miles = Int(distance) / 1609
            
            distanceLabel.setText("\(miles) mi.")
            
            //Check if the selected trail is favorited
            loadFavorite(trail: selectedTrail)
            
            if isFave{
                faveBtn.setBackgroundImageNamed("heart-filled")
            }else{
                faveBtn.setBackgroundImageNamed("heart-outline")
            }
            
        }
        
        
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @IBAction func heartTapped(sender: WKInterfaceButton){
        faveBtn.setEnabled(false)
        
        if (!isFave){
            
            animate(withDuration: 0.5, animations: {
                self.faveBtn.setBackgroundImageNamed("heart-filled")
            })
            saveFavorite(trail: selectedTrail)
            isFave = true
        }else{
            animate(withDuration: 0.5, animations: {
                self.faveBtn.setBackgroundImageNamed("heart-outline")
            })
            deleteFavorite(trail: selectedTrail)
            isFave = false
        }
        
    }
    
    //MARK: - Methods
    func deleteFavorite(trail: Trail){
        let defaults = UserDefaults.init(suiteName: appGroupID)
        
        defaults?.removeObject(forKey: trail.name!)
        defaults?.removeObject(forKey: trail.name! + "latitude")
        defaults?.removeObject(forKey: trail.name! + "longitude")
        defaults?.synchronize()
        
        faveBtn.setEnabled(true)
    }
    
    func saveFavorite(trail: Trail){
        let defaults = UserDefaults.init(suiteName: appGroupID)
        
        defaults?.set(trail.name!, forKey: trail.name!)
        defaults?.set(trail.latitude!, forKey: trail.name! + "latitude")
        defaults?.set(trail.longitude!, forKey: trail.name! + "longitude")
        defaults?.synchronize()
        
        faveBtn.setEnabled(true)
    }
    
    func loadFavorite(trail: Trail){
        let defaults = UserDefaults.init(suiteName: appGroupID)
        
        if let _ = defaults?.string(forKey: trail.name!){
            isFave = true
        }else{
            isFave = false
        }
    }

}
