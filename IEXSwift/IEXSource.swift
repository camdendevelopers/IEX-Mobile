//
//  IEXSource.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/26/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

enum IEXSource {
    case stock
    case account
    case referenceData

    var path: String {
        switch self {
        case .stock:
            return "/stock"
        case .account :
            return "/account"
        case .referenceData:
            return "/ref-data"
        }
    }
}
