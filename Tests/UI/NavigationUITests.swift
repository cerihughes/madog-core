//
//  NavigationUITests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import Madog

class NavigationUITests: MadogUIKIFTestCase {
    private var window: UIWindow!
    private var madog: Madog<String>!
    private var context: NavigationUIContext!

    override func setUp() {
        super.setUp()

        window = UIWindow()
        window.makeKeyAndVisible()
        madog = Madog()
        madog.resolve(resolver: KIFTestResolver())
    }

    override func tearDown() {
        window = nil
        madog = nil
        context = nil

        super.tearDown()
    }

    func testProtocolConformance() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNil(context as? MultiContext)
    }

    func testRenderInitialUI() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNotNil(context)
    }

    func testNavigateForwardAndBack() {
        context = renderUIAndAssert(token: "vc1")
        navigateForwardAndAssert(token: "vc2")

        context.navigateBack(animated: true)
        viewTester().usingLabel("vc1")?.waitForView()
    }

    func testBackToRoot() {
        context = renderUIAndAssert(token: "vc1")
        navigateForwardAndAssert(token: "vc2")
        navigateForwardAndAssert(token: "vc3")

        context?.navigateBackToRoot(animated: true)
        viewTester().usingLabel("vc1")?.waitForView()
    }

    private func renderUIAndAssert(token: String) -> NavigationUIContext? {
        let identifier = SingleUIIdentifier.createNavigationIdentifier()
        let context = madog.renderUI(identifier: identifier, token: token, in: window)
        viewTester().usingLabel(token)?.waitForView()
        return context as? NavigationUIContext
    }

    private func navigateForwardAndAssert(token: String) {
        context.navigateForward(token: token, animated: true)
        viewTester().usingLabel(token)?.waitForView()
    }
}

#endif
