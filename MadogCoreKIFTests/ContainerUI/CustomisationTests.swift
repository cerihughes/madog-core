//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import MadogCoreTestUtilities
import XCTest

@testable import MadogCore

class CustomisationTests: MadogKIFTestCase {
    func testMainCustomisationBlock() {
        let container = renderUIAndWait(
            identifier: .kifTest(),
            tokenData: .single("vc1"),
            customisation: customise(viewController:)
        )

        XCTAssertNotNil(container)
        waitForTitle(token: "CUSTOMISED")
    }

    func testModalCustomisationBlock() throws {
        let container = try XCTUnwrap(renderUIAndWait(identifier: .kifTest(), tokenData: .single("vc1")))

        waitForAbsenceOfTitle(token: "CUSTOMISED")
        let token = container.modal?.openModal(
            identifier: .kifTest(),
            tokenData: .single("vc1"),
            animated: true,
            customisation: customise(viewController:)
        )

        XCTAssertNotNil(token)
        waitForTitle(token: "CUSTOMISED")
    }

    private func customise(viewController: UIViewController) {
        let label = UILabel()
        label.text = "CUSTOMISED"
        viewController.view.addSubview(label)
    }
}

#endif
