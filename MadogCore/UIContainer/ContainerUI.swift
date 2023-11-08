//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

typealias AnyContainerDelegate<T> = any ContainerDelegate<T>

protocol ContainerDelegate<T>: AnyObject {
    associatedtype T

    func createUI<VC, TD>(
        identifier: ContainerUI<T>.Identifier<VC, TD>,
        tokenData: TD,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> ContainerUI<T>? where VC: ViewController, TD: TokenData

    func container(for viewController: ViewController) -> AnyContainer<T>?
    func releaseContainer(for viewController: ViewController)
}

open class ContainerUI<T>: Container {

    public struct Identifier<VC, TD> where VC: ViewController, TD: TokenData {
        let value: String

        public init(_ value: String) {
            self.value = value
        }
    }

    public private(set) var registry: AnyRegistry<T>
    public let uuid = UUID()
    let viewController: ViewController

    weak var delegate: AnyContainerDelegate<T>?

    public init(registry: AnyRegistry<T>, viewController: ViewController) {
        self.registry = registry
        self.viewController = viewController
    }

    // MARK: - Container

    public var presentingContainer: AnyContainer<T>? {
        guard let presentingViewController = viewController.presentingViewController else { return nil }
        return delegate?.container(for: presentingViewController)
    }

    public func close(animated: Bool, completion: CompletionBlock?) -> Bool {
#if canImport(UIKit)
        closeContainer(presentedViewController: viewController, animated: animated, completion: completion)
#endif
        return true
    }

    public func change<VC, TD>(
        to identifier: Identifier<VC, TD>,
        tokenData: TD,
        transition: Transition?,
        customisation: CustomisationBlock<VC>?
    ) -> AnyContainer<T>? where VC: ViewController, TD: TokenData {
        guard
            let container = delegate?.createUI(
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
