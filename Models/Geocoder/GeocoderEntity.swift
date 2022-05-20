//
//  GeocoderEntity.swift
//  Models
//
//  Created by porohov on 12.01.2022.
//

public struct GeocoderEntity {

    // MARK: - Public Properties

    public let response: GeocoderResponseEntry

    // MARK: - Initialization

    public init(response: GeocoderResponseEntry) {
        self.response = response
    }

    public func getAddressesComponents() -> [FullAddressEntity] {
        let address = response.response?.GeoObjectCollection.featureMember.compactMap {
            (address: $0.GeoObject.metaDataProperty.GeocoderMetaData.Address, point: $0.GeoObject.Point)
        } ?? []

        return address.compactMap {
            .init(house: $0.address.getElement("house"),
                  street: $0.address.getElement("street"),
                  metro: $0.address.getElement("metro"),
                  district: $0.address.getElement("district"),
                  locality: $0.address.getElement("locality"),
                  area: $0.address.getElement("area"),
                  province: $0.address.getElement("province"),
                  country: $0.address.getElement("country"),
                  pos: $0.point.pos)
        }
    }

}

extension GeocoderAddressEntry {

    public func getElement(_ kind: String) -> String? {
        return Components.first(where: { $0.kind == kind })?.name
    }

}
