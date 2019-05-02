//
//  EnvironmentTableViewController.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/1/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit

class EnvironmentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IEXEnvironment.allCases.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnvironmentCell", for: indexPath)
        let environment = IEXEnvironment.allCases[indexPath.row]

        cell.textLabel?.text = environment.display
        cell.accessoryType = environment == IEXSwift.shared.environment ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let environment = IEXEnvironment.allCases[indexPath.row]

        IEXSwift.shared.environment = environment

        if environment == .testing && (IEXSwift.shared.testPublicToken == nil || IEXSwift.shared.testPrivateToken == nil) {
            let alert = UIAlertController(title: "Warning on Selection", message: "You have selected to use the testing environment, but you have not entered testing tokens. Please head over to Add/Modify tokens and update your testing tokens there. You will not be able to make any service calls if these are not entered.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Got it", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(okayAction)
            present(alert, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
