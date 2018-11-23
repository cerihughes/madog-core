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
    private let pageIdentifier: String
    private let context: NavigationContext

    init(pageIdentifier:String, context: NavigationContext) {
        self.pageIdentifier = pageIdentifier
        self.context = context

        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = Page2View()
    }

    override func viewDidLoad() {
        guard let view = view as? Page2View else {
            return
        }

        view.label.text = pageIdentifier
    }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            _ = self.context.navigateBack(animated: true)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
