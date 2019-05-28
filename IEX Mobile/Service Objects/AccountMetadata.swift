//
//  AccountMetadata.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/1/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

struct AccountMetadata: Codable {
    let payAsYouGoEnabled: Bool?
    let effectiveDate: Date
    let endDateEffective: Date?
    let overagesEnabled: Bool?
    let subscriptionTermType: String
    let tierName: String
    let messageLimit: Int
    let messagesUsed: Int
}
