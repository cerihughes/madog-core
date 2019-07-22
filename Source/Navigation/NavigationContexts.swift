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
}

public protocol Context: class {
    func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>, token: Any, transition: Transition?) -> Bool
    func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>, tokens: [Any], transition: Transition?) -> Bool
}

public extension Context {
    func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>, token: Any) -> Bool {
        return change(to: identifier, token: token, transition: nil)
    }

    func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>, tokens: [Any]) -> Bool {
        return change(to: identifier, tokens: tokens, transition: nil)
    }
}

public protocol ModalContext: class {
    func openModal(token: Any, from fromViewController: UIViewController, animated: Bool) -> NavigationToken?
}

public protocol ForwardBackNavigationContext: class {
    func navigateForward(token: Any, animated: Bool) -> NavigationToken?
    func navigateBack(animated: Bool) -> Bool
    func navigateBackToRoot(animated: Bool) -> Bool
}
