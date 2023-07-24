//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

extension KIFTestCase {
    func viewTester(_ file: String = #file, _ line: Int = #line) -> KIFUIViewTestActor {
        KIFUIViewTestActor(inFile: file, atLine: line, delegate: self)
    }

    func system(_ file: String = #file, _ line: Int = #line) -> KIFSystemTestActor {
        KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
}

#endif
