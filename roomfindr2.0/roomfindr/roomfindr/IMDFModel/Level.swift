/*
 
 Level.swift
 roomfindr

 This is the concrete class for IMDF Level features.
 This class inherits from the Feature class.

 Created on 2/25/23.
 
 */

import Foundation

class Level: Feature<Level.Properties> {
    // properties specific to level
    struct Properties: Codable {
        let ordinal: Int                        // order that levels are displayed
        let category: String                    // type of level
        let shortName: LocalizedName            // shorthand name for level (e.g. L1)
        let outdoor: Bool                       // whether the level is outdoors
        let buildingIds: [String]//?            // unique ID of associated building
    }
    
    // Levels have units and openings
    var units: [Unit] = []
    var openings: [Opening] = []
}
