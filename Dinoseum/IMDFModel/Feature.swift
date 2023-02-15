/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The base class for all IMDF Features (Amenity, Anchor, Level, etc.).
*/

import Foundation
import MapKit

class Feature<Properties: Decodable>: NSObject, IMDFDecodableFeature {
    let identifier: UUID                        // uniquely identifies a particular feature
    let properties: Properties                  // things like name, feature type, ordinal, etc.
    let geometry: [MKShape & MKGeoJSONObject]   // physical geometry of the feature
    
    // initializer method
    required init(feature: MKGeoJSONFeature) throws {
        // ensure the feature has an identifier
        guard let uuidString = feature.identifier else {
            throw IMDFError.invalidData
        }
        
        // validate the uuid
        if let identifier = UUID(uuidString: uuidString) {
            self.identifier = identifier
        } else {
            throw IMDFError.invalidData
        }
        
        // ensure the feature has properties and if so, decode them
        if let propertiesData = feature.properties {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            properties = try decoder.decode(Properties.self, from: propertiesData)
        } else {
            throw IMDFError.invalidData
        }
        
        self.geometry = feature.geometry
        
        super.init()
    }
}

