//
//  LogoutViewController.swift
//  MadogSample
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

class LogoutViewController: UIViewController {
    private let authenticator: Authenticator
    private weak var context: Context?

    init(authenticator: Authenticator, context: Context) {
        self.authenticator = authenticator
        self.context = context

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ButtonView()
    }

    override func viewDidLoad() {
        guard let view = view as? ButtonView else {
            return
        }

        view.button.setTitle("Logout", for: .normal)
        view.button.addTarget(self, action: #selector(buttonTapGesture(sender:)), for: .touchUpInside)
    }
}

extension LogoutViewController {

    // MARK: UIButton interactions

    @objc
    private func buttonTapGesture(sender: UIButton) {
        authenticator.logout { (result) in
            let token = SampleToken.login
            let identifier = SingleUIIdentifier.createNavigationControllerIdentifier { (navigationController) in
                navigationController.isNavigationBarHidden = true
            }
            self.context?.change(to: identifier, token: token)
        }
    }
}
