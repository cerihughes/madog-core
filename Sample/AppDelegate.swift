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
    let ui = NavigationUI<ResourceLocator>()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let initialViewController = ui.resolveInitialViewController(pageResolver: RuntimePageResolver()) else {
            return false
        }

        window.rootViewController = initialViewController
        window.makeKeyAndVisible()

        return true
    }
}
