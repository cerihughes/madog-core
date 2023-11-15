//
//  Created by Ceri Hughes on 15/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

protocol ContainerCreationDelegate<T>: AnyObject {
    associatedtype T

    func createContainer<VC, TD>(
        identifiableToken: IdentifiableToken<T, TD, VC>,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> ContainerUI<T, TD, VC>? where VC: ViewController, TD: TokenData
}
