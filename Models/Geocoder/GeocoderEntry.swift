//
//  GeocoderEntry.swift
//  Models
//
//  Created by porohov on 12.01.2022.
//
import Foundation

// MARK: - GeocoderResponseEntry

public struct GeocoderResponseEntry: Codable {
    public let response: GeocoderEntry?
}

// MARK: - GeocoderEntry

public struct GeocoderEntry: Codable {
    public let GeoObjectCollection: GeoObjectCollectionEntry
}

// MARK: - GeoObjectCollectionEntry

public struct GeoObjectCollectionEntry: Codable {
    public let featureMember: [GeoObjectsEntry]
}

// MARK: - GeoObjectsEntry

public struct GeoObjectsEntry: Codable {
    public let GeoObject: GeoObjectEntry
}

// MARK: - GeoObjectEntry

public struct GeoObjectEntry: Codable {
    public let Point: GeocoderPointEntry
    public let metaDataProperty: GeocoderDataEntry
}

// MARK: - GeocoderPointEntry

public struct GeocoderPointEntry: Codable {
    public let pos: String
}

// MARK: - GeocoderDataEntry

public struct GeocoderDataEntry: Codable {
    public let GeocoderMetaData: GeocoderMetaDataEntry
}

// MARK: - GeocoderMetaDataEntry

public struct GeocoderMetaDataEntry: Codable {
    public let Address: GeocoderAddressEntry
}

// MARK: - GeocoderAddressEntry

public struct GeocoderAddressEntry: Codable {
    public let Components: [GeocoderComponentsEntry]
}

// MARK: - GeocoderComponentsEntry

public struct GeocoderComponentsEntry: Codable {
    public let kind: String
    public let name: String
}
