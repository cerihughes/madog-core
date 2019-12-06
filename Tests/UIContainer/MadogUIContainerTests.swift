//
//  MadogUIContainerTests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import KIF
import XCTest

@testable import Madog

class MadogUIContainerTests: KIFTestCase {
	private var window: UIWindow!
	private var madog: Madog<String>!

	override func setUp() {
		super.setUp()

		window = UIWindow()
		window.makeKeyAndVisible()
		madog = Madog()
		madog.resolve(resolver: TestResolver())
	}

	override func tearDown() {
		window = nil
		madog = nil

		super.tearDown()
	}

	func testChangeSingleToMulti() {
		let identifier1 = SingleUIIdentifier.createNavigationControllerIdentifier()
		var context = madog.renderUI(identifier: identifier1, token: "vc1", in: window)
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		let identifier2 = MultiUIIdentifier.createTabBarControllerIdentifier()
		context = context?.change(to: identifier2, tokens: ["vc2", "vc3"])
		viewTester().usingLabel("vc1")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc2")?.waitForView()
		viewTester().usingLabel("vc3")?.waitForView()
		XCTAssertNotNil(context)
	}

	func testChangeMultiToSingle() {
		let identifier1 = MultiUIIdentifier.createTabBarControllerIdentifier()
		var context = madog.renderUI(identifier: identifier1, tokens: ["vc1", "vc2"], in: window)
		viewTester().usingLabel("vc1")?.waitForView()
		viewTester().usingLabel("vc2")?.waitForView()
		XCTAssertNotNil(context)

		let identifier2 = SingleUIIdentifier.createNavigationControllerIdentifier()
		context = context?.change(to: identifier2, token: "vc3")
		viewTester().usingLabel("vc1")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc2")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc3")?.waitForView()
		XCTAssertNotNil(context)
	}

	func testOpenModal() {
		let identifier1 = SingleUIIdentifier.createNavigationControllerIdentifier()
		let context = madog.renderUI(identifier: identifier1, token: "vc1", in: window) as? NavigationModalContext
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		let token = context?.openModal(token: "vc2", presentationStyle: .formSheet, animated: true)
		XCTAssertNotNil(token)
		viewTester().usingLabel("vc1")?.waitForView()
		viewTester().usingLabel("vc2")?.waitForView()
		XCTAssertNotNil(context)
	}

	func testOpenSingleUIModal() {
		let identifier1 = SingleUIIdentifier.createNavigationControllerIdentifier()
		let context = madog.renderUI(identifier: identifier1, token: "vc1", in: window) as? NavigationModalContext
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		let identifier2 = SingleUIIdentifier.createNavigationControllerIdentifier()
		let context2 = context?.openModal(identifier: identifier2,
										  token: "vc2",
										  presentationStyle: .formSheet,
										  animated: true) as? NavigationModalContext
		XCTAssertNotNil(context2)

		viewTester().usingLabel("vc1")?.waitForView()
		viewTester().usingLabel("vc2")?.waitForView()

		context2?.navigateForward(token: "vc3", animated: true)
		context2?.navigateForward(token: "vc4", animated: true)
		viewTester().usingLabel("vc2")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc1")?.waitForView()
		viewTester().usingLabel("vc3")?.waitForView()
	}

	func testOpenMultiUIModal() {
		let identifier1 = SingleUIIdentifier.createNavigationControllerIdentifier()
		let context = madog.renderUI(identifier: identifier1, token: "vc1", in: window) as? NavigationModalContext
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		let identifier2 = MultiUIIdentifier.createTabBarControllerIdentifier()
		var context2 = context?.openModal(identifier: identifier2,
										  tokens: ["vc2", "vc3"],
										  presentationStyle: .formSheet,
										  animated: true) as? NavigationModalMultiContext
		XCTAssertNotNil(context2)

		viewTester().usingLabel("vc1")?.waitForView()
		viewTester().usingLabel("vc2")?.waitForView()
		viewTester().usingLabel("vc3")?.waitForView()

		context2?.navigateForward(token: "vc4", animated: true)
		viewTester().usingLabel("vc4")?.waitForView()

		context2?.navigateForward(token: "vc5", animated: true)
		context2?.navigateForward(token: "vc6", animated: true)
		viewTester().usingLabel("vc4")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc5")?.waitForView()
		viewTester().usingLabel("vc6")?.waitForView()

		context2?.selectedIndex = 1
		context2?.navigateForward(token: "vc7", animated: true)
		viewTester().usingLabel("vc7")?.waitForView()

		context2?.navigateForward(token: "vc8", animated: true)
		context2?.navigateForward(token: "vc9", animated: true)
		viewTester().usingLabel("vc7")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc8")?.waitForView()
		viewTester().usingLabel("vc9")?.waitForView()

		context2?.selectedIndex = 0
		viewTester().usingLabel("vc9")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc6")?.waitForView()
	}
}

private class TestResolver: Resolver<String> {
	override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<String>] {
		return [
			{ TestViewControllerProvider() }
		]
	}
}

private class TestViewControllerProvider: BaseViewControllerProvider {
	override func createViewController(token: String, context: Context) -> UIViewController? {
		let viewController = TestViewController()
		viewController.title = token
		viewController.label.text = token
		return viewController
	}
}

private class TestViewController: UIViewController {
	let label = UILabel()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(label)
	}
}
