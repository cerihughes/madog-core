//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

class ViewController1: UIViewController {
    private let sharedService: Any
    private weak var context: AnyForwardBackNavigationContext<SampleToken>?
    private var pushCount = 0

    init(sharedService: Any, context: AnyForwardBackNavigationContext<SampleToken>) {
        self.sharedService = sharedService
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
        view.button.setTitle("Push", for: .normal)
        view.button.addTarget(self, action: #selector(buttonTapGesture(sender:)), for: .touchUpInside)
    }
}

extension ViewController1 {
    // MARK: - UIButton interactions

    @objc
    private func buttonTapGesture(sender _: UIButton) {
        pushCount += 1
        let token = SampleToken.createVC2Identifier(stringData: String(pushCount))
        context?.navigateForward(token: token, animated: true)
    }
}
