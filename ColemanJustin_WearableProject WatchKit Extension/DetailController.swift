//
//  DetailController.swift
//  ColemanJustin_WearableProject
//
//  Created by Justin Coleman on 5/16/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import WatchKit

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
            isFave = true
        }else{
            animate(withDuration: 0.5, animations: {
                self.faveBtn.setBackgroundImageNamed("heart-outline")
            })
            isFave = false
        }
        
        //Save preference
        
        faveBtn.setEnabled(true)
    }
    
    //MARK: - Methods
    func deleteFavorite(trail: String){
        
    }
    
    func saveFavorite(trail: String){
        if let defaults =
    }

}
