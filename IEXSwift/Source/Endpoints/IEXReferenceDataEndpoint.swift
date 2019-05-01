//
//  IEXReferenceDataEndpoint.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/29/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

enum IEXReferenceDataEndpoint {
    case symbols

    var path: String {
        switch self {
        case .symbols:
            return "/ref-data/symbols"
        }
    }
}
