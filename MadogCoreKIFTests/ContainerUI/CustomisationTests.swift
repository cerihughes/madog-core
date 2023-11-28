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
    func testMainCustomisationBlock() throws {
        _ = try renderUIAndWait(
            identifier: .test(),
            tokenData: .single("vc1"),
            customisation: customise(viewController:)
        )

        waitForTitle(token: "CUSTOMISED")
    }

    func testModalCustomisationBlock() throws {
        let container = try renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))

        waitForAbsenceOfTitle(token: "CUSTOMISED")
        let token = try container.modal?.openModal(
            identifier: .test(),
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
