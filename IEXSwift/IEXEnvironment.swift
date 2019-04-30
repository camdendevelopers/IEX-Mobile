//
//  IEXEnvironment.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/26/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

enum IEXEnvironment {
    case v1
    case beta
    case testing

    var host: String {
        switch self {
        case .v1, .beta:
            return "https://cloud.iexapis.com"
        case .testing:
            return "https://sandbox.iexapis.com"
        }
    }

    var version: String {
        switch self {
        case .v1:
            return "/v1"
        case .beta:
            return "/beta"
        case .testing:
            return "/latest"
        }
    }

    var baseURL: String {
        return host + version
    }
}
