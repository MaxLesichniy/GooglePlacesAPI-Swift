//
//  GPPrediction.swift
//  InFitting
//
//  Created by Max Lesichniy on 13.10.2017.
//  Copyright © 2017 OnCreate. All rights reserved.
//

import Foundation

public struct GPPrediction: Codable {
    
    public struct MatchedSubstring: Codable {
        public var offset: Int?
        public var length: Int?
    }
    
    public struct StructuredFormatting: Codable {
        
        enum CodingKeys: String, CodingKey {
            case secondaryText = "secondary_text"
            case mainText = "main_text"
            case mainTextMatchedSubstrings = "main_text_matched_substrings"
        }
        
        public var secondaryText: String?
        public var mainText: String?
        public var mainTextMatchedSubstrings: [MatchedSubstring]?
    }
    
    public struct Term: Codable {
        // MARK: Properties
        public let offset: Int?
        public let value: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case reference = "reference"
        case matchedSubstrings = "matched_substrings"
        case id = "id"
        case structuredFormatting = "structured_formatting"
        case descriptionValue = "description"
        case placeId = "place_id"
        case terms = "terms"
        case types = "types"
    }
    
    // MARK: Properties
    public var reference: String?
    public var matchedSubstrings: [MatchedSubstring]?
    public var id: String?
    public var structuredFormatting: StructuredFormatting?
    public var descriptionValue: String?
    public var placeId: String?
    public var terms: [Term]?
    public var types: [String]?
    
}
