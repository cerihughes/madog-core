//
//  BaseViewControllerProvider.swift
//  MadogTests
//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

@testable import Madog

class BaseViewControllerProvider: ViewControllerProvider<String> {
	private var uuid: UUID?

	final override func register(with registry: Registry<String>) {
		super.register(with: registry)

		uuid = registry.add(registryFunction: createViewController(token:context:))
	}

	final override func unregister(from registry: Registry<String>) {
		guard let uuid = uuid else {
			return
		}

		registry.removeRegistryFunction(uuid: uuid)
	}

	func createViewController(token: String, context _: Context) -> UIViewController? {
		return nil
	}
}
