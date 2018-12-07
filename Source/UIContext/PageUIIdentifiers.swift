//
//  PageUIIdentifiers.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SinglePageUIIdentifier: Equatable {
    private let value: String
    internal init(_ value: String) {
        self.value = value
    }

    public static var navigationControllerIdentifier = SinglePageUIIdentifier("navigationControllerIdentifier")
}

public struct MultiPageUIIdentifier: Equatable {
    private let value: String
    internal init(_ value: String) {
        self.value = value
    }
    public static var tabBarControllerIdentifier = MultiPageUIIdentifier("tabBarControllerIdentifier")
}
