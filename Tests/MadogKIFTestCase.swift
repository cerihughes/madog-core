//
//  MadogKIFTestCase.swift
//  MadogTests
//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import Madog

class MadogKIFTestCase: KIFTestCase {
    var window: UIWindow!
    var madog: Madog<String>!

    override func beforeEach() {
        super.beforeEach()

        window = UIWindow()
        window.makeKeyAndVisible()
        madog = Madog()
        madog.resolve(resolver: TestResolver())
    }

    override func afterEach() {
        window.rootViewController = nil
        window = nil
        madog = nil

        super.afterEach()
    }
}

private class TestResolver: Resolver<String> {
    override func viewControllerProviderFunctions() -> [() -> ViewControllerProvider<String>] {
        [TestViewControllerProvider.init]
    }
}

private class TestViewControllerProvider: BaseViewControllerProvider {
    override func createViewController(token: String, context: Context) -> UIViewController? {
        let viewController = TestViewController()
        viewController.title = token.viewControllerTitle
        viewController.label.text = token.viewControllerLabel
        return viewController
    }
}

private extension String {
    var viewControllerTitle: String {
        self
    }

    var viewControllerLabel: String {
        "Label: \(self)"
    }
}

private class TestViewController: UIViewController {
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        label.textColor = .darkGray

        view.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension KIFUIViewTestActor {
    @discardableResult
    func waitForTitle(token: String) -> UIView? {
        usingLabel(token.viewControllerTitle)?.waitForView()
    }

    func waitForAbsenceOfTitle(token: String) {
        usingLabel(token.viewControllerTitle)?.waitForAbsenceOfView()
    }

    @discardableResult
    func waitForLabel(token: String) -> UIView? {
        usingLabel(token.viewControllerLabel)?.waitForView()
    }

    func waitForAbsenceOfLabel(token: String) {
        usingLabel(token.viewControllerLabel)?.waitForAbsenceOfView()
    }
}

#endif
