//
//  StateFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 24/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

public protocol StateFactory {
    static func createState() -> State
}
