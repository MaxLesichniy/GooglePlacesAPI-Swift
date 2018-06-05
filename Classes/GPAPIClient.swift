//
//  GPAPIClient.swift
//  InFitting
//
//  Created by Max Lesichniy on 12.10.2017.
//  Copyright © 2017 OnCreate. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire
import CoreLocation

public let GPAPIClientErrorDomain = "GPAPIClientErrorDomain"

public let GooglePlaces = GPAPIClient.instance

public class GPAPIClient {
    
    public typealias PlacesCompletion = (_ placesList: [GPPlace]?, _ error: Error?) -> Void
    public typealias AutocompleteCompletion = (_ predictionsList: [GPPrediction]?, _ error: Error?) -> Void
    public typealias PlaceCompletion = (_ places: GPPlace?, _ error: Error?) -> Void
    
    public static let instance = GPAPIClient()
    
    var apiKey: String?
    public var language: String? = nil
    
    public class func provideAPIKey(_ key: String?) {
        GPAPIClient.instance.apiKey = key
    }
    
    public func nearbySearch(geometry: Geometry, parameters: SearchPlaceOptionalParameters?, completion: @escaping PlacesCompletion) {
        var par = [String: Any]()
        par.update(other: geometry.queryParameters)
        if let queryParameters = parameters?.queryParameters { par.update(other: queryParameters) }
        par["key"] = apiKey
        
        Alamofire.request(APIRouter.nearbysearch, parameters: par).responseDecodableObject { (response: DataResponse<GPResponse>) in
            
            switch response.result {
            case .success(let responseValue):
                if let error = responseValue.error {
                    completion(nil, error)
                } else {
                    completion(responseValue.results, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
            
        }
    }
    
    public func search(with query: String, geometry: Geometry?, parameters: SearchPlaceOptionalParameters?, completion: @escaping PlacesCompletion) {
        var par = [String: Any]()
        par["query"] = query
        if let queryParameters = geometry?.queryParameters { par.update(other: queryParameters) }
        if let queryParameters = parameters?.queryParameters { par.update(other: queryParameters) }
        par["key"] = apiKey
        
        Alamofire.request(APIRouter.textsearch, parameters: par).responseDecodableObject { (response: DataResponse<GPResponse>) in
            
            switch response.result {
            case .success(let responseValue):
                if let error = responseValue.error {
                    completion(nil, error)
                } else {
                    completion(responseValue.results, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
            
        }
    }
    
    public func radarSearch(geometry: Geometry, parameters: SearchPlaceOptionalParameters?, completion: @escaping PlacesCompletion) {
        var par = [String: Any]()
        par.update(other: geometry.queryParameters)
        par["key"] = apiKey
        if let queryParameters = parameters?.queryParameters { par.update(other: queryParameters) }

    
        Alamofire.request(APIRouter.radarsearch, parameters: par).responseDecodableObject { (response: DataResponse<GPResponse>) in
            
            switch response.result {
            case .success(let responseValue):
                if let error = responseValue.error {
                    completion(nil, error)
                } else {
                    completion(responseValue.results, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
            
        }
    }
    
    public func autocomplete(input: String, parameters: AutocompleteOptionalParameters?, completion: @escaping AutocompleteCompletion) {
        var par = [String: Any]()
        par["input"] = input
        par["key"] = apiKey
        if let queryParameters = parameters?.queryParameters { par.update(other: queryParameters) }
        
        Alamofire.request(APIRouter.autocomplete, parameters: par).responseDecodableObject { (response: DataResponse<GPResponse>) in
            
            switch response.result {
            case .success(let responseValue):
                if let error = responseValue.error {
                    completion(nil, error)
                } else {
                    completion(responseValue.predictions, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
             
        }
    }
    
    public func queryautocomplete(input: String, parameters: AutocompleteOptionalParameters?, completion: @escaping AutocompleteCompletion) {
        var par = [String: Any]()
        par["input"] = input
        par["key"] = apiKey
        if let queryParameters = parameters?.queryParameters { par.update(other: queryParameters) }
        
        Alamofire.request(APIRouter.queryautocomplete, parameters: par).responseDecodableObject { (response: DataResponse<GPResponse>) in
            
            switch response.result {
            case .success(let responseValue):
                if let error = responseValue.error {
                    completion(nil, error)
                } else {
                    completion(responseValue.predictions, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
            
        }
    }
    
    public func placeDetail(id: String, completion: @escaping PlaceCompletion) {
        var par = [String: Any]()
        par["placeid"] = id
        par["key"] = apiKey
        
        Alamofire.request(APIRouter.details, parameters: par).responseDecodableObject { (response: DataResponse<GPResponse>) in
            switch response.result {
            case .success(let responseValue):
                if let error = responseValue.error {
                    completion(nil, error)
                } else {
                    completion(responseValue.result, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
            
        }
    }
}

extension GPAPIClient {
    
    public struct AutocompleteOptionalParameters {
        public let offset: Int?
        public let geometry: Geometry?
        public let language: String?
        public let types: String?
        public let components: String?
        public let strictbounds: String?
        
        public init(offset: Int?, geometry: Geometry?, language: String?, types: String?, components: String?, strictbounds: String?) {
            self.offset = offset
            self.geometry = geometry
            self.language = language
            self.types = types
            self.components = components
            self.strictbounds = strictbounds
        }
        
        fileprivate var queryParameters: [String: Any] {
            var par = [String: Any]()
            par["offset"] = offset
            if let queryParameters = geometry?.queryParameters { par.update(other: queryParameters) }
            par["language"] = language
            par["types"] = types
            par["components"] = components
            par["strictbounds"] = strictbounds
            return par
        }
    }
    
    public struct SearchPlaceOptionalParameters {
        public let name: String?
        public let type: String?
        public let isOpenNow: Bool?
        public let keyword: String?
        public let language: String?
        
        public init(name: String? = nil, type: String? = nil, isOpenNow: Bool? = nil, keyword: String? = nil, language: String? = nil) {
            self.name = name
            self.type = type
            self.isOpenNow = isOpenNow
            self.keyword = keyword
            self.language = language
        }
        
        fileprivate var queryParameters: [String: Any] {
            var par = [String: Any]()
            par["keyword"] = keyword
            par["language"] = language
            par["opennow"] = isOpenNow
            par["type"] = type
            par["name"] = name
            return par
        }
    }
    
    public struct Geometry {
        public let location: CLLocationCoordinate2D
        public let radius: CLLocationDistance
        
        public init(location: CLLocationCoordinate2D, radius: CLLocationDistance) {
            self.location = location
            self.radius = radius
        }
        
        fileprivate var queryParameters: [String: Any] {
            return ["location": "\(location.latitude),\(location.longitude)",
                "radius": radius]
        }
    }
    
}

extension GPAPIClient {
    
    fileprivate enum APIRouter : URLConvertible {
        
        static let baseURLString = "https://maps.googleapis.com/maps/api/place/"
        
        case nearbysearch
        case textsearch
        case radarsearch
        
        case autocomplete
        case queryautocomplete
        
        case details
        
        func buildPath() -> String {
            switch self {
            case .nearbysearch:
                return "nearbysearch"
            case .textsearch:
                return "textsearch"
            case .radarsearch:
                return "radarsearch"
                
            case .autocomplete:
                return "autocomplete"
            case .queryautocomplete:
                return "queryautocomplete"
                
            case .details:
                return "details"
            }
        }
        
        /// Returns a URL that conforms to RFC 2396 or throws an `Error`.
        ///
        /// - throws: An `Error` if the type cannot be converted to a `URL`.
        ///
        /// - returns: A URL or throws an `Error`.
        func asURL() throws -> URL {
            return URL(string: buildPath() + "/json", relativeTo: URL(string: GPAPIClient.APIRouter.baseURLString))!
        }
    }
}

extension Dictionary {
    fileprivate mutating func update(other: Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
