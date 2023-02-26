/*
 
 Venue.swift
 roomfindr

 This is the concrete class for IMDF Venue features.
 This class inherits from the Feature class.

 Created on 2/25/23.
 
 */

import Foundation

class Venue: Feature<Venue.Properties> {
    // properties specific to Venue
    struct Properties: Codable {
        let category: String                // type of Venue
    }
    
    // list of levels in the venue (to be ordered by ordinal)
    var levelsByOrdinal: [Int: [Level]] = [:]
}
