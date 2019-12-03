//
//  ButtonView.swift
//  MadogSample
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

class ButtonView: UIView {
	let button = UIButton(type: .system)

	override init(frame: CGRect) {
		super.init(frame: frame)

		backgroundColor = .white

		button.translatesAutoresizingMaskIntoConstraints = false
		addSubview(button)

		var constraints = [NSLayoutConstraint]()

		constraints.append(button.centerXAnchor.constraint(equalTo: centerXAnchor))
		constraints.append(button.centerYAnchor.constraint(equalTo: centerYAnchor))
		constraints.append(button.widthAnchor.constraint(equalToConstant: 64.0))
		constraints.append(button.heightAnchor.constraint(equalTo: button.widthAnchor))

		NSLayoutConstraint.activate(constraints)
	}

	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
