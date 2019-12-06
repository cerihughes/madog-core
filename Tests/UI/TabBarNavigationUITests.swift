//
//  TabBarNavigationUITests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import KIF
import XCTest

@testable import Madog

class TabBarNavigationUITests: KIFTestCase {
	private var window: UIWindow!
	private var madog: Madog<String>!
	private var context: NavigationModalContext!

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
		context = nil

		super.tearDown()
	}

	func testRenderInitialUI() {
		context = renderUIAndAssert(tokens: ["vc1", "vc2"])
		XCTAssertNotNil(context)
	}

	func testNavigateForwardAndBack() {
		context = renderUIAndAssert(tokens: ["vc1", "vc2"])
		navigateForwardAndAssert(token: "vc3", with: ["vc1", "vc2"])

		context.navigateBack(animated: true)
		viewTester().usingLabel("vc1")?.waitForView()
		viewTester().usingLabel("vc2")?.waitForView()
	}

	func testBackToRoot() {
		context = renderUIAndAssert(tokens: ["vc1", "vc2"])
		navigateForwardAndAssert(token: "vc3", with: ["vc1", "vc2"])
		navigateForwardAndAssert(token: "vc4", with: ["vc1", "vc2"])

		context?.navigateBackToRoot(animated: true)
		viewTester().usingLabel("vc1")?.waitForView()
	}

	private func renderUIAndAssert(tokens: [String]) -> NavigationModalContext? {
		let identifier = MultiUIIdentifier.createTabBarControllerIdentifier()
		let context = madog.renderUI(identifier: identifier, tokens: tokens, in: window)

		tokens.forEach {
			viewTester().usingLabel($0)?.waitForView()
		}

		return context as? NavigationModalContext
	}

	private func navigateForwardAndAssert(token: String, with: [String]? = nil) {
		context.navigateForward(token: token, animated: true)
		viewTester().usingLabel(token)?.waitForView()
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
		let viewController = UIViewController()
		viewController.title = token
		return viewController
	}
}
