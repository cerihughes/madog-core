//
//  Created by Ceri Hughes on 15/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

typealias AnyContainerCreationDelegate<T> = any ContainerCreationDelegate<T>

protocol ContainerCreationDelegate<T>: AnyObject {
    associatedtype T

    func createContainer<VC, TD>(
        identifiableToken: IdentifiableToken<T, TD, VC>,
        parent: AnyInternalContainer<T>?,
        customisation: CustomisationBlock<VC>?
    ) -> ContainerUI<T, TD, VC>? where VC: ViewController, TD: TokenData
}

typealias AnyContainerReleaseDelegate<T> = any ContainerReleaseDelegate<T>

protocol ContainerReleaseDelegate<T>: AnyObject {
    associatedtype T

    func releaseContainer(_ container: AnyContainer<T>)
}
