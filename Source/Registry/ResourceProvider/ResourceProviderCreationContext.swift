//
//  ResourceProviderCreationContext.swift
//  Madog
//
//  Created by Ceri Hughes on 06/01/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol ResourceProviderCreationContext {
    var launchOptions: [UIApplication.LaunchOptionsKey : Any]? {get}
}

internal class ResourceProviderCreationContextImplementation: ResourceProviderCreationContext {
    internal var launchOptions: [UIApplication.LaunchOptionsKey : Any]?
}
