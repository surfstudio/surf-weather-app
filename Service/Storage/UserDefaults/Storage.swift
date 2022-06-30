//
//  Storage.swift
//  SurfWeatherApp
//
//  Created by porohov on 23.05.2022.
//

import Foundation

protocol Storage {
    static func getValue<T: Codable>(key: String) -> T?

    func getValue<T: Codable>(key: String) -> T?
    func setValue<T: Codable>(for newValue: T?, key: String)
    func clearAllValues()
}

extension Storage {

    static func getValue<T: Decodable>(key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        return try? T(data: data)
    }

    func setValue<T: Codable>(for newValue: T?, key: String) {
        guard let data = newValue?.toData() else {
            UserDefaults.standard.set(nil, forKey: key)
            return
        }
        UserDefaults.standard.set(data, forKey: key)
    }

    func getValue<T: Decodable>(key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        return try? T(data: data)
    }

    func clearAllValues() {
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }

}
