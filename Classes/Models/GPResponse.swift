//
//  GPResponse.swift
//  InFitting
//
//  Created by Max Lesichniy on 12.10.2017.
//  Copyright © 2017 OnCreate. All rights reserved.
//

import Foundation

struct GPResponse: Codable {
    
    enum Status: String, Codable {
        case ok = "OK"
        case zeroResult = "ZERO_RESULTS"
        case overQueryLimit = "OVER_QUERY_LIMIT"
        case requestDenied = "REQUEST_DENIED"
        case invalidRequest = "INVALID_REQUEST"
    }
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "error_message"
        case results = "results"
        case predictions = "predictions"
        case htmlAttributions = "html_attributions"
        case status = "status"
        case nextPageToken = "next_page_token"
    }
    
    // MARK: Properties
    let results: [GPPlace]?
    let predictions: [GPPrediction]?
    let htmlAttributions: [String]?
    let status: Status
    let errorMessage: String?
    let nextPageToken: String?
    
    var error: Error? {
        guard status != .ok, let message = errorMessage else { return nil }
        return NSError(domain: GPAPIClientErrorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
}


