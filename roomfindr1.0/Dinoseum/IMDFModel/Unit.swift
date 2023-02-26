/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The decoded representation of an IMDF Unit feature type.
*/

import Foundation

class Unit: Feature<Unit.Properties> {
    // defines the properties of a unit feature type
    struct Properties: Codable {
        let category: String        // differentiates between different types of units (office, classroom, etc.)
        let levelId: UUID           // identifier of the level with which the unit is associated
    }
    
    var occupants: [Occupant] = []
    var amenities: [Amenity] = []
}
