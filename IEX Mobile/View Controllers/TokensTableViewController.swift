//
//  TokensTableViewController.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/1/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit

class TokensTableViewController: UITableViewController {
    @IBOutlet var livePublicTokenTextField: UITextField!
    @IBOutlet var livePrivateTokenTextField: UITextField!
    @IBOutlet var testingPublicTokenTextField: UITextField!
    @IBOutlet var testingPrivateTokenTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextFields()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveTextFields()
    }

    private func setupTextFields() {
        livePublicTokenTextField.text = KeychainService.shared[Constants.publicTokenKey]
        livePrivateTokenTextField.text = KeychainService.shared[Constants.privateTokenKey]
        testingPublicTokenTextField.text = KeychainService.shared[Constants.testPublicTokenKey]
        testingPrivateTokenTextField.text = KeychainService.shared[Constants.testPrivateTokenKey]
    }

    private func saveTextFields() {
        let publicToken = livePublicTokenTextField.text ?? ""
        let privateToken = livePrivateTokenTextField.text ?? ""
        let testPublicToken = testingPublicTokenTextField.text ?? ""
        let testPrivateToken = testingPublicTokenTextField.text ?? ""

        KeychainService.shared[Constants.publicTokenKey] = publicToken
        IEXSwift.shared.publicToken = publicToken

        let finalPrivateToken = privateToken.isEmpty ? nil : privateToken
        KeychainService.shared[Constants.privateTokenKey] = finalPrivateToken
        IEXSwift.shared.privateToken = finalPrivateToken

        let finalTestPublicToken = testPublicToken.isEmpty ? nil : testPublicToken
        KeychainService.shared[Constants.testPublicTokenKey] = finalTestPublicToken
        IEXSwift.shared.testPublicToken = finalTestPublicToken

        let finalTestPrivateToken = testPrivateToken.isEmpty ? nil : testPrivateToken
        KeychainService.shared[Constants.testPrivateTokenKey] = finalTestPrivateToken
        IEXSwift.shared.testPrivateToken = finalTestPrivateToken
    }
}
