//
//  ViewController.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/25/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit

class CompanySearchViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    private let refreshControl = UIRefreshControl()

    var recentSearches: [StockSymbol] = []
    var stocks: [StockSymbol] = []
    var filteredStocks: [StockSymbol] = []
    var environment: IEXEnvironment = IEXSwift.shared.environment

    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        setupSearchController()
        setupTableView()
        getStocks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecentSearches()

        if IEXSwift.shared.environment != environment {
            startLoading()
            getStocks()
        }

        environment = IEXSwift.shared.environment
    }

    private func getRecentSearches() {
        guard let data = UserDefaults.standard.value(forKey: Constants.recentSearchesKey) as? Data else {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(recentSearches), forKey: Constants.recentSearchesKey)
            return
        }

        guard let searches = try? PropertyListDecoder().decode([StockSymbol].self, from: data) else { return }
        recentSearches = searches
        tableView.reloadSections([0], with: .fade)
    }

    @objc private func getStocks() {
        IEXSwift.shared.fetchStockSymbols { result in
            self.stopLoading()

            guard let stocks = result.value else { return }
            self.stocks = stocks
            self.tableView.reloadSections([1], with: .fade)
            self.refreshControl.endRefreshing()
        }
    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Apple, Inc."
        searchController.searchBar.showsScopeBar = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupTableView() {
        refreshControl.addTarget(self, action: #selector(getStocks), for: .valueChanged)
        refreshControl.tintColor = UIColor.IEX.main
        tableView.addSubview(refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
    }

    var isFiltering: Bool {
        let searchController = navigationItem.searchController
        let text = searchController?.searchBar.text ?? ""
        return !text.isEmpty
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toCompanyInformation {
            guard let stockSymbol = sender as? StockSymbol else { return }
            let companyInformationViewController = segue.destination as? CompanyInformationViewController
            companyInformationViewController?.companyTicker = stockSymbol.symbol
            companyInformationViewController?.title = stockSymbol.symbol
        }
    }
}

extension CompanySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Recent Searches" : "Available Companies"
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return recentSearches.isEmpty ? 0 : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = UIColor.IEX.main
        header?.textLabel?.font = .preferredFont(forTextStyle: .headline)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return recentSearches.count
        } else {
            return isFiltering ? filteredStocks.count : stocks.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanySearchResultCell", for: indexPath)
        let stock: StockSymbol

        if indexPath.section == 0 {
            stock = recentSearches[indexPath.row]
        } else {
            stock = isFiltering ? filteredStocks[indexPath.row] : stocks[indexPath.row]
        }

        cell.textLabel?.text = stock.name
        cell.detailTextLabel?.text = stock.symbol

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedStock: StockSymbol

        if indexPath.section == 0 {
            selectedStock = recentSearches[indexPath.row]
            
        } else {
            selectedStock = isFiltering ? filteredStocks[indexPath.row] : stocks[indexPath.row]

            if let data = UserDefaults.standard.value(forKey: Constants.recentSearchesKey) as? Data {
                if var recentSearches = try? PropertyListDecoder().decode([StockSymbol].self, from: data), !recentSearches.contains(selectedStock) {
                    recentSearches.append(selectedStock)
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(recentSearches), forKey: Constants.recentSearchesKey)
                }
            }
        }

        performSegue(withIdentifier: Segues.toCompanyInformation, sender: selectedStock)
    }
}

extension CompanySearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }



        DispatchQueue.global(qos: .background).async {
            self.filteredStocks = self.stocks.filter { $0.name.contains(text) || $0.symbol.contains(text) }

            DispatchQueue.main.async {
                self.tableView.reloadSections([1], with: .fade)
            }
        }
    }
}
