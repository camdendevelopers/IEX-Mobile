//
//  CompanyInformation.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/26/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

struct CompanyInformation: Codable {
    let symbol: String
    let companyName: String
    let exchange: String
    let industry: String
    let website: String
    let description: String
    let CEO: String
    let securityName: String
    let issueType: String
    let sector: String
    let employees: Int?
    let tags: [String]?
}
