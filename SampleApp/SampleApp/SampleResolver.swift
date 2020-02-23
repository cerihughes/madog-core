//
//  SampleResolver.swift
//  MadogSample
//
//  Created by Ceri Hughes on 03/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog

class SampleResolver: Resolver<SampleToken> {
    override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<SampleToken>] {
        let login = { LoginViewControllerProvider() }
        let vc1 = { ViewController1Provider() }
        let vc2 = { ViewControllerProvider2() }
        let logout = { LogoutViewControllerProvider() }
        return [login, vc1, vc2, logout]
    }

    override func serviceProviderCreationFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        let authenticatorProviderCreationFunction = { context in AuthenticatorProvider(context: context) }
        let serviceProvider1CreationFunction = { context in ServiceProvider1(context: context) }
        return [authenticatorProviderCreationFunction, serviceProvider1CreationFunction]
    }
}
