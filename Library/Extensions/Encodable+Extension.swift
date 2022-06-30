//
//  Encodable+Extension.swift
//  SurfWeatherApp
//
//  Created by porohov on 23.05.2022.
//

import Foundation

extension Encodable {

    func toData(with encoder: JSONEncoder = JSONEncoder()) -> Data? {
        return try? encoder.encode(self)
    }

}
