//
//  CompanyChartDataItem.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/28/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

struct CompanyChartDataItem: Codable {
    let date: Date
    let open: Double
    let close: Double
    let high: Double
    let low: Double
    let volume: Double
    let changePercent: Double
    let label: String
    let changeOverTime: Double
}
