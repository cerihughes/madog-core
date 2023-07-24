//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import XCTest

extension XCTestCase {
    var userInterfaceIdiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    var isRunningOnIphone: Bool { userInterfaceIdiom == .phone }
    var isRunningOnIpad: Bool { userInterfaceIdiom == .pad }
}
