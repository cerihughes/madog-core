//
//  State2.swift
//  Madog
//
//  Created by Ceri Hughes on 24/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation
import Madog

let state2Name = "state2Name"

class State2: StateFactory, State {

    // MARK: StateFactory

    static func createState() -> State {
        return State2()
    }

    // MARK: State

    let name = state2Name

    let somethingElseShared = "This is also shared state"
}
