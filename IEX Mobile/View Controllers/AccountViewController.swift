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
    @IBOutlet var environmentLabel: UILabel!
    @IBOutlet var subscriptionTermLabel: UILabel!
    @IBOutlet var usedMessagesLabel: UILabel!
    @IBOutlet var montlyLimitLabel: UILabel!
    @IBOutlet var signoutButton: UIButton!
    @IBOutlet var payAsYouGoSwitch: UISwitch!

    enum AccountCells: Int {
        case serviceStatus
        case tokens
        case environment
        case recentSearches
        case deleteTokens
    }

    var receivedAccountData = false
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        environmentLabel.text = IEXSwift.shared.environment.display
        fetchIEXStatus()
        fetchAccountMetadata()
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
                self.receivedAccountData = false
                self.tableView.reloadData()
                return
            }

            self.receivedAccountData = true
            self.serviceStatusLabel.text = status.status.capitalized
            self.serviceStatusLabel.textColor = status.status == "up" ? UIColor.IEX.green : UIColor.IEX.errorRed
            self.tableView.reloadData()
        }
    }

    private func fetchAccountMetadata() {
        IEXSwift.shared.fetchAccountMetadata { result in
            guard let metadata = result.value else { return }

            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0

            let montlyLimitAmount = formatter.string(from: NSNumber(value: metadata.messageLimit)) ?? ""
            let messagesUsed = formatter.string(from: NSNumber(value: metadata.messagesUsed)) ?? ""

            self.accountPlanLabel.text = metadata.tierName.capitalized
            self.subscriptionTermLabel.text = metadata.subscriptionTermType.capitalized
            self.montlyLimitLabel.text = "Monthly Limit: " + montlyLimitAmount
            self.usedMessagesLabel.text = "Messaged Used: " + messagesUsed
            self.payAsYouGoSwitch.isEnabled = metadata.payAsYouGoEnabled != nil
            self.payAsYouGoSwitch.isOn = metadata.payAsYouGoEnabled ?? false
        }
    }

    @IBAction func signoutButtonPressed() {
        Constants.hasAuthenticated = false
        performSegue(withIdentifier: Segues.toAuthentication, sender: nil)
    }

    @IBAction func informationBannerTapped() {
        bulletinManager.backgroundViewStyle = .blurredDark
        bulletinManager.showBulletin(above: self)
    }

    @IBAction func payAsYouGoSwitchChanged(_ sender: UISwitch) {
        IEXSwift.shared.updatePayAsYouGo(allow: sender.isOn) { result in
            guard let isSuccess = result.value else { return }
            sender.isOn = isSuccess
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toAuthentication {
            let navigationController = segue.destination as? UINavigationController
            let authenticationViewController = navigationController?.topViewController as? AuthenticationViewController
            authenticationViewController?.triggerAuthenticationOnAppear = false
        }
    }
}

extension AccountViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return IEXSwift.shared.privateToken == nil && !receivedAccountData ? 1 : 2
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        if cell.tag == AccountCells.recentSearches.rawValue {
            IEXMobileUtilities.clearRecentSearches()

        } else if cell.tag == AccountCells.deleteTokens.rawValue {
            let alert = UIAlertController(title: "Are you sure you want to delete all tokens from this device?", message: "Removing your tokens will log you out and you will have to re-enter them next time you open the app.", preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Delete and Log Out", style: .destructive) { _ in
                KeychainService.shared[Constants.privateTokenKey] = nil
                KeychainService.shared[Constants.publicTokenKey] = nil
                KeychainService.shared[Constants.testPublicTokenKey] = nil
                KeychainService.shared[Constants.testPrivateTokenKey] = nil
                Constants.hasAuthenticated = false
                self.performSegue(withIdentifier: Segues.toAuthentication, sender: nil)
            }
            let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
