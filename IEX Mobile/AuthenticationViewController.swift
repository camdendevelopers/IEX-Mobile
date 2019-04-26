//
//  AuthenticationViewController.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/25/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import LocalAuthentication
import UIKit
import SafariServices

class AuthenticationViewController: UIViewController {
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLabel()
    }

    private func setupContent() {
        guard Constants.hasEnrolledInBiometrics && Constants.hasTokens else {
            existingUserContentStackView.isHidden = true
            return
        }
        existingUserContentStackView.isHidden = false

        authenticateAndNavigateToApp()
    }

    private func setupLabel() {
        titleLabel.text = Constants.hasEnrolledInBiometrics && Constants.hasTokens ? "Welcome Back" : "Let's Get Started"
    }

    private func setupButtons() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        closeButton.isHidden = !Constants.hasTokens
        authenticateButton.layer.cornerRadius = Styles.actionButtonCornerRadius
        confirmationButton.layer.cornerRadius = Styles.actionButtonCornerRadius
    }

    private func setupTextFields() {
        publicTokenTextField.delegate = self
        privateTokenTextField.delegate = self
    }

    @IBAction func closeButtonPressed() {
        dismiss(animated: true)
    }

    @IBAction func createAccountButtonPressed() {
        guard let url = URL(string: Constants.IEXRegisterURL) else { return }
        present(SFSafariViewController(url: url), animated: true, completion: nil)
    }

    @IBAction func confirmationButtonPressed() {
        let publicToken = publicTokenTextField.text ?? ""
        let privateToken = privateTokenTextField.text ?? ""

        // Make sure that at least one of the tokens is not empty before continuing
        guard !publicToken.isEmpty || !privateToken.isEmpty else {
            let alert = UIAlertController(title: "Missing Information", message: "You need to enter at least one of the tokens in order to continue.", preferredStyle: .alert)
            let action = UIAlertAction(title: "I understand", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }

        // Display alert controller asking for member approval to use biometrics
        let context = LAContext()
        var authError: NSError?
        let localizedError = "Local authentication to securely save IEX tokens"
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) else {
            let alert = UIAlertController(title: "Authentication Error", message: "Something went wrong when try to authenticate. Please try again later", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: localizedError) { success, evaluateError in
            guard success else {
                let alert = UIAlertController(title: "Authentication Error", message: "Something went wrong when try to authenticate. Please try again later", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }

            if !publicToken.isEmpty {
                KeychainService.shared[Constants.publicTokenKey] = publicToken
            }

            if !privateToken.isEmpty {
                KeychainService.shared[Constants.privateTokenKey] = privateToken
            }

            Constants.hasAuthenticated = true
            Constants.hasEnrolledInBiometrics = true

            self.dismiss(animated: true)
        }
    }

    @IBAction func authenticateButtonPressed() {
        authenticateAndNavigateToApp()
    }

    private func authenticateAndNavigateToApp() {
        let context = LAContext()
        let localizedError = "Local authentication to securely use your IEX tokens"

        var authError: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) else {
            let alert = UIAlertController(title: "Authentication Error", message: "Could not authenticate due to biometric system failure. Try again later.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)

            present(alert, animated: true, completion: nil)
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: localizedError) { success, evaluateError in
            guard success else {
                let alert = UIAlertController(title: "Authentication Error", message: "Something went wrong when try to authenticate. Please try again later", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }

            Constants.hasAuthenticated = true
            self.dismiss(animated: true)
        }
    }
}

extension AuthenticationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let hasAtleastOneToken = !privateTokenTextField.isEmpty || !publicTokenTextField.isEmpty

        if confirmationButton.isHidden && hasAtleastOneToken {
            confirmationButton.alpha = 0
            UIView.animate(withDuration: 0.45) {
                self.confirmationButton.alpha = 1
                self.confirmationButton.isHidden.toggle()
                self.existingUserContentStackView.isHidden = true
            }
        } else if !confirmationButton.isHidden && !hasAtleastOneToken {
            confirmationButton.alpha = 1
            UIView.animate(withDuration: 0.45) {
                self.confirmationButton.alpha = 0
                self.confirmationButton.isHidden.toggle()
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
