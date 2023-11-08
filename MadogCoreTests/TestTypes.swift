//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import XCTest

import MadogCore

class TestResolver: Resolver {
    func viewControllerProviderFunctions() -> [() -> AnyViewControllerProvider<Int>] {
        [TestViewControllerProvider.init]
    }

    func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [TestServiceProvider.init(context:)]
    }
}

class TestViewControllerProvider: ViewControllerProvider {
    func createViewController(token: Int, context: AnyContext<Int>) -> ViewController? {
        TestViewController(context: context)
    }
}

protocol TestViewControllerDelegate: AnyObject {
    func testViewControllerDidDeallocate()
}

class TestViewController<Int>: ViewController {
    weak var context: AnyContext<Int>?

    weak var delegate: TestViewControllerDelegate?

    init(context: AnyContext<Int>) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        delegate?.testViewControllerDidDeallocate()
    }
}

class TestServiceProvider: ServiceProvider {
    var name = "TestServiceProvider"

    init(context _: ServiceProviderCreationContext) {}
}

class TestContext: Context {
    typealias T = Int

    var presentingContext: AnyContext<Int>? { nil }
    func close(animated: Bool, completion: CompletionBlock?) -> Bool { false }
    func change<VC, C, TD>(
        to identifier: MadogUIIdentifier<VC, C, TD, Int>,
        tokenData: TD,
        transition: Transition?,
        customisation: CustomisationBlock<VC>?
    ) -> C? where VC: ViewController, TD: TokenData { nil }
#if canImport(UIKit)
    func openModal<VC, C, TD>(
        identifier: MadogUIIdentifier<VC, C, TD, Int>,
        tokenData: TD,
        presentationStyle: PresentationStyle?,
        transitionStyle: TransitionStyle?,
        popoverAnchor: Any?,
        animated: Bool,
        customisation: CustomisationBlock<VC>?,
        completion: CompletionBlock?
    ) -> AnyModalToken<C>? where VC: UIViewController, TD: TokenData { nil }
    func closeModal<C>(token: AnyModalToken<C>, animated: Bool, completion: CompletionBlock?) -> Bool { false }
#endif
}
