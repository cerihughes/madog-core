//
//  ServiceProvider.swift
//  Madog
//
//  Created by Ceri Hughes on 19/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public protocol ServiceProvider {
    var name: String { get }
}

public protocol ServiceProviderCreationContext {
    var launchOptions: LaunchOptions? { get }
}

class ServiceProviderCreationContextImplementation: ServiceProviderCreationContext {
    var launchOptions: LaunchOptions?
}
