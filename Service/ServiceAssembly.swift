//
//  ServiceAssembly.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 15.04.2021.
//

import Foundation

protocol ServicesAssembly {
    var weatherNetworkService: WeatherNetworkService { get }
}

final class ServicesAssemblyFactory: ServicesAssembly {

    private let coreAssembly: CoreAssembly = CoreAssemblyFactory()

    lazy var weatherNetworkService: WeatherNetworkService = NetworkService(networkManager: coreAssembly.networkManager)

}
