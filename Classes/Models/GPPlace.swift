//
//  GPPlace.swift
//  InFitting
//
//  Created by Max Lesichniy on 12.10.2017.
//  Copyright © 2017 OnCreate. All rights reserved.
//

import Foundation

public class GPPlace: NSObject, Codable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    enum CodingKeys: String, CodingKey {
        case geometry = "geometry"
        case icon = "icon"
        case reference = "reference"
        case name = "name"
//        case openingHours = "opening_hours"
        case types = "types"
        case placeId = "place_id"
//        case photos = "photos"
        case scope = "scope"
        case vicinity = "vicinity"
//        case altIds = "alt_ids"
    }
    
    // MARK: Properties
    public var geometry: GPGeometry?
    public var icon: String?
    public var reference: String?
    public var name: String?
//    public var openingHours: GPOpeningHours?
    public var types: [String]?
    public var placeId: String = ""
//    public var photos: [GPPhotos]?
    public var scope: String?
    public var vicinity: String?
//    public var altIds: [GPAltIds]?
    
}
