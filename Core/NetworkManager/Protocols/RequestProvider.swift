//
//  RequestProvider.swift
//  SurfWeatherApp
//
//  Created by porohov on 05.05.2022.
//

import Foundation

protocol RequestProvider {
    var urlRequest: URLRequest? { get }
}
