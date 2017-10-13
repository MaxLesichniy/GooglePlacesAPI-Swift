//
//  GPGeometry.swift
//  InFitting
//
//  Created by Max Lesichniy on 12.10.2017.
//  Copyright © 2017 OnCreate. All rights reserved.
//

import Foundation
import CoreLocation

public class GPGeometry: Codable {
    
    private class GPLocation: Codable {
        var lat: Double = 0
        var lng: Double = 0
    }
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    enum CodingKeys: String, CodingKey {
        case _location = "location"
    }
    
    // MARK: Properties
    private var _location: GPLocation?
    
    var location: CLLocationCoordinate2D {
        set {
            _location = GPLocation()
            _location?.lat = newValue.latitude
            _location?.lng = newValue.longitude
        }
        get {
            return CLLocationCoordinate2D(latitude: _location?.lat ?? 0, longitude: _location?.lng ?? 0)
        }
    }
}
