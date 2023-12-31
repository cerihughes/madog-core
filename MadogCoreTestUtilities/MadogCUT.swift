//
//  Created by Ceri Hughes on 03/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if canImport(KIF) && canImport(UIKit)

import KIF
import MadogCore
import UIKit

public protocol MadogCUT<T>: KIFTestCase {
    associatedtype T
    var madog: Madog<T>! { get }
    var window: UIWindow! { get }
}

public extension MadogCUT {
    func renderUIAndWait<TD, VC>(
        identifier: ContainerUI<T, TD, VC>.Identifier,
        tokenData: TD,
        customisation: CustomisationBlock<VC>? = nil
    ) throws -> AnyContainer<T> where VC: ViewController, TD: TokenData {
        let result = try madog.renderUI(
            identifier: identifier,
            tokenData: tokenData,
            in: window,
            customisation: customisation
        )
        waitForAnimationsToFinish()
        return result
    }

    func closeContainerAndWait(_ container: AnyContainer<T>, completion: CompletionBlock? = nil) throws {
        try container.close(animated: true, completion: completion)
        waitForAnimationsToFinish()
    }

    func openModalAndWait<TD2, VC>(
        _ modalContainer: AnyModalContainer<T>,
        identifier: ContainerUI<T, TD2, VC>.Identifier,
        tokenData: TD2,
        completion: CompletionBlock? = nil
    ) throws -> ModalToken<T> where VC: UIViewController, TD2: TokenData {
        let result = try modalContainer.openModal(
            identifier: identifier,
            tokenData: tokenData,
            presentationStyle: .formSheet,
            animated: true,
            completion: completion
        )
        waitForAnimationsToFinish()
        return result
    }

    func closeModalAndWait(
        _ modalContainer: AnyModalContainer<T>,
        token: ModalToken<T>,
        completion: CompletionBlock? = nil
    ) throws {
        try modalContainer.closeModal(token: token, animated: true, completion: completion)
        waitForAnimationsToFinish()
    }

    func waitForAnimationsToFinish(_ file: String = #file, _ line: Int = #line) {
        viewTester(file, line)
            .waitForAnimationsToFinish()
    }
}

public extension MadogCUT where T == String {
    @discardableResult
    func waitForTitle(token: String, _ file: String = #file, _ line: Int = #line) -> UIView? {
        viewTester(file, line)
            .usingLabel(token.viewControllerTitle)?
            .usingWindow(window)?
            .waitForView()
    }

    func waitForAbsenceOfTitle(token: String, _ file: String = #file, _ line: Int = #line) {
        viewTester(file, line)
            .usingLabel(token.viewControllerTitle)?
            .usingWindow(window)?
            .waitForAbsenceOfView()
    }

    @discardableResult
    func waitForLabel(token: String, _ file: String = #file, _ line: Int = #line) -> UIView? {
        viewTester(file, line)
            .usingLabel(token.viewControllerLabel)?
            .usingWindow(window)?
            .waitForView()
    }

    func waitForAbsenceOfLabel(token: String, _ file: String = #file, _ line: Int = #line) {
        viewTester(file, line)
            .usingLabel(token.viewControllerLabel)?
            .usingWindow(window)?
            .waitForAbsenceOfView()
    }

    private func inWindowPredicate(evaluatedObject: Any?, bindings: [String: Any]?) -> Bool {
        guard let view = evaluatedObject as? UIView else { return false }
        return view.window == window
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

extension String {
    var viewControllerTitle: String {
        self
    }

    var viewControllerLabel: String {
        "Label: \(self)"
    }
}

#endif
