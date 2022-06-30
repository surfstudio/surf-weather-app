//
//  FullAddressEntity.swift
//  SurfWeatherApp
//
//  Created by porohov on 20.05.2022.
//

import Foundation

public struct FullAddressEntity {

    // MARK: - Public Properties

    // отдельный дом Пример: 7
    public let house: String?

    // улица Пример: улица Тверская
    public let street: String?

    // станция метро Пример: метро Арбатская
    public let metro: String?

    // район города Пример: Северо-Восточный административный округ
    public let district: String?

    // населённый пункт: город / поселок / деревня / село и т. п.
    public let locality: String?

    // район области Приммер: Выборгский район
    public let area: String?

    // область Пример: Россия, Нижегородская область
    public let province: String?

    // станция метро Пример: метро Арбатская
    public let country: String?

    // координаты точки в формате `<долгота> <широта>`
    public let pos: String

    var coordsEntity: CordsEntity? {
        // Достаем координаты из яндекс формата долгота+широта
        let coordsComponents = pos.components(separatedBy: " ").compactMap(Double.init)
        guard coordsComponents.count == 2, let lat = coordsComponents.last, let long = coordsComponents.first else {
            return nil
        }
        return .init(lat: lat, lon: long)
    }

}
