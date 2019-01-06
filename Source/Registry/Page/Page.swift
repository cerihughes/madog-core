//
//  Page.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

/// A protocol that describes a page that wants to provide a VC (or a number of VCs) for a given token by registering
/// with a ViewControllerRegistry.
public protocol Page {
    func register(with registry: ViewControllerRegistry)
    func unregister(from registry: ViewControllerRegistry)
    func configure(with resourceProviders: [String : ResourceProvider])
}
