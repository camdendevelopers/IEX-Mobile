//
//  CompanyNewsArticle.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/27/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

struct CompanyNewsArticle: Codable {
    let datetime: Date
    let headline: String
    let source: String
    let url: String
    let summary: String
    let related: String?
    let image: String?
}
