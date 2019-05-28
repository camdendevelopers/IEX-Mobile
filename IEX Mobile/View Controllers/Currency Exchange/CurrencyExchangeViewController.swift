//
//  CurrencyExchangeViewController.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/18/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit
import SafariServices

class CurrencyExchangeViewController: UIViewController {
    @IBOutlet var fromCurrencyImageView: UIImageView!
    @IBOutlet var fromCurrencyTextField: NumberTextField!
    @IBOutlet var toCurrencyImageView: UIImageView!
    @IBOutlet var toCurrencyTextField: NumberTextField!

    var currencies: [Currency] = []
    var fromCurrency = Currency(code: "USD", name: "U.S. Dollar")
    var toCurrency = Currency(code: "EUR", name: "Euro")
    var rate: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        setupImageViews()
        fetchCurrencies()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fromCurrencyTextField.becomeFirstResponder()
    }

    func setupTextFields() {
        fromCurrencyTextField.setAmount(1)
        fromCurrencyTextField.inputAccessoryView = createToolbar()
        fromCurrencyTextField.numberDelegate = self
        
        toCurrencyTextField.inputAccessoryView = createToolbar()
        toCurrencyTextField.numberDelegate = self
    }

    func setupImageViews() {
        fromCurrencyImageView.accessibilityIgnoresInvertColors = true
        fromCurrencyImageView.layer.cornerRadius = 4
        fromCurrencyImageView.layer.masksToBounds = true
        fromCurrencyImageView.clipsToBounds = true
        fromCurrencyImageView.layoutIfNeeded()
        fromCurrencyImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fromCurrencyImageViewPressed)))

        fromCurrencyImageView.accessibilityIgnoresInvertColors = true
        fromCurrencyImageView.layer.cornerRadius = 4
        toCurrencyImageView.layer.masksToBounds = true
        toCurrencyImageView.clipsToBounds = true
        toCurrencyImageView.layoutIfNeeded()
        toCurrencyImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toCurrencyImageViewPressed)))
    }

    func fetchCurrencies() {
        startLoading()
        IEXSwift.shared.fetchCurrencies { result in
            self.stopLoading()

            guard let currencies = result.value else {
                let alert = UIAlertController(title: "IEX Service Error", message: "Unable to get available currencies", preferredStyle: .alert)
                let visitExchangeAction = UIAlertAction(title: "Google Forex", style: .default, handler: { _ in
                    self.present(SFSafariViewController(url: URLs.googleForex), animated: true, completion: {
                        self.tabBarController?.selectedIndex = 0
                    })
                })
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(visitExchangeAction)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                return
            }

            self.currencies = currencies
            self.setupInitialCurrencies()
        }
    }

    func fetchCurrencyBetween(_ currency: Currency, and otherCurrency: Currency) {
        startLoading()

        IEXSwift.shared.fetchExchangeRate(from: currency.code, to: otherCurrency.code, completion: { result in
            self.stopLoading()

            guard let exchange = result.value else { return }

            self.rate = exchange.rate

            guard let fromText = self.fromCurrencyTextField.text, let fromAmount = Double(fromText) else { return }
            let toAmount = fromAmount * self.rate

            self.fromCurrencyTextField.setAmount(fromAmount)
            self.toCurrencyTextField.setAmount(toAmount)
        })
    }

    func setupInitialCurrencies() {
        if let dollar = currencies.first(where: { $0.code == "USD" }) {
            fromCurrency = dollar
            IEXMobileUtilities.fetchCountryFlag(with: dollar.code, completion: { self.fromCurrencyImageView.image = $0
                self.setupImageViews()
            })
        }

        if let euro = currencies.first(where: { $0.code == "EUR" }) {
            toCurrency = euro
            IEXMobileUtilities.fetchCountryFlag(with: euro.code, completion: { self.toCurrencyImageView.image = $0
                self.setupImageViews()
            })
        }

        fetchCurrencyBetween(fromCurrency, and: toCurrency)
    }

    func createToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.IEX.main
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        return toolBar
    }

    @objc func doneTapped() {
        view.endEditing(true)
    }

    @IBAction func changeCurrenciesButtonPressed() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        let tempFromCurrency = fromCurrency
        let tempFromImage = fromCurrencyImageView.image
        let tempAmount = fromCurrencyTextField.amount
        rate = 1 / rate

        UIView.animate(withDuration: 0.15, animations: {
            self.fromCurrencyTextField.alpha = 0
            self.fromCurrencyImageView.alpha = 0
            self.toCurrencyTextField.alpha = 0
            self.toCurrencyImageView.alpha = 0

        }, completion: { _ in
            UIView.animate(withDuration: 0.15, animations: {
                self.fromCurrencyTextField.alpha = 1
                self.fromCurrencyImageView.alpha = 1
                self.toCurrencyTextField.alpha = 1
                self.toCurrencyImageView.alpha = 1

                self.fromCurrency = self.toCurrency
                self.fromCurrencyImageView.image = self.toCurrencyImageView.image
                self.fromCurrencyTextField.setAmount(self.toCurrencyTextField.amount)

                self.toCurrency = tempFromCurrency
                self.toCurrencyImageView.image = tempFromImage
                self.toCurrencyTextField.setAmount(tempAmount)
            })
        })
    }

    @objc func fromCurrencyImageViewPressed() {
        performSegue(withIdentifier: Segues.toCurrencies, sender: CurrencySelection.from)
    }

    @objc func toCurrencyImageViewPressed() {
        performSegue(withIdentifier: Segues.toCurrencies, sender: CurrencySelection.to)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let currenciesViewController = segue.destination as? CurrenciesTableViewController
        currenciesViewController?.currencies = currencies
        currenciesViewController?.delegate = self

        let selection = sender as? CurrencySelection

        if selection == .from {
            currenciesViewController?.selection = .from
            currenciesViewController?.selectedCurrency = fromCurrency
        } else if selection == .to {
            currenciesViewController?.selection = .to
            currenciesViewController?.selectedCurrency = toCurrency
        }
    }
}

extension CurrencyExchangeViewController: NumberTextFieldDelegate {
    func textDidChange(_ textField: NumberTextField) {
        if textField == fromCurrencyTextField {
            let amount = fromCurrencyTextField.amount
            toCurrencyTextField.setAmount(amount * rate)
        }
    }
}

extension CurrencyExchangeViewController: CurrenciesTableViewDelegate {
    func selected(_ currency: Currency, selection: CurrencySelection) {
        switch selection {
        case .from:
            fromCurrency = currency

            IEXMobileUtilities.fetchCountryFlag(with: currency.code, completion: { self.fromCurrencyImageView.image = $0
                self.setupImageViews()
            })

        case .to:
            toCurrency = currency
            IEXMobileUtilities.fetchCountryFlag(with: currency.code, completion: { self.toCurrencyImageView.image = $0
                self.setupImageViews()
            })
        }

        fetchCurrencyBetween(fromCurrency, and: toCurrency)
    }
}
