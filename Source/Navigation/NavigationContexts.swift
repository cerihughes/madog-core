//
//  NavigationContexts.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public struct Transition {
    public let duration: TimeInterval
    public let options: UIView.AnimationOptions

    public init(duration: TimeInterval, options: UIView.AnimationOptions) {
        self.duration = duration
        self.options = options
    }
}

public protocol Context: class {
    @discardableResult
    func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>, token: Any, transition: Transition?) -> Context?
    @discardableResult
    func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>, tokens: [Any], transition: Transition?) -> Context?
}

public extension Context {
    @discardableResult
    func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>, token: Any) -> Context? {
        return change(to: identifier, token: token, transition: nil)
    }

    @discardableResult
    func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>, tokens: [Any]) -> Context? {
        return change(to: identifier, tokens: tokens, transition: nil)
    }
}

public protocol ModalContext: class {
    @discardableResult
    func openModal(token: Any,
                   from fromViewController: UIViewController?,
                   presentationStyle: UIModalPresentationStyle?,
                   transitionStyle: UIModalTransitionStyle?,
                   animated: Bool,
                   completion: (() -> Void)?) -> NavigationToken?
}

public protocol ForwardBackNavigationContext: class {
    @discardableResult
    func navigateForward(token: Any, animated: Bool) -> NavigationToken?
    @discardableResult
    func navigateBack(animated: Bool) -> Bool
    @discardableResult
    func navigateBackToRoot(animated: Bool) -> Bool
}
