//
//  StockSymbol.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/26/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

struct StockSymbol: Codable {
    let symbol: String
    let exchange: String
    let name: String
    let type: String
    let iexId: String
    let region: String
    let currency: String
    let isEnabled: Bool
    let date: Date
}

extension StockSymbol: Equatable {
    static func == (lhs: StockSymbol, rhs: StockSymbol) -> Bool {
        return lhs.iexId == rhs.iexId
    }
}
