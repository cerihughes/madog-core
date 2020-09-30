//
//  BasicUITests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import Madog

class BasicUITests: MadogKIFTestCase {
    private var context: BasicUIContext!

    override func afterEach() {
        context = nil

        super.afterEach()
    }

    func testProtocolConformance() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNil(context as? ForwardBackNavigationContext)
        XCTAssertNil(context as? MultiContext)
    }

    func testRenderInitialUI() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNotNil(context)
    }

    private func renderUIAndAssert(token: String) -> BasicUIContext? {
        let context = madog.renderUI(identifier: .basic, tokenData: .single(token), in: window)
        viewTester().waitForAbsenceOfTitle(token: token) // There should be no "Back" titles
        viewTester().waitForLabel(token: token)
        return context as? BasicUIContext
    }
}

#endif
