/*
 
 Occupant.swift
 roomfindr

 This is the concrete class for IMDF Occupant features.
 This class inherits from the Feature class.

 Created on 2/25/23.
 
 */

import Foundation
import MapKit

class Occupant: Feature<Occupant.Properties>, MKAnnotation {
    // properties specific to Occupant
    struct Properties: Codable {
        let category: String                // type of Occupant
        let name: LocalizedName             // name of Occupant
        let anchorId: UUID                  // unique ID of associated Anchor
        let hours: String//?                // business hours of the occupant
        let phone: String//?                // phone number of the occupant
        let website: URL//?                 // web address associated with the occupant
    }
    
    var coordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    var title: String?
    var subtitle: String?
    weak var unit: Unit?
}
