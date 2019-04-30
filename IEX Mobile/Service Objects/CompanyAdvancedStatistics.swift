//
//  CompanyAdvancedStatistics.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/26/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

struct CompanyAdvancedStatistics: Codable {
    let week52high: Double?
    let week52low: Double?
    let dividendYield: Double?
    let ytdChangePercent: Double?
    let avg10Volume: Double?
    let marketcap: Double?
    let peRatio: Double?
    let beta: Double?
}
