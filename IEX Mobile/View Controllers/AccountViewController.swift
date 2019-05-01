//
//  AccountViewController.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/30/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit
import BLTNBoard

class AccountViewController: UITableViewController {
    @IBOutlet var serviceStatusLabel: UILabel!
    @IBOutlet var informationHeaderView: UIView!
    @IBOutlet var accountPlanLabel: UILabel!
    @IBOutlet var subscriptionTermLabel: UILabel!
    @IBOutlet var usedMessagesLabel: UILabel!
    @IBOutlet var montlyLimitLabel: UILabel!
    @IBOutlet var signoutButton: UIButton!

    lazy var bulletinManager: BLTNItemManager = {
        let page = TextFieldBulletinPage(title: "Enter Private Token")
        page.descriptionText = "Head over to Safari and log in to your IEX Cloud account to copy your private token."
        page.actionButtonTitle = "Save Token"
        page.textInputHandler = { page, token in
            IEXSwift.shared.privateToken = token
            KeychainService.shared[Constants.privateTokenKey] = token
            page.manager?.dismissBulletin()
            self.tableView.tableHeaderView = nil
            self.tableView.reloadData()
        }

        return BLTNItemManager(rootItem: page)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView()
        setupButtons()
        fetchIEXStatus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func setupHeaderView() {
        if IEXSwift.shared.privateToken != nil {
            tableView.tableHeaderView = nil
        }
    }

    private func setupButtons() {
        signoutButton.layer.cornerRadius = Styles.actionButtonCornerRadius
    }

    private func fetchIEXStatus() {
        IEXSwift.shared.fetchStatus { result in
            guard let status = result.value else {
                self.serviceStatusLabel.text = "Down"
                self.serviceStatusLabel.textColor = UIColor.IEX.errorRed
                return
            }

            self.serviceStatusLabel.text = status.status.capitalized
            self.serviceStatusLabel.textColor = status.status == "up" ? UIColor.IEX.green : UIColor.IEX.errorRed
        }
    }

    @IBAction func removeTokensButtonPressed() {
        let alert = UIAlertController(title: "Are you sure you want to delete all tokens from this device?", message: "Removing your tokens will log you out and you will have to re-enter them next time you open the app.", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete and Log Out", style: .destructive) { _ in
            KeychainService.shared[Constants.privateTokenKey] = nil
            KeychainService.shared[Constants.publicTokenKey] = nil
            Constants.hasAuthenticated = false
            self.performSegue(withIdentifier: Segues.toAuthentication, sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func signoutButtonPressed() {
        Constants.hasAuthenticated = false
        performSegue(withIdentifier: Segues.toAuthentication, sender: nil)
    }

    @IBAction func clearRecentSearchesButtonPressed() {
        let emptySearches: [StockSymbol] = []
        UserDefaults.standard.set(try? PropertyListEncoder().encode(emptySearches), forKey: Constants.recentSearchesKey)
    }

    @IBAction func informationBannerTapped() {
        bulletinManager.backgroundViewStyle = .blurredDark
        bulletinManager.showBulletin(above: self)
    }

    //private func

    @IBAction func payAsYouGoSwitchChanged(_ sender: UISwitch) {
    }
}

extension AccountViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return IEXSwift.shared.privateToken == nil ? 1 : 2
    }
}

class SelectionFeedbackGenerator {

    private let anyObject: AnyObject?

    init() {

        if #available(iOS 10, *) {
            anyObject = UISelectionFeedbackGenerator()
        } else {
            anyObject = nil
        }

    }

    func prepare() {

        if #available(iOS 10, *) {
            (anyObject as! UISelectionFeedbackGenerator).prepare()
        }

    }

    func selectionChanged() {

        if #available(iOS 10, *) {
            (anyObject as! UISelectionFeedbackGenerator).selectionChanged()
        }

    }

}

/**
 * A 3D Touch success feedback generator wrapper that uses the API only when available.
 */

class SuccessFeedbackGenerator {

    private let anyObject: AnyObject?

    init() {

        if #available(iOS 10, *) {
            anyObject = UINotificationFeedbackGenerator()
        } else {
            anyObject = nil
        }

    }

    func prepare() {

        if #available(iOS 10, *) {
            (anyObject as! UINotificationFeedbackGenerator).prepare()
        }

    }

    func success() {

        if #available(iOS 10, *) {
            (anyObject as! UINotificationFeedbackGenerator).notificationOccurred(.success)
        }

    }

}

class FeedbackPageBLTNItem: BLTNPageItem {

    private let feedbackGenerator = SelectionFeedbackGenerator()

    override func actionButtonTapped(sender: UIButton) {

        // Play an haptic feedback
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()

        // Call super
        super.actionButtonTapped(sender: sender)

    }

    override func alternativeButtonTapped(sender: UIButton) {

        // Play an haptic feedback
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()

        // Call super
        super.alternativeButtonTapped(sender: sender)

    }

}

class TextFieldBulletinPage: FeedbackPageBLTNItem {

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

    @objc open func isInputValid(text: String?) -> Bool {

        if text == nil || text!.isEmpty {
            return false
        }

        return true

    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        if isInputValid(text: textField.text) {
            textInputHandler?(self, textField.text)
        } else {
            descriptionLabel!.textColor = UIColor.IEX.errorRed
            descriptionLabel!.text = "You must enter a token to continue"
            textField.backgroundColor = UIColor.IEX.errorRed.withAlphaComponent(0.3)
        }
    }
}
