//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

/// Used to uniquely identify a view controller in the app.
enum SampleToken: Equatable {
    case login
    case vc1
    case vc2(String)
    case logout
}
