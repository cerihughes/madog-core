//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public struct MadogUIIdentifier<VC, C, TD, T> where VC: ViewController, TD: TokenData {
    let value: String

    public init(_ value: String) {
        self.value = value
    }
}
