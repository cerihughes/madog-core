//
//  ServiceProviderCreationContext.swift
//  Madog
//
//  Created by Ceri Hughes on 06/01/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol ServiceProviderCreationContext {
    var launchOptions: [UIApplication.LaunchOptionsKey : Any]? {get}
}

internal class ServiceProviderCreationContextImplementation: ServiceProviderCreationContext {
    internal var launchOptions: [UIApplication.LaunchOptionsKey : Any]?
}
