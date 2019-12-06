//
//  MadogTests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 23/08/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import XCTest

@testable import Madog

class MadogTests: XCTestCase {
	private var madog: Madog<String>!

	override func setUp() {
		super.setUp()

		madog = Madog()
		madog.resolve(resolver: TestResolver())
	}

	override func tearDown() {
		madog = nil

		super.tearDown()
	}

	func testMadogDelegateHeldWeakly() {
		var delegate: MadogTestDelegate? = MadogTestDelegate()
		madog.delegate = delegate

		XCTAssertNotNil(madog.delegate)

		delegate = nil

		XCTAssertNil(madog.delegate)
	}

	func testMadogDelegate_singleUIIdentifier() {
		let delegate = MadogTestDelegate()
		madog.delegate = delegate

		let window = UIWindow()
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()

		let c1 = madog.renderUI(identifier: identifier, token: "match", in: window)
		let c2 = madog.renderUI(identifier: identifier, token: "no-match", in: window)

		XCTAssertNotNil(c1)
		XCTAssertNil(c2)

		XCTAssertEqual(delegate.successfulCreations.count, 1)
		XCTAssertNotNil(delegate.successfulCreations[0].0)
		XCTAssertEqual(delegate.successfulCreations[0].1, "match")

		XCTAssertEqual(delegate.unsuccessfulCreations.count, 1)
		XCTAssertEqual(delegate.unsuccessfulCreations[0], "no-match")
	}
}

private class TestResolver: Resolver<String> {
	override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<String>] {
		return [
			{ TestViewControllerProvider(matchString: "match") }
		]
	}
}

private class MadogTestDelegate: MadogDelegate {
	var successfulCreations = [(UIViewController, String)]()
	var unsuccessfulCreations = [String]()

	func madogDidCreateViewController(_ viewController: UIViewController, from token: Any) {
		successfulCreations.append((viewController, token as! String))
	}

	func madogDidNotCreateViewControllerFrom(_ token: Any) {
		unsuccessfulCreations.append(token as! String)
	}
}

private class TestViewControllerProvider: BaseViewControllerProvider {
	private let matchString: String

	init(matchString: String) {
		self.matchString = matchString
		super.init()
	}

	override func createViewController(token: String, context: Context) -> UIViewController? {
		if token == matchString {
			return UIViewController()
		}

		return super.createViewController(token: token, context: context)
	}
}
