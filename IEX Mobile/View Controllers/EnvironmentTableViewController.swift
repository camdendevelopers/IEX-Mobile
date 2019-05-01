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

        navigationController?.popViewController(animated: true)
    }
}
