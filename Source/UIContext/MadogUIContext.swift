//
//  MadogUIContext.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol MadogUIContextDelegate: class {
    func renderSinglePageUI<VC: UIViewController>(_ uiIdentifier: SinglePageUIIdentifier<VC>, with token: Any, in window: UIWindow) -> Bool
    func renderMultiPageUI<VC: UIViewController>(_ uiIdentifier: MultiPageUIIdentifier<VC>, with tokens: [Any], in window: UIWindow) -> Bool
}

internal class MadogUIContext {
    internal weak var delegate: MadogUIContextDelegate?
    internal var viewController: UIViewController

    internal init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

internal class MadogSinglePageUIContext: MadogUIContext {
    internal func renderInitialView(with token: Any) -> Bool {
        return false
    }
}

internal class MadogMultiPageUIContext: MadogUIContext {
    internal func renderInitialViews(with tokens: [Any]) -> Bool {
        return false
    }
}
