//
//  IMDFDecoder.swift
//  roomfindr
//
//  Created by Tucker Dickson on 2/25/23.
//

import Foundation
import MapKit

protocol IMDFDecodableFeature {
    init(feature: MKGeoJSONFeature) throws
}

// define two errors relating to IMDF data processing
enum IMDFError: Error {
    case invalidType
    case invalidData
}
