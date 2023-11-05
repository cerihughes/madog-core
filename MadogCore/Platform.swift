//
//  Created by Ceri Hughes on 19/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

public typealias Window = UIWindow
public typealias ViewController = UIViewController
public typealias NavigationController = UINavigationController
public typealias View = UIView

public typealias AnimationOptions = UIView.AnimationOptions
public typealias PresentationStyle = UIModalPresentationStyle
public typealias TransitionStyle = UIModalTransitionStyle

#elseif canImport(AppKit)

public typealias LaunchOptions = Notification

public typealias Window = NSWindow
public typealias ViewController = NSViewController
public typealias View = NSView

public typealias AnimationOptions = Void

import AppKit

#endif
