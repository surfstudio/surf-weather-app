//
//  CoreAssembly.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 15.04.2021.
//

import Foundation

protocol CoreAssembly {
    var networkManager: RequestSenderable { get }
}

final class CoreAssemblyFactory: CoreAssembly {
    lazy var networkManager: RequestSenderable = NetworkManager()
}
