//
//  MadogBaseContainer.swift
//  MadogCore
//
//  Created by Ceri Hughes on 05/11/2023.
//

import UIKit

open class MadogBaseContainer<T> {
    public private(set) var registry: AnyRegistry<T>
    let viewController: ViewController

    weak var delegate: AnyMadogUIContainerDelegate<T>?

    public init(registry: AnyRegistry<T>, viewController: ViewController) {
        self.registry = registry
        self.viewController = viewController
    }
}
