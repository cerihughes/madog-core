//
//  Created by Ceri Hughes on 03/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore

class SampleResolver: Resolver {
    func viewControllerProviderFunctions() -> [() -> AnyViewControllerProvider<SampleToken>] {
        [
            LoginViewControllerProvider.init,
            ViewController1Provider.init,
            ViewController2Provider.init,
            LogoutViewControllerProvider.init
        ]
    }

    func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [
            AuthenticatorProvider.init(context:),
            ServiceProvider1.init(context:)
        ]
    }
}
