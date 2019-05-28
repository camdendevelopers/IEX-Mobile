//
//  ExchangeRate.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/18/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

struct ExchangeRate: Codable {
    let fromCurrency: String
    let toCurrency: String
    let rate: Double
    let date: Date
}
