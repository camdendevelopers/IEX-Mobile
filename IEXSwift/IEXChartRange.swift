//
//  IEXChartRange.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/28/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

enum IEXChartRange {
    case month1
    case month3
    case month6
    case ytd
    case year1
    case year2
    case year5

    var query: String {
        switch self {
        case .month1: return "1m"
        case .month3: return "3m"
        case .month6: return "6m"
        case .ytd: return "ytd"
        case .year1: return "1y"
        case .year2: return "2y"
        case .year5: return "5y"
        }
    }
}
