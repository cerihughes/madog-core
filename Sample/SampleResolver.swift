//
//  SampleResolver.swift
//  MadogSample
//
//  Created by Ceri Hughes on 03/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog

class SampleResolver: Resolver<SampleToken, Context> {
    override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<SampleToken, Context>] {
        let login = { return LoginViewControllerProvider() }
        let vc1 = { return ViewController1Provider() }
        let vc2 = { return ViewControllerProvider2() }
        let logout = { return LogoutViewControllerProvider() }
        return [login, vc1, vc2, logout]
    }

    override func serviceProviderCreationFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        let authenticatorProviderCreationFunction = { context in return AuthenticatorProvider(context: context) }
        let serviceProvider1CreationFunction = { context in return ServiceProvider1(context: context) }
        return [authenticatorProviderCreationFunction, serviceProvider1CreationFunction]
    }
}
