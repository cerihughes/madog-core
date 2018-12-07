//
//  MadogUIContext.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

protocol MadogUIContextDelegate: class {
    func renderSinglePageUI<Token>(_ uiIdentifier: SinglePageUIIdentifier, with token: Token, in window: UIWindow) -> Bool
    func renderMultiPageUI<Token>(_ uiIdentifier: MultiPageUIIdentifier, with tokens: [Token], in window: UIWindow) -> Bool
}

protocol MadogUIContext {
    var delegate: MadogUIContextDelegate? {get set}
    var viewController: UIViewController {get}
}
