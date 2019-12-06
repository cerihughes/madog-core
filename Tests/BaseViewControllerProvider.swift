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
	static var latestUUID: UUID?
	private var uuid: UUID? {
		didSet {
			BaseViewControllerProvider.latestUUID = uuid
		}
	}

	final override func register(with registry: Registry<String>) {
		super.register(with: registry)

		uuid = registry.add(registryFunction: createViewController(token:context:))
	}

	final override func unregister(from registry: Registry<String>) {
		super.unregister(from: registry)

		guard let uuid = uuid else {
			return
		}

		registry.removeRegistryFunction(uuid: uuid)

		self.uuid = nil
	}

	func createViewController(token: String, context _: Context) -> UIViewController? {
		return nil
	}
}
