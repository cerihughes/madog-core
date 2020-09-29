//
//  MadogCustomisationTests.swift
//  Madog
//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import Madog

class MadogCustomisationTests: MadogKIFTestCase {
    func testMainCustomisationBlock() {
        _ = madog.renderUI(identifier: .navigation, tokenData: .single("vc1"), in: window, customisation: customise(navigationController:))

        viewTester().waitForTitle(token: "CUSTOMISED")
    }

    func testModalCustomisationBlock() {
        let context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? ModalContext

        viewTester().waitForAbsenceOfTitle(token: "CUSTOMISED")
        _ = context?.openModal(identifier: .navigation, tokenData: .single("vc1"), animated: true, customisation: customise(navigationController:))

        viewTester().waitForTitle(token: "CUSTOMISED")
    }

    private func customise(navigationController: UINavigationController) {
        let viewController = UIViewController()
        viewController.title = "CUSTOMISED"
        navigationController.pushViewController(viewController, animated: true)
    }
}

#endif
