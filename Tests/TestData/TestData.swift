//
//  TestViewControllerProvider.swift
//  MadogTests
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation
import Madog

class TestViewControllerProvider: ViewControllerProvider<String, Void> {
    var registered = false, unregistered = false
    var capturedServiceProviders: [String : ServiceProvider]? = nil
    override func register(with registry: ViewControllerRegistry<String, Void>) {
        registered = true
    }
    override func unregister(from registry: ViewControllerRegistry<String, Void>) {
        unregistered = true
    }
    override func configure(with serviceProviders: [String : ServiceProvider]) {
        capturedServiceProviders = serviceProviders
    }
}

class TestServiceProvider: ServiceProvider {
    required init(context: ServiceProviderCreationContext) {
        super.init(context: context)
        name = String(describing: TestServiceProvider.self)
    }
}

class TestViewControllerProviderFactory {
    static var created = false
    static func createViewControllerProvider() -> ViewControllerProvider<String, Void> {
        created = true
        return TestViewControllerProvider()
    }
}

class TestServiceProviderFactory {
    static var created = false
    static func createServiceProvider(context: ServiceProviderCreationContext) -> ServiceProvider {
        created = true
        return TestServiceProvider(context: context)
    }
}
