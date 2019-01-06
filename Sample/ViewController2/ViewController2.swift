//
//  ViewController2.swift
//  MadogSample
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

class ViewController2: UIViewController {
    private let sharedResource: Any
    private let stringData: String
    private weak var navigationContext: ForwardBackNavigationContext?

    init(sharedResource: Any, stringData: String, navigationContext: ForwardBackNavigationContext) {
        self.sharedResource = sharedResource
        self.stringData = stringData
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

        view.label.text = stringData

        // Maybe do something with the shared resource at this point?
    }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            _ = self.navigationContext?.navigateBack(animated: true)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
