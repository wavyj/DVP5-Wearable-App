//
//  InterfaceController.swift
//  ColemanJustin_WearableProject WatchKit Extension
//
//  Created by Justin Coleman on 5/9/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
        if activationState == .activated{
        }
    }
    
    //MARK: - Outlets
    @IBOutlet var table: WKInterfaceTable!
    @IBOutlet var trailsLabel: WKInterfaceLabel!
    
    
    //MARK: - Variables
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default() : nil
    var locationManager: CLLocationManager = CLLocationManager()
    var mapLocation: CLLocationCoordinate2D?
    var region: MKCoordinateRegion!
    var trails: [Trail]?

    override init() {
        super.init()
        
        session?.delegate = self
        session?.activate()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if mapLocation == nil{
            getLocation()
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        var contextData:[String: Any] = [String: Any]()
        contextData["Trail"] = trails?[rowIndex]
        contextData["Current Location"] = locationManager.location
        return contextData
    }
    
    //MARK: - Table Callbacks
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
    }
    
    func configureTable(){
        if let trails = trails{
            table.setNumberOfRows(trails.count, withRowType: "trailRow")
            
            for i in 0..<table.numberOfRows {
                let row = table.rowController(at: i) as! TrailRowController
                let currentTrail = trails[i]
                
                if let name = currentTrail.name{
                    row.nameLabel.setText(name)
                }
                
                var location: CLLocation?
                var distance: Double?
                var miles: Int?
                
                if let latitude = currentTrail.latitude, let longitude = currentTrail.longitude{
                    location = CLLocation(latitude: latitude, longitude: longitude)
                }
                
                if let location = location, let userLoc = locationManager.location{
                    distance = userLoc.distance(from: location).rounded()
                    miles = Int(distance!) / 1609
                }else{
                    getLocation()
                }
                
                if let miles = miles{
                    row.distanceLabel.setText("\(miles)" + " mi.")
                }
            }
            table.setHidden(false)
            trailsLabel.setHidden(false)
        }
    }
    
    //MARK: - Watch Connectivity Methods
    func getTrails(){
        
        let messageValues: [String: Any] = ["getTrails": true]
        
        if let session = session, session.isReachable{
            
            session.sendMessage(messageValues, replyHandler: { (replyData) in
                print("Data received")
                
                DispatchQueue.main.async {
                    if let data = replyData["newTrails"] as? Data{
                        NSKeyedUnarchiver.setClass(Trail.self, forClassName: "Trail")
                        if let trailObject = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Trail]{
                            print("Received Trails")
                            self.trails = trailObject
                            
                            //setup List
                            self.configureTable()
                        }
                    }
                }
                
            }, errorHandler: nil)
        }
    }

}

extension InterfaceController: CLLocationManagerDelegate{
    
    func getLocation(){
        //CLLocation Setup
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.distanceFilter = 5
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.first
        let latitude = currentLocation?.coordinate.latitude
        print(latitude!.description)
        let longitude = currentLocation?.coordinate.longitude
        print(longitude!.description)
        
        mapLocation = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta:
            0.1)
        region = MKCoordinateRegionMake(mapLocation!, span)
        
        getTrails()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


