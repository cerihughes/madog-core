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
