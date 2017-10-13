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

public class GPAPIClient {
    
    public typealias PlasesCompletion = (_ placesList: [GPPlace]?, _ error: Error?) -> Void
    public typealias AutocompleteCompletion = (_ predictionsList: [GPPrediction]?, _ error: Error?) -> Void
    
    
    public static let instance = GPAPIClient()
    
    var apiKey: String?
    public var language: String? = nil
    
    public class func provideAPIKey(_ key: String?) {
        GPAPIClient.instance.apiKey = key
    }
    
    public func nearbySearch(geometry: Geometry, parameters: SearchPlaceOptionalParameters?, completion: @escaping PlasesCompletion) {
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
    
    public func search(with query: String, geometry: Geometry?, parameters: SearchPlaceOptionalParameters?, completion: @escaping PlasesCompletion) {
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
    
    public func radarSearch(geometry: Geometry, parameters: SearchPlaceOptionalParameters?, completion: @escaping PlasesCompletion) {
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
}

extension GPAPIClient {
    
    public struct AutocompleteOptionalParameters {
        let offset: Int?
        let geometry: Geometry?
        let language: String?
        let types: String?
        let components: String?
        let strictbounds: String?
        
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
        let name: String?
        let type: String?
        let isOpenNow: Bool?
        let keyword: String?
        let language: String?
        
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
        let location: CLLocationCoordinate2D
        let radius: CLLocationDistance
        
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
