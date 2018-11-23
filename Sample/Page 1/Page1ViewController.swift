//
//  Page1ViewController.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

class Page1ViewController: UIViewController {
    private let context: NavigationUIContext

    init(context: NavigationUIContext) {
        self.context = context

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        let token = ResourceLocator.createPage2ResourceLocator(pageIdentifier: "ABC123")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            _ = self.context.navigateForward(with: token, animated: true)
        }
    }
}
