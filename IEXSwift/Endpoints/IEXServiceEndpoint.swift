//
//  IEXServiceEndpoint.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/30/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

enum IEXServiceEndpoint {
    case status

    var path: String {
        switch self {
        case .status:
            return "/status"
        }
    }
}
