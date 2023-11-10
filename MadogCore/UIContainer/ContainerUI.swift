//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

typealias AnyContainerDelegate<T> = any ContainerDelegate<T>

protocol ContainerDelegate<T>: AnyObject {
    associatedtype T

    func createContainer<VC, TD>(
        identifier: ContainerUI<T, VC>.Identifier<TD>,
        tokenData: TD,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> ContainerUI<T, VC>? where VC: ViewController, TD: TokenData

    func container(for viewController: ViewController) -> AnyContainer<T>?
    func releaseContainer(for viewController: ViewController)
}

open class ContainerUI<T, VC>: Container where VC: ViewController {

    public struct Identifier<TD> where TD: TokenData {
        let value: String

        public init(_ value: String) {
            self.value = value
        }
    }

    public private(set) var registry: AnyRegistry<T>
    public let uuid = UUID()
    let viewController: VC

    weak var delegate: AnyContainerDelegate<T>?

    public init(registry: AnyRegistry<T>, viewController: VC) {
        self.registry = registry
        self.viewController = viewController
    }

    // MARK: - Container

    public func close(animated: Bool, completion: CompletionBlock?) -> Bool {
#if canImport(UIKit)
        closeContainer(presentedViewController: viewController, animated: animated, completion: completion)
#endif
        return true
    }

    public func change<VC2, TD>(
        to identifier: ContainerUI<T, VC2>.Identifier<TD>,
        tokenData: TD,
        transition: Transition?,
        customisation: CustomisationBlock<VC2>?
    ) -> AnyContainer<T>? where VC2: ViewController, TD: TokenData {
        guard
            let container = delegate?.createContainer(
                identifier: identifier,
                tokenData: tokenData,
                isModal: false,
                customisation: customisation
            ),
            let window = viewController.view.window
        else { return nil }

        window.setRootViewController(container.viewController, transition: transition)
        return container.proxy()
    }
}
