//
//  BalanceSheet.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/5/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

struct BalanceSheets: Codable {
    let symbol: String
    let balancesheet: [BalanceSheet]
}

struct BalanceSheet: Codable {
    let reportDate: Date
    let currentCash: Double?
    let shortTermInvestments: Double?
    let receivables: Double?
    let inventory: Double?
    let otherCurrentAssets: Double?
    let currentAssets: Double?
    let longTermInvestments: Double?
    let propertyPlantEquipment: Double?
    let goodwill: Double?
    let intangibleAssets: Double?
    let otherAssets: Double?
    let totalAssets: Double?
    let accountsPayable: Double?
    let currentLongTermDebt: Double?
    let otherCurrentLiabilities: Double?
    let totalCurrentLiabilities: Double?
    let longTermDebt: Double?
    let otherLiabilities: Double?
    let minorityInterest: Double?
    let totalLiabilities: Double?
    let commonStock: Double?
    let retainedEarnings: Double?
    let treasuryStock: Double?
    let capitalSurplus: Double?
    let shareholderEquity: Double?
    let netTangibleAssets: Double?
}
