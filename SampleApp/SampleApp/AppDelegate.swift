//
//  AppDelegate.swift
//  MadogSample
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

    func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        madog.resolve(resolver: SampleResolver(), launchOptions: launchOptions)
        let result = madog.addSingleUICreationFunction(identifier: splitViewControllerIdentifier) { SplitUI() }
        guard result == true else {
            return false
        }

        window.makeKeyAndVisible()

        let initial = SampleToken.login
        let identifier = SingleUIIdentifier.createSplitViewControllerIdentifier { splitController in
            splitController.preferredDisplayMode = .allVisible
            splitController.presentsWithGesture = false
        }
        return madog.renderUI(identifier: identifier, token: initial, in: window) != nil
    }

    func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        guard let currentContext = madog.currentContext else {
            return false
        }

        let token = SampleToken.createVC2Identifier(stringData: String(url.absoluteString.count))
        if let navigationContext = currentContext as? ForwardBackNavigationContext {
            return navigationContext.navigateForward(token: token, animated: true)
        } else {
            let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
            return currentContext.change(to: identifier, token: token) != nil
        }
    }
}

let splitViewControllerIdentifier = "splitViewControllerIdentifier"

extension SingleUIIdentifier {
    public static func createSplitViewControllerIdentifier(
        customisation: @escaping (UISplitViewController) -> Void = { _ in }
    ) -> SingleUIIdentifier<UISplitViewController> {
        SingleUIIdentifier<UISplitViewController>(splitViewControllerIdentifier, customisation: customisation)
    }
}
