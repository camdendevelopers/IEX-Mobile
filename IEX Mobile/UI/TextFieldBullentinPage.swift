//
//  TextFieldBullentinPage.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/2/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation
import UIKit
import BLTNBoard

class TextFieldBulletinPage: FeedbackPageBulletinItem {
    @objc public var textField: UITextField!

    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil

    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textField = interfaceBuilder.makeTextField(placeholder: "Private Token", returnKey: .done, delegate: self)
        return [textField]
    }

    override func tearDown() {
        super.tearDown()
        textField?.delegate = nil
    }

    override func actionButtonTapped(sender: UIButton) {
        textField.resignFirstResponder()
        super.actionButtonTapped(sender: sender)
    }
}

// MARK: - UITextFieldDelegate
extension TextFieldBulletinPage: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            textInputHandler?(self, textField.text)
        } else {
            descriptionLabel!.textColor = UIColor.IEX.errorRed
            descriptionLabel!.text = "You must enter a token to continue"
            textField.backgroundColor = UIColor.IEX.errorRed.withAlphaComponent(0.3)
        }
    }
}
