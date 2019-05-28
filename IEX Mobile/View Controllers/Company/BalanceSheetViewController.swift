//
//  BalanceSheetViewController.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/5/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit

class BalanceSheetViewController: UIViewController {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var currentCashLabel: UILabel!
    @IBOutlet var shortTermInvestmentsLabel: UILabel!
    @IBOutlet var receivablesLabel: UILabel!
    @IBOutlet var inventoryLabel: UILabel!
    @IBOutlet var otherCurrentAssetsLabel: UILabel!
    @IBOutlet var totalCurrentAssetsLabel: UILabel!
    @IBOutlet var longTermInvestmentsLabel: UILabel!
    @IBOutlet var propertyPlantEquipmentLabel: UILabel!
    @IBOutlet var goodwillLabel: UILabel!
    @IBOutlet var intangibleAssetsLabel: UILabel!
    @IBOutlet var otherAssetsLabel: UILabel!
    @IBOutlet var totalAssetsLabel: UILabel!

    @IBOutlet var accountsPayableLabel: UILabel!
    @IBOutlet var currentLongTermDebtLabel: UILabel!
    @IBOutlet var otherCurrentLiabilitiesLabel: UILabel!
    @IBOutlet var totalCurrentLiabilitiesLabel: UILabel!
    @IBOutlet var longTermDebtLabel: UILabel!
    @IBOutlet var otherLiabilitiesLabel: UILabel!
    @IBOutlet var minorityInterestLabel: UILabel!
    @IBOutlet var totalLiabilitiesLabel: UILabel!

    @IBOutlet var commonStockLabel: UILabel!
    @IBOutlet var retainedEarningsLabel: UILabel!
    @IBOutlet var treasuryStockLabel: UILabel!
    @IBOutlet var capitalSurplusLabel: UILabel!
    @IBOutlet var shareholderLabel: UILabel!
    @IBOutlet var netTangibleAssetsLabel: UILabel!

    // MARK:- Content Stack Views
    @IBOutlet var currentCashStackView: UIStackView!
    @IBOutlet var shortTermInvestmentsStackView: UIStackView!
    @IBOutlet var receivablesStackView: UIStackView!
    @IBOutlet var inventoryStackView: UIStackView!
    @IBOutlet var otherCurrentAssetsStackView: UIStackView!
    @IBOutlet var totalCurrentAssetsStackView: UIStackView!
    @IBOutlet var longTermInvestmentsStackView: UIStackView!
    @IBOutlet var propertyPlantEquipmentStackView: UIStackView!
    @IBOutlet var goodwillStackView: UIStackView!
    @IBOutlet var intangibleAssetsStackView: UIStackView!
    @IBOutlet var otherAssetsStackView: UILabel!
    @IBOutlet var totalAssetsStackView: UIStackView!

    @IBOutlet var accountPayableStackView: UIStackView!
    @IBOutlet var currentLongTermDebtStackView: UIStackView!
    @IBOutlet var otherCurrentLiabilitiesStackView: UIStackView!
    @IBOutlet var totalCurrentLiabilitiesStackView: UIStackView!
    @IBOutlet var longTermDebtStackView: UIStackView!
    @IBOutlet var otherLiabilitiesStackView: UIStackView!
    @IBOutlet var minorityStackView: UIStackView!
    @IBOutlet var totalLiabilitiesStackView: UIStackView!

    @IBOutlet var commonStockStackView: UIStackView!
    @IBOutlet var retainedEarningsStackView: UIStackView!
    @IBOutlet var treasuryStockStackView: UIStackView!
    @IBOutlet var capitalSurplusStackView: UIStackView!
    @IBOutlet var shareholderStackView: UIStackView!
    @IBOutlet var netTangibleAssetsStackView: UIStackView!

    var balanceSheet: BalanceSheet?

    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    override func viewDidLoad() {
        guard let balanceSheet = balanceSheet else { return }
        configureLayout(with: balanceSheet)
        configureLabels(with: balanceSheet)
    }

    private func configureLayout(with balanceSheet: BalanceSheet) {
        currentCashStackView.isHidden = balanceSheet.currentCash == nil
        shortTermInvestmentsStackView.isHidden = balanceSheet.shortTermInvestments == nil
        receivablesStackView.isHidden = balanceSheet.receivables == nil
        inventoryStackView.isHidden = balanceSheet.inventory == nil
        otherCurrentAssetsStackView.isHidden = balanceSheet.otherCurrentAssets == nil
        totalCurrentAssetsStackView.isHidden = balanceSheet.currentAssets == nil
        longTermInvestmentsStackView.isHidden = balanceSheet.longTermInvestments == nil
        propertyPlantEquipmentStackView.isHidden = balanceSheet.propertyPlantEquipment == nil
        goodwillStackView.isHidden = balanceSheet.goodwill == nil
        intangibleAssetsStackView.isHidden = balanceSheet.intangibleAssets == nil
        otherAssetsStackView.isHidden = balanceSheet.otherAssets == nil
        totalAssetsStackView.isHidden = balanceSheet.totalAssets == nil

        accountPayableStackView.isHidden = balanceSheet.accountsPayable == nil
        currentLongTermDebtStackView.isHidden = balanceSheet.currentLongTermDebt == nil
        otherCurrentLiabilitiesStackView.isHidden = balanceSheet.otherCurrentLiabilities == nil
        totalCurrentLiabilitiesStackView.isHidden = balanceSheet.totalCurrentLiabilities == nil
        longTermDebtStackView.isHidden = balanceSheet.longTermDebt == nil
        otherLiabilitiesStackView.isHidden = balanceSheet.otherLiabilities == nil
        minorityStackView.isHidden = balanceSheet.minorityInterest == nil
        totalLiabilitiesStackView.isHidden = balanceSheet.totalLiabilities == nil

        commonStockStackView.isHidden = balanceSheet.commonStock == nil
        retainedEarningsStackView.isHidden = balanceSheet.retainedEarnings == nil
        treasuryStockStackView.isHidden = balanceSheet.treasuryStock == nil
        capitalSurplusStackView.isHidden = balanceSheet.capitalSurplus == nil
        shareholderStackView.isHidden = balanceSheet.shareholderEquity == nil
        netTangibleAssetsStackView.isHidden = balanceSheet.netTangibleAssets == nil
    }

    private func configureLabels(with balanceSheet: BalanceSheet) {
        dateLabel.text = balanceSheet.reportDate.toString(.date(.long))

        currentCashLabel.text = text(with: balanceSheet.currentCash)
        shortTermInvestmentsLabel.text = text(with: balanceSheet.shortTermInvestments)
        receivablesLabel.text = text(with: balanceSheet.receivables)
        inventoryLabel.text = text(with: balanceSheet.inventory)
        otherCurrentAssetsLabel.text = text(with: balanceSheet.otherCurrentAssets)
        totalCurrentAssetsLabel.text = text(with: balanceSheet.currentAssets)
        longTermDebtLabel.text = text(with: balanceSheet.longTermDebt)
        propertyPlantEquipmentLabel.text = text(with: balanceSheet.propertyPlantEquipment)
        goodwillLabel.text = text(with: balanceSheet.goodwill)
        intangibleAssetsLabel.text = text(with: balanceSheet.intangibleAssets)
        otherCurrentAssetsLabel.text = text(with: balanceSheet.otherCurrentAssets)
        totalAssetsLabel.text = text(with: balanceSheet.totalAssets)

        accountsPayableLabel.text = text(with: balanceSheet.accountsPayable)
        currentLongTermDebtLabel.text = text(with: balanceSheet.currentLongTermDebt)
        otherCurrentLiabilitiesLabel.text = text(with: balanceSheet.otherCurrentLiabilities)
        totalCurrentLiabilitiesLabel.text = text(with: balanceSheet.totalCurrentLiabilities)
        longTermDebtLabel.text = text(with: balanceSheet.longTermDebt)
        otherLiabilitiesLabel.text = text(with: balanceSheet.otherLiabilities)
        minorityInterestLabel.text = text(with: balanceSheet.minorityInterest)
        totalLiabilitiesLabel.text = text(with: balanceSheet.totalLiabilities)

        commonStockLabel.text = text(with: balanceSheet.commonStock)
        retainedEarningsLabel.text = text(with: balanceSheet.retainedEarnings)
        treasuryStockLabel.text = text(with: balanceSheet.treasuryStock)
        capitalSurplusLabel.text = text(with: balanceSheet.capitalSurplus)
        shareholderLabel.text = text(with: balanceSheet.shareholderEquity)
        netTangibleAssetsLabel.text = text(with: balanceSheet.netTangibleAssets)

    }

    private func text(with value: Double?) -> String? {
        guard let double = value else { return nil }
        return formatter.string(from: NSNumber(value: double))
    }
}
