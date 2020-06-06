//
//  SampleResolver.swift
//  MadogSample
//
//  Created by Ceri Hughes on 03/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog

class SampleResolver: Resolver<SampleToken> {
    override func viewControllerProviderFunctions() -> [() -> ViewControllerProvider<SampleToken>] {
        [
            LoginViewControllerProvider.init,
            ViewController1Provider.init,
            ViewController2Provider.init,
            LogoutViewControllerProvider.init
        ]
    }

    override func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [
            AuthenticatorProvider.init(context:),
            ServiceProvider1.init(context:)
        ]
    }
}
