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
        window.layer.speed = 100
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

    @discardableResult
    func waitForTitle(token: String) -> UIView? {
        kif.usingLabel(token.viewControllerTitle)?
            .usingWindow(window)?
            .waitForView()
    }

    func waitForAbsenceOfTitle(token: String) {
        kif.usingLabel(token.viewControllerTitle)?
            .usingWindow(window)?
            .waitForAbsenceOfView()
    }

    @discardableResult
    func waitForLabel(token: String) -> UIView? {
        kif.usingLabel(token.viewControllerLabel)?
            .usingWindow(window)?
            .waitForView()
    }

    func waitForAbsenceOfLabel(token: String) {
        kif.usingLabel(token.viewControllerLabel)?
            .usingWindow(window)?
            .waitForAbsenceOfView()
    }

    private var kif: KIFUIViewTestActor {
        viewTester()
    }

    private func inWindowPredicate(evaluatedObject: Any?, bindings: [String: Any]?) -> Bool {
        guard let view = evaluatedObject as? UIView else { return false }
        return view.window == window
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
    func usingWindow(_ window: UIWindow) -> KIFUIViewTestActor? {
        usingPredicate(NSPredicate(block: { evaluatedObject, _ -> Bool in
            (evaluatedObject as? UIView)?.window == window
        }))
    }

    @discardableResult
    func waitForTitle(token: String, in window: UIWindow) -> UIView? {
        usingLabel(token.viewControllerTitle)?.waitForView()
    }

    func waitForAbsenceOfTitle(token: String, in window: UIWindow) {
        usingLabel(token.viewControllerTitle)?.waitForAbsenceOfView()
    }

    @discardableResult
    func waitForLabel(token: String, in window: UIWindow) -> UIView? {
        usingLabel(token.viewControllerLabel)?.waitForView()
    }

    func waitForAbsenceOfLabel(token: String, in window: UIWindow) {
        usingLabel(token.viewControllerLabel)?.waitForAbsenceOfView()
    }
}

#endif
