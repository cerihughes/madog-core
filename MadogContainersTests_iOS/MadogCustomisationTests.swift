//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import MadogContainers_iOS

class MadogCustomisationTests: MadogKIFTestCase {
    func testMainCustomisationBlock() {
        _ = renderUIAndWait(
            identifier: .basic(),
            tokenData: .single("vc1"),
            customisation: customise(viewController:)
        )

        waitForTitle(token: "CUSTOMISED")
    }

    func testModalCustomisationBlock() {
        let context = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))

        waitForAbsenceOfTitle(token: "CUSTOMISED")
        _ = context?.openModal(
            identifier: .basic(),
            tokenData: .single("vc1"),
            animated: true,
            customisation: customise(viewController:)
        )

        waitForTitle(token: "CUSTOMISED")
    }

    private func customise(viewController: UIViewController) {
        let label = UILabel()
        label.text = "CUSTOMISED"
        viewController.view.addSubview(label)
    }
}

#endif
