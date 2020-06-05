//
//  TabBarUITests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import Madog

class TabBarUITests: MadogUIKIFTestCase {
    private var window: UIWindow!
    private var madog: Madog<String>!
    private var context: TabBarUIContext!

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
        context = renderUIAndAssert(tokens: "vc1", "vc2")
        XCTAssertNil(context as? ForwardBackNavigationContext)
    }

    func testRenderInitialUI() {
        context = renderUIAndAssert(tokens: "vc1", "vc2")
        XCTAssertEqual(context.selectedIndex, 0)
        XCTAssertNotNil(context)
    }

    private func renderUIAndAssert(tokens: String ...) -> TabBarUIContext? {
        let identifier = MultiUIIdentifier.createTabBarIdentifier()
        let context = madog.renderUI(identifier: identifier, tokens: tokens, in: window)

        assert(tokens: tokens)

        return context as? TabBarUIContext
    }
}

#endif
