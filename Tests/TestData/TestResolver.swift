//
//  TestResolver.swift
//  MadogTests
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation
import Madog

class TestResolver: Resolver<String, Void> {
    private let testViewControllerProviderCreationFunctions: [() -> ViewControllerProvider<String, Void>]
    private let testServiceProviderCreationFunctions: [(ServiceProviderCreationContext) -> ServiceProvider]

    init(testViewControllerProviderCreationFunctions: [() -> ViewControllerProvider<String, Void>],
         testServiceProviderCreationFunctions: [(ServiceProviderCreationContext) -> ServiceProvider]) {
        self.testViewControllerProviderCreationFunctions = testViewControllerProviderCreationFunctions
        self.testServiceProviderCreationFunctions = testServiceProviderCreationFunctions

        super.init()
    }

    override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<String, Void>] {
        return testViewControllerProviderCreationFunctions
    }

    override func serviceProviderCreationFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        return testServiceProviderCreationFunctions
    }
}
