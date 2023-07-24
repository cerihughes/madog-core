//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow()
    let madog = Madog<SampleToken>()

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        madog.resolve(resolver: SampleResolver(), launchOptions: launchOptions)
        let result = madog.addUICreationFunction(
            identifier: .split(),
            function: SplitUI.init(registry:primaryToken:secondaryToken:)
        )
        guard result == true else {
            return false
        }

        window.makeKeyAndVisible()

        let initial = SampleToken.login
        let context = madog.renderUI(identifier: .split(), tokenData: .splitSingle(initial, nil), in: window)
        return context != nil
    }

    func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        guard let currentContext = madog.currentContext else {
            return false
        }

        let token = SampleToken.createVC2Identifier(stringData: String(url.absoluteString.count))
        if let navigationContext = currentContext as? AnyForwardBackNavigationContext<SampleToken> {
            return navigationContext.navigateForward(token: token, animated: true)
        } else {
            return currentContext.change(to: .navigation(), tokenData: .single(token)) != nil
        }
    }
}
