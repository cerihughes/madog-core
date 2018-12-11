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
    let madog = Madog<ResourceLocator>(resolver: RuntimeResolver())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let result = madog.addSinglePageUICreationFunction(identifier: splitViewControllerIdentifier) { return SplitUI() }
        guard result == true else {
            return false
        }

        window.makeKeyAndVisible()


        let initialRL = ResourceLocator.createLoginPageResourceLocator()
        let identifier = SinglePageUIIdentifier.createSplitViewControllerIdentifier { (splitController) in
            splitController.preferredDisplayMode = .allVisible
            splitController.presentsWithGesture = false
        }
        return madog.renderSinglePageUI(identifier, with: initialRL, in: window)
    }
}

let splitViewControllerIdentifier = "splitViewControllerIdentifier"

extension SinglePageUIIdentifier {
    public static func createSplitViewControllerIdentifier(customisation: @escaping (UISplitViewController) -> Void = { _ in }) -> SinglePageUIIdentifier<UISplitViewController> {
        return SinglePageUIIdentifier<UISplitViewController>(splitViewControllerIdentifier, customisation: customisation)
    }
}
