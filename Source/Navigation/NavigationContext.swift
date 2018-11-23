//
//  NavigationContext.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol NavigationContext {
    func openModal<Token>(with token: Token, from fromViewController: UIViewController, animated: Bool) -> NavigationToken?
}

public protocol ForwardNavigationContext {
    func navigate<Token>(with token: Token, from fromViewController: UIViewController, animated: Bool) -> NavigationToken?
}
