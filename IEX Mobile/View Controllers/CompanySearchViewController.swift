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
    let imageCache = NSCache<NSString, UIImage>()

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
    }

    private func getRecentSearches() {
        guard let data = UserDefaults.standard.value(forKey: Constants.recentSearchesKey) as? Data else { return }
        do {
            recentSearches = try PropertyListDecoder().decode([StockSymbol].self, from: data)
            tableView.reloadData()

        } catch {
            print(error)
        }
    }

    @objc private func getStocks() {
        IEXSwift.shared.fetchStockSymbols { result in
            self.stopLoading()

            guard let stocks = result.value else { return }
            self.stocks = stocks
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Apple Inc"
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    private func setupTableView() {
        let title = NSAttributedString(string: "Fetching Available Companies", attributes: [.foregroundColor : UIColor.coreBlue])
        refreshControl.addTarget(self, action: #selector(getStocks), for: .valueChanged)
        refreshControl.tintColor = .coreBlue
        refreshControl.attributedTitle = title
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
        }
    }
}

extension CompanySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return recentSearches.isEmpty ? 1 : 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return !recentSearches.isEmpty && section == 0 ? "Recent Searches" : "Available Stocks"
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return !recentSearches.isEmpty ? UITableView.automaticDimension : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !recentSearches.isEmpty, section == 0 {
            return recentSearches.count
        } else {
            return isFiltering ? filteredStocks.count : stocks.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanySearchResultCell", for: indexPath)
        let stock: StockSymbol

        if !recentSearches.isEmpty, indexPath.section == 0 {
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

        if !recentSearches.isEmpty, indexPath.section == 0 {
            selectedStock = recentSearches[indexPath.row]
            
        } else {
            selectedStock = isFiltering ? filteredStocks[indexPath.row] : stocks[indexPath.row]

            do {
                if let data = UserDefaults.standard.value(forKey: Constants.recentSearchesKey) as? Data {
                    var recentSearches = try PropertyListDecoder().decode([StockSymbol].self, from: data)
                    recentSearches.append(selectedStock)

                    UserDefaults.standard.set(try? PropertyListEncoder().encode(recentSearches), forKey: Constants.recentSearchesKey)
                }

            } catch {
                print(error)
            }
        }

        performSegue(withIdentifier: Segues.toCompanyInformation, sender: selectedStock)
    }
}

extension CompanySearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        filteredStocks = stocks.filter { $0.name.contains(text) || $0.symbol.contains(text) }

        tableView.reloadData()
    }
}
