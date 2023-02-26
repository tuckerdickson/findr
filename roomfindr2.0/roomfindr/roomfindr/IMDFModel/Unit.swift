/*
 
 Unit.swift
 roomfindr

 This is the concrete class for IMDF Unit features.
 This class inherits from the Feature class.

 Created on 2/25/23.
 
 */

import Foundation

class Unit: Feature<Unit.Properties> {
    // defines the properties specific to Unit
    struct Properties: Codable {
        let category: String                    // used to differentiate between different types of units
        let levelId: UUID                       // the identifier of the level to which this unit belongs
    }
    
    // units have occupants and amenities
    var occupants: [Occupant] = []
    var amenities: [Amenity] = []
    
}
