//
//  ViewControllerProvider.swift
//  Madog
//
//  Created by Ceri Hughes on 19/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnyViewControllerProvider<T> = any ViewControllerProvider<T>

/// A class that provides a VC for a given token by registering with a Registry.
public protocol ViewControllerProvider<T> {
    associatedtype T

    func configure(with serviceProvider: [String: ServiceProvider])
    func createViewController(token: T, context: AnyContext<T>) -> ViewController?
}

public extension ViewControllerProvider {
    func configure(with serviceProvider: [String: ServiceProvider]) {}
}
