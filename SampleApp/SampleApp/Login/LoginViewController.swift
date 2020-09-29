//
//  LoginViewController.swift
//  MadogSample
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

class LoginViewController: UIViewController {
    var authenticator: Authenticator!
    weak var context: Context?

    @IBOutlet private var usernameField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    static func createLoginViewController(authenticator: Authenticator, context: Context) -> LoginViewController? {
        let storyboard = UIStoryboard(name: "LoginViewController", bundle: Bundle(for: LoginViewController.self))
        guard let loginViewController = storyboard.instantiateInitialViewController() as? LoginViewController else {
            return nil
        }

        loginViewController.authenticator = authenticator
        loginViewController.context = context
        return loginViewController
    }

    override func viewDidAppear(_: Bool) {
        guard let context = context else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.usernameField.text = "SomeUsername"
            self.passwordField.text = "SomePassword123"
            self.activityIndicator.startAnimating()

            self.authenticator.login(username: "SomeUsername", password: "SomePassword123", completion: { _ in
                self.activityIndicator.stopAnimating()

                let tokens: [SampleToken] = [.vc1, .logout]
                context.change(to: .tabBarNavigation, tokenData: .multi(tokens))
            })
        }
    }
}
