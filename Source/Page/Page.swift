//
//  Page.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

/// A protocol that describes a page that wants to provide a VC (or a number of VCs) for a given token by registering
/// with a ViewControllerRegistry.
public protocol Page {
    func register<Token, Context>(with registry: ViewControllerRegistry<Token, Context>)
    func unregister<Token, Context>(from registry: ViewControllerRegistry<Token, Context>)
}
