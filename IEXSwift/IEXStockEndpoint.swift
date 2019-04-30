//
//  IEXStockEndpoint.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/26/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

enum IEXStockEndpoint {
    case news
    case company
    case advancedStats
    case chart
    case logo

    var path: String {
        switch self {
        case .news:
            return "/stock/%@/news"
        case .company:
            return "/stock/%@/company"
        case .advancedStats:
            return "/stock/%@/advanced-stats"
        case .chart:
            return "/stock/%@/chart/"
        case .logo:
            return "/stock/%@/logo"
        }
    }
}
