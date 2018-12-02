//
//  Page2ViewController.swift
//  MadogSample
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

class Page2ViewController: UIViewController {
    private let state1: State1
    private let pageData: String
    private let navigationContext: ForwardBackNavigationContext

    init(state1: State1, pageData:String, navigationContext: ForwardBackNavigationContext) {
        self.state1 = state1
        self.pageData = pageData
        self.navigationContext = navigationContext

        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = LabelView()
    }

    override func viewDidLoad() {
        guard let view = view as? LabelView else {
            return
        }

        view.label.text = pageData

        // Maybe do something with the state at this point?
    }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            _ = self.navigationContext.navigateBack(animated: true)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
