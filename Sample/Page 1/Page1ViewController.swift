//
//  Page1ViewController.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

class Page1ViewController: UIViewController {
    private let state1: State1
    private weak var navigationContext: ForwardBackNavigationContext?
    private var pushCount = 0

    init(state1: State1, navigationContext: ForwardBackNavigationContext) {
        self.state1 = state1
        self.navigationContext = navigationContext

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

        view.button.setTitle("Push", for: .normal)
        view.button.addTarget(self, action: #selector(buttonTapGesture(sender:)), for: .touchUpInside)
    }
}

extension Page1ViewController {

    // MARK: UIButton interactions

    @objc
    private func buttonTapGesture(sender: UIButton) {
        pushCount += 1
        let token = ResourceLocator.createPage2ResourceLocator(pageData: String(pushCount))
        _ = self.navigationContext?.navigateForward(with: token, animated: true)
    }
}
