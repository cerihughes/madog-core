//
//  StateCreationContext.swift
//  Madog
//
//  Created by Ceri Hughes on 06/01/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol StateCreationContext {
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]? {get}
}

internal class StateCreationContextImplementation: StateCreationContext {
    internal var launchOptions: [UIApplication.LaunchOptionsKey : Any]?
}
