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
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier(customisation: customise(navigationController:))
		_ = madog.renderUI(identifier: identifier, token: "vc1", in: window)

		viewTester().usingLabel("CUSTOMISED")?.waitForView()
	}

	func testModalCustomisationBlock() {
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		let context = madog.renderUI(identifier: identifier, token: "vc1", in: window) as? ModalContext

		viewTester().usingLabel("CUSTOMISED")?.waitForAbsenceOfView()
		let identifierWithCustomisation = SingleUIIdentifier.createNavigationControllerIdentifier(customisation: customise(navigationController:))
		_ = context?.openModal(identifier: identifierWithCustomisation,
							   token: "vc2",
							   animated: true)

		viewTester().usingLabel("CUSTOMISED")?.waitForView()
	}

	private func customise(navigationController: UINavigationController) {
		let viewController = UIViewController()
		viewController.title = "CUSTOMISED"
		navigationController.pushViewController(viewController, animated: true)
	}
}

#endif
