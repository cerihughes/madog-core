//
//  AppDelegate.swift
//  MadogSample
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow()
    let madog = Madog<ResourceLocator>()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        madog.resolve(resolver: RuntimeResolver(), launchOptions: launchOptions)
        let result = madog.addSinglePageUICreationFunction(identifier: splitViewControllerIdentifier) { return SplitUI() }
        guard result == true else {
            return false
        }

        window.makeKeyAndVisible()

        let initialRL = ResourceLocator.loginPageResourceLocator
        let identifier = SinglePageUIIdentifier.createSplitViewControllerIdentifier { (splitController) in
            splitController.preferredDisplayMode = .allVisible
            splitController.presentsWithGesture = false
        }
        return madog.renderSinglePageUI(identifier, with: initialRL, in: window)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let currentContext = madog.currentContext else {
            return false
        }

        let token = ResourceLocator.createPage2ResourceLocator(pageData: String(url.absoluteString.count))
        if let navigationContext = currentContext as? ForwardBackNavigationContext {
            return navigationContext.navigateForward(with: token, animated: true) != nil
        } else {
            let identifier = SinglePageUIIdentifier.createNavigationControllerIdentifier()
            return currentContext.change(to: identifier, with: token)
        }
    }
}

let splitViewControllerIdentifier = "splitViewControllerIdentifier"

extension SinglePageUIIdentifier {
    public static func createSplitViewControllerIdentifier(customisation: @escaping (UISplitViewController) -> Void = { _ in }) -> SinglePageUIIdentifier<UISplitViewController> {
        return SinglePageUIIdentifier<UISplitViewController>(splitViewControllerIdentifier, customisation: customisation)
    }
}
