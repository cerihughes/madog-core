//
//  Created by Ceri Hughes on 19/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation
import Provident

public typealias AnyViewControllerProvider<T> = any ViewControllerProvider<T>

/// A class that provides a VC for a given token by registering with a Registry.
public protocol ViewControllerProvider<T> {
    associatedtype T

    func configure(with serviceProvider: [String: ServiceProvider])
    func createViewController(token: T, container: AnyContainer<T>) -> ViewController?
}

public extension ViewControllerProvider {
    func configure(with serviceProvider: [String: ServiceProvider]) {}
}

extension ViewControllerProvider {
    func bridged() -> Provident.AnyViewControllerProvider<T, AnyContainer<T>> {
        ViewControllerProviderMadogBridge(bridged: self)
    }
}

extension Provident.ViewControllerProvider where C == AnyContainer<T> {
    func bridged() -> AnyViewControllerProvider<T> {
        ViewControllerProviderProvidentBridge(bridged: self)
    }
}

class ViewControllerProviderMadogBridge<T>: Provident.ViewControllerProvider {
    typealias C = AnyContainer<T>

    private let bridged: AnyViewControllerProvider<T>

    init(bridged: AnyViewControllerProvider<T>) {
        self.bridged = bridged
    }

    func register(with registry: Provident.AnyRegistry<T, C>) {
        // No-op
    }

    func configure(with serviceProviders: [String: Provident.ServiceProvider]) {
        bridged.configure(with: serviceProviders)
    }

    func createViewController(token: T, context: C) -> Provident.ViewController? {
        bridged.createViewController(token: token, container: context)
    }
}

class ViewControllerProviderProvidentBridge<T>: ViewControllerProvider {
    private let bridged: Provident.AnyViewControllerProvider<T, AnyContainer<T>>

    init(bridged: Provident.AnyViewControllerProvider<T, AnyContainer<T>>) {
        self.bridged = bridged
    }

    func configure(with serviceProviders: [String: Provident.ServiceProvider]) {
        bridged.configure(with: serviceProviders)
    }

    func createViewController(token: T, container: AnyContainer<T>) -> Provident.ViewController? {
        bridged.createViewController(token: token, context: container)
    }
}
