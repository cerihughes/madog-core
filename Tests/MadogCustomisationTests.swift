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

        viewTester().usingLabel("CUSTOMISED")?.waitForView()
    }

    func testModalCustomisationBlock() {
        let context = madog.renderUI(identifier: .navigation, tokenData: .single("vc1"), in: window) as? ModalContext

        viewTester().usingLabel("CUSTOMISED")?.waitForAbsenceOfView()
        _ = context?.openModal(identifier: .navigation, tokenData: .single("vc1"), animated: true, customisation: customise(navigationController:))

        viewTester().usingLabel("CUSTOMISED")?.waitForView()
    }

    private func customise(navigationController: UINavigationController) {
        let viewController = UIViewController()
        viewController.title = "CUSTOMISED"
        navigationController.pushViewController(viewController, animated: true)
    }
}

#endif
