//
//  Trail.swift
//  ColemanJustin_WearableProject
//
//  Created by Justin Coleman on 5/14/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import Foundation

class Trail: NSObject, NSCoding{
    var name: String?
    var latitude: Double?
    var longitude: Double?
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(name: "Trail", latitude: 0.00, longitude: 0.00)
        
        name = aDecoder.decodeObject(forKey: "trail_name")as? String
        latitude = aDecoder.decodeObject(forKey: "trail_latitude") as? Double
        longitude = aDecoder.decodeObject(forKey: "trail_longitude") as? Double
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "trail_name")
        aCoder.encode(latitude, forKey: "trail_latitude")
        aCoder.encode(longitude, forKey: "trail_longitude")
    }
}
