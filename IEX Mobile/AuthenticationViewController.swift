//
//  AuthenticationViewController.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/25/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit
import SafariServices

class AuthenticationViewController: UIViewController {
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var authenticateButton: UIButton!
    @IBOutlet var publicTokenTextField: UITextField!
    @IBOutlet var privateTokenTextField: UITextField!
    @IBOutlet var confirmationButton: UIButton!
    @IBOutlet var existingUserContentStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTextFields()
    }

    private func setupButtons() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2

        authenticateButton.layer.cornerRadius = Styles.actionButtonCornerRadius
    }

    private func setupTextFields() {
        publicTokenTextField.delegate = self
        privateTokenTextField.delegate = self
    }

    @IBAction func closeButtonPressed() {
        dismiss(animated: true)
    }
    @IBAction func createAccountButtonPressed() {
        guard let url = URL(string: "https://iexcloud.io/cloud-login#/register/") else { return }
        present(SFSafariViewController(url: url), animated: true, completion: nil)
    }

    @IBAction func confirmationButtonPressed() {
    }

    @IBAction func authenticateButtonPressed() {
    }
}

extension AuthenticationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        existingUserContentStackView.isHidden = !privateTokenTextField.isEmpty || !publicTokenTextField.isEmpty

        if confirmationButton.isHidden {
            confirmationButton.alpha = 0
            UIView.animate(withDuration: 0.45) {
                self.confirmationButton.alpha = 1
                self.confirmationButton.isHidden = !self.existingUserContentStackView.isHidden
            }
        } else {
            confirmationButton.alpha = 1
            UIView.animate(withDuration: 0.45) {
                self.confirmationButton.alpha = 0
                self.confirmationButton.isHidden = !self.existingUserContentStackView.isHidden
            }
        }
        
        if textField == publicTokenTextField {
            privateTokenTextField.becomeFirstResponder()
        }

        if textField == privateTokenTextField {
            privateTokenTextField.resignFirstResponder()
        }

        return true
    }
}
