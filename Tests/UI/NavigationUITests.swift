//
//  NavigationUITests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import KIF
import XCTest

@testable import Madog

class NavigationUITests: KIFTestCase {
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
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		context = madog.renderUI(identifier: identifier, token: "vc1", in: window) as? NavigationModalContext
		viewTester().usingLabel("vc1")?.waitForView()
	}

	func testNavigateForwardAndBack() {
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		context = madog.renderUI(identifier: identifier, token: "vc1", in: window) as? NavigationModalContext
		viewTester().usingLabel("vc1")?.waitForView()

		context.navigateForward(token: "vc2", animated: true)
		viewTester().usingLabel("vc2")?.waitForView()

		context.navigateBack(animated: true)
		viewTester().usingLabel("vc1")?.waitForView()
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
