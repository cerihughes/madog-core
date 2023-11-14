//
//  Created by Ceri Hughes on 13/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnyContainerUIFactory<T, TD, VC> = any ContainerUIFactory<T, TD, VC>

public protocol ContainerUIFactory<T, TD, VC> where TD: TokenData, VC: ViewController {
    associatedtype T
    associatedtype TD
    associatedtype VC

    func createContainer() -> ContainerUI<T, TD, VC>
}
