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
        window.makeKeyAndVisible()

        let initialRL = ResourceLocator.createLoginPageResourceLocator()
        let identifier = SinglePageUIIdentifier.createNavigationControllerIdentifier { (navigationController) in
            navigationController.isNavigationBarHidden = true
        }
        return madog.renderSinglePageUI(identifier, with: initialRL, in: window)
    }
}
