//
//  Decodable+Extension.swift
//  SurfWeatherApp
//
//  Created by porohov on 23.05.2022.
//

import Foundation


extension Decodable {

    init(data: Data, decoder: JSONDecoder = JSONDecoder()) throws {
        self = try decoder.decode(Self.self, from: data)
    }

}
