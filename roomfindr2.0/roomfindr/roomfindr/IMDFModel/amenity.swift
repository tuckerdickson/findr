/*
 
 Amenity.swift
 roomfindr

 This is the concrete class for IMDF Amenity features.
 This class inherits from the Feature class.

 Created on 2/25/23.
 
 */

import Foundation
import MapKit

class Amenity: Feature<Amenity.Properties>, MKAnnotation {
    // defines properties specific to Amenity
    struct Properties: Codable {
        let category: String                // specifies a certain type of amenity (elevator, restroom, etc.)
        let name: LocalizedName?            // the name of the amenity
        let unitIds: [UUID]                 // the IDs of the units that fall under this type of amenity
    }
    
    var coordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    var title: String//?
    var subtitle: String//?
}
