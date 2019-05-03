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
    @IBOutlet var contentStackView: UIStackView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authenticateButton: UIButton!
    @IBOutlet var publicTokenTextField: UITextField!
    @IBOutlet var privateTokenTextField: UITextField!
    @IBOutlet var confirmationButton: UIButton!
    @IBOutlet var existingUserContentStackView: UIStackView!

    // This flag is only used whenever you
    // you log out and don't want to trigger authentication
    // on appearance.
    var triggerAuthenticationOnAppear: Bool = true

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

        contentStackView.setCustomSpacing(20, after: logoImageView)

        if triggerAuthenticationOnAppear {
            authenticateAndNavigateToApp()
        }
    }

    private func setupLabel() {
        titleLabel.text = Constants.hasEnrolledInBiometrics && Constants.hasTokens ? "Welcome Back" : "Let's Get Started"
    }

    private func setupButtons() {
        authenticateButton.layer.cornerRadius = Styles.actionButtonCornerRadius
        confirmationButton.layer.cornerRadius = Styles.actionButtonCornerRadius
    }

    private func setupTextFields() {
        publicTokenTextField.delegate = self
        privateTokenTextField.delegate = self
    }

    @IBAction func createAccountButtonPressed() {
        guard let url = URL(string: Constants.IEXRegisterURL) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func confirmationButtonPressed() {
        let publicToken = publicTokenTextField.text ?? ""
        let privateToken = privateTokenTextField.text ?? ""

        // Make sure that at least one of the tokens is not empty before continuing
        guard !publicToken.isEmpty || !privateToken.isEmpty else {
            let alert = UIAlertController(title: "Missing Information", message: "You need to enter at least one of the tokens in order to continue.", preferredStyle: .alert)
            let action = UIAlertAction(title: "I understand", style: .default, handler: nil)
            alert.addAction(action)

            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
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
                IEXSwift.shared.publicToken = publicToken
            }

            if !privateToken.isEmpty {
                KeychainService.shared[Constants.privateTokenKey] = privateToken
                IEXSwift.shared.privateToken = privateToken
            }

            Constants.hasAuthenticated = true
            Constants.hasEnrolledInBiometrics = true

            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.toApplication, sender: nil)
            }
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
            IEXSwift.shared.publicToken = KeychainService.shared[Constants.publicTokenKey] ?? ""
            IEXSwift.shared.privateToken = KeychainService.shared[Constants.privateTokenKey]
            IEXSwift.shared.testPrivateToken = KeychainService.shared[Constants.testPrivateTokenKey]
            IEXSwift.shared.testPublicToken = KeychainService.shared[Constants.testPublicTokenKey]

            if let environmentValue = UserDefaults.standard.string(forKey: Constants.environmentKey), let environment = IEXEnvironment(rawValue: environmentValue) {
                IEXSwift.shared.environment = environment
            }

            DispatchQueue.main.sync {
                self.performSegue(withIdentifier: Segues.toApplication, sender: nil)
            }
        }
    }

    @IBAction func attributionButtonPressed() {
        guard let url = URL(string: "https://iexcloud.io") else { return }
        present(SFSafariViewController(url: url), animated: true, completion: nil)
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
