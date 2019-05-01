//
//  IEXError.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/30/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

enum IEXError: Error {
    case noData
    case corruptedData
    case unauthorized
    case serviceFailure
}
