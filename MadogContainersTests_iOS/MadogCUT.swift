//
//  Created by Ceri Hughes on 03/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import KIF
import MadogCore

protocol MadogCUT<T>: KIFTestCase {
    associatedtype T
    var madog: Madog<T>! { get }
    var window: UIWindow! { get }
}

extension MadogCUT {
    @discardableResult
    func closeContextAndWait(_ context: AnyContext<T>, completion: CompletionBlock? = nil) -> Bool {
        let result = context.close(animated: true, completion: completion)
        waitForAnimationsToFinish()
        return result
    }

    func openModalAndWait<VC, C, TD>(
        _ modalContext: AnyModalContext<T>,
        identifier: MadogUIIdentifier<VC, C, TD, T>,
        tokenData: TD,
        completion: CompletionBlock? = nil
    ) -> AnyModalToken<C>? where VC: UIViewController, TD: TokenData {
        let result = modalContext.openModal(
            identifier: identifier,
            tokenData: tokenData,
            presentationStyle: .formSheet,
            animated: true,
            completion: completion
        )
        waitForAnimationsToFinish()
        return result
    }

    @discardableResult
    func closeModalAndWait<C>(
        _ modalContext: AnyModalContext<T>,
        token: AnyModalToken<C>,
        completion: CompletionBlock? = nil
    ) -> Bool {
        let result = modalContext.closeModal(token: token, animated: true, completion: completion)
        waitForAnimationsToFinish()
        return result
    }

    private func waitForAnimationsToFinish(_ file: String = #file, _ line: Int = #line) {
        viewTester(file, line)
            .waitForAnimationsToFinish()
    }
}

extension MadogCUT where T == String {
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
