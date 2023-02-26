/*
 
 Feature.swift
 roomfindr

 This is the base class for all IMDF features.

 Created on 2/25/23.
 
 */

import Foundation
import MapKit

class Feature<Properties: Decodable>: NSObject, IMDFDecodableFeature {
    // properties common amongst all Feature types
    let identifier: UUID                        // uniquely identifies a particular feature
    let properties: Properties                  // things like name, feature type, ordinal, etc.
    let geometry: [MKShape & MKGeoJSONObject]   // physical geometry of the feature
    
    /*
     Description: This is the initializer for the abstract Feature base class.
     Input: feature - The decoded representation of a GeoJSON feature.
     Output: a new Feature object
     */
    required init(feature: MKGeoJSONFeature) throws {
        // guard against missing identifier
        guard let uuidString = feature.identifier else { throw IMDFError.invalidData }
        
        // try to initialize self.identifier using uuidString passed in
        if let identifier = UUID(uuidString: uuidString) {
            self.identifier = identifier
        } else {
            throw IMDFError.invalidData
        }
        
        // property data must be decoded before it can be used
        if let propertiesData = feature.properties {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.properties = try decoder.decode(Properties.self, from: propertiesData)
        } else {
            throw IMDFError.invalidData
        }
        
        // initialize geometry
        self.geometry = feature.geometry
        
        // IMDFDecodableFeature init
        super.init()
    }
}
