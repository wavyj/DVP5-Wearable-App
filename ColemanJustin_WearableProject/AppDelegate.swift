//
//  AppDelegate.swift
//  ColemanJustin_WearableProject
//
//  Created by Justin Coleman on 5/9/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MapKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    fileprivate var searchResults: MKLocalSearchResponse?
    
    var session: WCSession? {
        didSet{
            if let session = session{
                session.delegate = self
                session.activate()
            }
        }
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if WCSession.isSupported(){
            session = WCSession.default()
        }
        
        return true
    }
}

extension AppDelegate: WCSessionDelegate{
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if (message["getTrails"] as? Bool) != nil{
            print("message received")
            //Get trails
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Trail"
            
            let search = MKLocalSearch(request: request)
            search.start(completionHandler: { (response, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    return
                }
                var trails = [Trail]()
                
                for result in (response?.mapItems)!{
                    trails.append(Trail(name: result.name!, latitude: result.placemark.coordinate.latitude, longitude: result.placemark.coordinate.longitude))
                }
                
                NSKeyedArchiver.setClassName("Trail", for: Trail.self)
                
                let trailObject = trails
                
                let data = NSKeyedArchiver.archivedData(withRootObject: trailObject)
                
                //Return data
                replyHandler(["newTrails" : data])
            })
        }
    }
    
}

