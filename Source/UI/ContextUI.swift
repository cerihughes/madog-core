//
//  ContextUI.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

protocol ContextUIDelegate: class {
    func renderSinglePageUI<Token>(_ uiIdentifier: SinglePageUIIdentifier, with token: Token, in window: UIWindow) -> Bool
    func renderMultiPageUI<Token>(_ uiIdentifier: MultiPageUIIdentifier, with tokens: [Token], in window: UIWindow) -> Bool
}

class ContextUI {
    weak var delegate: ContextUIDelegate?
}

class SinglePageContextUI: ContextUI, SinglePageContext {
    func renderInitialView<Token>(with token: Token) -> Bool {
        return false
    }
}

class MultiPageContextUI: ContextUI, MultiPageContext {
    func renderInitialViews<Token>(with tokens: [Token]) -> Bool {
        return false
    }
}
