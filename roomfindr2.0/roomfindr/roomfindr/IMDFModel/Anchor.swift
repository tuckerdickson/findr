/*
 
 Anchor.swift
 roomfindr

 This is the concrete class for IMDF Anchor features.
 This class inherits from the Feature class.

 Created on 2/25/23.
 
 */

import Foundation

class Anchor: Feature<Anchor.Properties> {
    // properties specific to Anchor
    struct Properties: Codable {
        let addressId: String//?            // unique ID of the associated address
        let unitId = UUID                   // unique ID of the associated unit
    }
}
