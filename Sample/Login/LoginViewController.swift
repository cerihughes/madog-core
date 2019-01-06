//
//  LoginViewController.swift
//  MadogSample
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

class LoginViewController: UIViewController {
    var authenticator: Authenticator!
    weak var navigationContext: (Context & ForwardBackNavigationContext)?

    @IBOutlet private var usernameField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    static func createLoginViewController(authenticator: Authenticator, navigationContext: Context & ForwardBackNavigationContext) -> LoginViewController? {
        let storyboard = UIStoryboard(name: "LoginViewController", bundle: Bundle(for: LoginViewController.self))
        guard let loginViewController = storyboard.instantiateInitialViewController() as? LoginViewController else {
            return nil
        }

        loginViewController.authenticator = authenticator
        loginViewController.navigationContext = navigationContext
        return loginViewController
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let navigationContext = navigationContext else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.usernameField.text = "SomeUsername"
            self.passwordField.text = "SomePassword123"
            self.activityIndicator.startAnimating()

            self.authenticator.login(username: "SomeUsername", password: "SomePassword123", completion: { (result) in
                self.activityIndicator.stopAnimating()

                let tokens: [ResourceLocator] = [.page1ResourceLocator, .logoutPageResourceLocator]
                let identifier = MultiPageUIIdentifier.createTabBarControllerIdentifier()
                _ = navigationContext.change(to: identifier, with: tokens)
            })
        }
    }
}
