//
//  CurrenciesTableViewController.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/18/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit

enum CurrencySelection {
    case from
    case to
}
protocol CurrenciesTableViewDelegate: class {
    func selected(_ currency: Currency, selection: CurrencySelection)
}

class CurrenciesTableViewController: UITableViewController {
    var currencies: [Currency] = []
    var filteredCurrencies: [Currency] = []
    var selectedCurrency: Currency?
    var selection: CurrencySelection = .from
    weak var delegate: CurrenciesTableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
    }

    func setupTableView() {
        tableView.register(UINib(nibName: "CurrencyTableCell", bundle: .main), forCellReuseIdentifier: "CurrencyCell")
    }

    func setupSearchController() {
        definesPresentationContext = true
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    var isFiltering: Bool {
        let searchController = navigationItem.searchController
        let searchBar = searchController?.searchBar

        let isActive = searchController?.isActive ?? false
        let isEmpty = (searchBar?.text ?? "").isEmpty

        return isActive && !isEmpty
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredCurrencies.count : currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyTableCell
        let currency: Currency

        if isFiltering {
            currency = filteredCurrencies[indexPath.row]
        } else {
            currency = currencies[indexPath.row]
        }

        cell.name = currency.name
        cell.code = currency.code
        cell.accessoryType = selectedCurrency == currency ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let currency: Currency

        if isFiltering {
            currency = filteredCurrencies[indexPath.row]
        } else {
            currency = currencies[indexPath.row]
        }

        delegate?.selected(currency, selection: selection)
        navigationController?.popViewController(animated: true)
    }
}

extension CurrenciesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""

        guard !searchText.isEmpty else { return }

        filteredCurrencies = currencies.filter { $0.name.lowercased().contains(searchText.lowercased()) || $0.code.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}
