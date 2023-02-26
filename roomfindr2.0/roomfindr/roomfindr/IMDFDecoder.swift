/*
 
 IMDFDecoder.swift
 roomfindr

 This file defines the underlying framework for reading, decoding, and processing IMDF files.

 Created on 2/25/23.
 
 */

import Foundation
import MapKit


// a protocol defines an outline for methods that can be adopted by classes
// this protocol defines how to decode IMDF features
protocol IMDFDecodableFeature {
    init(feature: MKGeoJSONFeature) throws
}

// defines the path to the IMDF archive & different types of IMDF files
private struct IMDFArchive {
    // the path to the IMDF archive
    let baseDirectory: URL
    
    // initializer method
    init(baseDirectory: URL) {
        self.baseDirectory = baseDirectory
    }
    
    // IMDF files can take on one of the following types
    enum File {
        case address
        case amenity
        case anchor
        case building
        case detail
        case fixture
        case footprint
        case geofence
        case kiosk
        case level
        case manifest
        case occupant
        case opening
        case relationship
        case section
        case unit
        case venue
        
        // return name of file with ".geojson" appended
        var filename: String {
            return "\(self).geojson"
        }
    }
    
    // returns the path to an IMDF file
    func fileURL(for file: File) -> URL {
        return baseDirectory.appendingPathComponent(file.filename)
    }
}

// define two errors relating to IMDF data processing
enum IMDFError: Error {
    case invalidType
    case invalidData
}


class IMDFDecoder {
    private let geoJSONDecoder = MKGeoJSONDecoder()
    
    // decodes an IMDF archive
    func decode(_ imdfDirectory: URL) throws -> Venue {
        // define the archive using the URL passed in
        let archive = IMDFArchive(baseDirectory: imdfDirectory)
        
        // decode each of the different IMDF files
        let venues = try decodeFeatures(Venue.self, from: .venue, in: archive)
        let levels = try decodeFeatures(Level.self, from: .level, in: archive)
        let units = try decodeFeatures(Unit.self, from: .unit, in: archive)
        let openings = try decodeFeatures(Opening.self, from: .opening, in: archive)
        let amenities = try decodeFeatures(Amenity.self, from: .amenity, in: archive)
        let occupants = try decodeFeatures(Occupant.self, from: .occupant, in: archive)
        let anchors = try decodeFeatures(Anchor.self, from: .anchor, in: archive)
        
        // relate levels to the venue (there can only be one venue); sort levels by ordinal
        guard venues.count == 1 else {
            throw IMDFError.invalidData
        }
        let venue = venues[0]
        venue.levelsByOrdinal = Dictionary(grouping: levels, by: { $0.properties.ordinal })
        
        // levels contain units and openings, so we need to associate them
        // group units and openings by the level they're on
        let unitsByLevel = Dictionary(grouping: units, by: { $0.properties.levelId })
        let openingsByLevel = Dictionary(grouping: openings, by: { $0.properties.levelId })
        
        // for each level, associate all units and openings with matching levelIds
        for level in levels {
            if let unitsOnLevel = unitsByLevel[level.identifier] {
                level.units = unitsOnLevel
            }
            if let openingsOnLevel = openingsByLevel[level.identifier] {
                level.openings = openingsOnLevel
            }
        }
        
        // units contain amenities, so we need to relate amenities to the appropriate units
        let unitsById = units.reduce(into: [UUID: Unit]()) {
            $0[$1.identifier] = $1
        }
        
        // for each amenity, find all of the units it belongs to and make associations
        for amenity in amenities {
            // get the (lat,long) pair that locates the amenity
            guard let pointGeometry = amenity.geometry[0] as? MKPointAnnotation else {
                throw IMDFError.invalidData
            }
            amenity.coordinate = pointGeometry.coordinate
            
            // associate all appropriate units with this amenity
            for unitId in amenity.properties.unitIds {
                let unit = unitsById[unitId]
                unit?.amenities.append(amenity)
            }
        }
        
        // units also contain occupants, so we need to relate occupants to the appropriate units
        // occupants don't have geometry, they rely on anchors to get their display point
        let anchorsById = anchors.reduce(into: [UUID: Anchor]()) {
            $0[$1.identifier] = $1
        }
        
        // associate each occupant with the appropriate unit
        for occupant in occupants {
            // get the occupants location from the associated anchor
            guard let anchor = anchorsById[occupant.properties.anchorId] else {
                throw IMDFError.invalidData
            }
            
            guard let pointGeometry = anchor.geometry[0] as? MKPointAnnotation else {
                throw IMDFError.invalidData
            }
            occupant.coordinate = pointGeometry.coordinate
            
            // associate the unit with the occupant and vice versa
            guard let unit = unitsById[anchor.properties.unitId] else {
                continue
            }
            unit.occupants.append(occupant)
            occupant.unit = unit
        }
        
        return venue
    }
    
    // decodes a single IMDF file
    private func decodeFeatures<T: IMDFDecodableFeature>(_ type: T.Type, from file: IMDFArchive.File, in archive: IMDFArchive) throws -> [T] {
        // get the path to the IMDF file
        let fileURL = archive.fileURL(for: file)
        
        // read the contents of the file from disk
        let data = try Data(contentsOf: fileURL)
        
        // attempt to decode the data so that it can be displayed on the map
        let geoJSONFeatures = try geoJSONDecoder.decode(data)
        
        // try to convert the array of MKGeoJSONObject objects into an array of MKGeoJSONFeature objects
        guard let features = geoJSONFeatures as? [MKGeoJSONFeature] else {
            throw IMDFError.invalidType
        }
        
        // initialize instances of our model classes
        let imdfFeatures = try features.map { try type.init(feature: $0)}
        return imdfFeatures
    }
}
