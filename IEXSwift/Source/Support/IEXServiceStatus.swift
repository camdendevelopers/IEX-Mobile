//
//  IEXServiceStatus.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/30/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

struct IEXServiceStatus: Codable {
    let status: String
    let version: String
    let time: Date
}
