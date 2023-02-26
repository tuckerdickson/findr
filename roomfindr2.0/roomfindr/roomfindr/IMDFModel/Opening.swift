/*
 
 Opening.swift
 roomfindr

 This is the concrete class for IMDF Opening features.
 This class inherits from the Feature class.

 Created on 2/25/23.
 
 */

import Foundation

class Opening: Feature<Opening.Properties> {
    // properties specific to Opening
    struct Properties: Codable {
        let category: String            // type of opening
        let levelId: UUID               // unique ID of associated level
    }
    
    var openings: [Opening] = []
}
