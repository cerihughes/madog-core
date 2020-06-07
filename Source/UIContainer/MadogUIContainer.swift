//
//  MadogUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol MadogUIContainerDelegate: AnyObject {
    func createUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>,
                                        token: Any,
                                        isModal: Bool,
                                        customisation: CustomisationBlock<VC>?) -> MadogUIContainer?

    func createUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>,
                                        tokens: [Any],
                                        isModal: Bool,
                                        customisation: CustomisationBlock<VC>?) -> MadogUIContainer?

    func createUI<VC: UIViewController>(identifier: SplitSingleUIIdentifier<VC>,
                                        primaryToken: Any,
                                        secondaryToken: Any,
                                        isModal: Bool,
                                        customisation: CustomisationBlock<VC>?) -> MadogUIContainer?

    func createUI<VC: UIViewController>(identifier: SplitMultiUIIdentifier<VC>,
                                        primaryToken: Any,
                                        secondaryTokens: [Any],
                                        isModal: Bool,
                                        customisation: CustomisationBlock<VC>?) -> MadogUIContainer?

    func releaseContext(for viewController: UIViewController)
}

open class MadogUIContainer: Context {
    internal weak var delegate: MadogUIContainerDelegate?
    internal let viewController: UIViewController

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Context

    public func close(animated: Bool, completion: (() -> Void)?) -> Bool {
        // OVERRIDE
        false
    }

    public func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>,
                                             token: Any,
                                             transition: Transition?,
                                             customisation: CustomisationBlock<VC>?) -> Context? {
        guard let delegate = delegate,
            let window = viewController.view.window,
            let container = delegate.createUI(identifier: identifier,
                                              token: token,
                                              isModal: false,
                                              customisation: customisation) else {
            return nil
        }

        window.setRootViewController(container.viewController, transition: transition)
        return container
    }

    public func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>,
                                             tokens: [Any],
                                             transition: Transition?,
                                             customisation: CustomisationBlock<VC>?) -> Context? {
        guard let delegate = delegate,
            let window = viewController.view.window,
            let container = delegate.createUI(identifier: identifier,
                                              tokens: tokens,
                                              isModal: false,
                                              customisation: customisation) else {
            return nil
        }

        window.setRootViewController(container.viewController, transition: transition)
        return container
    }

    public func change<VC: UIViewController>(to identifier: SplitSingleUIIdentifier<VC>,
                                             primaryToken: Any,
                                             secondaryToken: Any,
                                             transition: Transition?,
                                             customisation: CustomisationBlock<VC>?) -> Context? {
        guard let delegate = delegate,
            let window = viewController.view.window,
            let container = delegate.createUI(identifier: identifier,
                                              primaryToken: primaryToken,
                                              secondaryToken: secondaryToken,
                                              isModal: false,
                                              customisation: customisation) else {
            return nil
        }

        window.setRootViewController(container.viewController, transition: transition)
        return container
    }

    public func change<VC: UIViewController>(to identifier: SplitMultiUIIdentifier<VC>,
                                             primaryToken: Any,
                                             secondaryTokens: [Any],
                                             transition: Transition?,
                                             customisation: CustomisationBlock<VC>?) -> Context? {
        guard let delegate = delegate,
            let window = viewController.view.window,
            let container = delegate.createUI(identifier: identifier,
                                              primaryToken: primaryToken,
                                              secondaryTokens: secondaryTokens,
                                              isModal: false,
                                              customisation: customisation) else {
            return nil
        }

        window.setRootViewController(container.viewController, transition: transition)
        return container
    }
}
