//
//  TestViewControllerProvider.swift
//  MadogTests
//
//  Created by Ceri Hughes on 23/08/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

@testable import Madog

class TestViewControllerProvider: ViewControllerProvider<String> {
    private let matchString: String
    private var uuid: UUID?

    init(matchString: String) {
        self.matchString = matchString
        super.init()
    }

    final override func register(with registry: Registry<String>) {
        super.register(with: registry)

        uuid = registry.add(registryFunction: createViewController(token:context:))
    }

    final override func unregister(from registry: Registry<String>) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    func createViewController(token: String, context: Context) -> UIViewController? {
        if token == matchString {
            return UIViewController()
        }

        return nil
    }
}
