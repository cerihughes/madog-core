//
//  PageIdentifiers.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SinglePageUI: Equatable {
    private let value: String
    internal init(_ value: String) {
        self.value = value
    }
    public static var navigationController = SinglePageUI("navigationController")
}

public struct MultiPageUI: Equatable {
    private let value: String
    internal init(_ value: String) {
        self.value = value
    }
    public static var tabBarController = MultiPageUI("tabBarController")
}
