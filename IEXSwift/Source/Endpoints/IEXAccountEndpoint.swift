//
//  IEXAccountEndpoint.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/1/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

enum IEXAccountEndpoint {
    case metadata
    case usage
    case payAsYouGo

    var path: String {
        switch self {
        case .metadata:
            return "/account/metadata"
        case .usage:
            return "/account/usage"
        case .payAsYouGo:
            return "/account/payasyougo"
        }
    }
}
