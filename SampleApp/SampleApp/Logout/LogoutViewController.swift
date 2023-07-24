//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class LogoutViewController: UIViewController {
    private let authenticator: Authenticator
    private weak var context: AnyContext<SampleToken>?

    init(authenticator: Authenticator, context: AnyContext<SampleToken>) {
        self.authenticator = authenticator
        self.context = context

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ButtonView()
    }

    override func viewDidLoad() {
        guard let view = view as? ButtonView else { return }
        view.button.setTitle("Logout", for: .normal)
        view.button.addTarget(self, action: #selector(buttonTapGesture(sender:)), for: .touchUpInside)
    }
}

extension LogoutViewController {
    // MARK: - UIButton interactions

    @objc
    private func buttonTapGesture(sender _: UIButton) {
        authenticator.logout { _ in
            self.context?.change(to: .basic(), tokenData: .single(.login))
        }
    }
}
