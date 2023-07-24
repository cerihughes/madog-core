//
//  Created by Ceri Hughes on 19/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)
import UIKit
public typealias ViewController = UIViewController
public typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]
#elseif canImport(AppKit)
import AppKit
public typealias ViewController = NSViewController
public typealias LaunchOptions = Notification
#endif
