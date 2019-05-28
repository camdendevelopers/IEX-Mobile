//
//  Currency.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/18/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

struct Currency: Codable {
    let code: String
    let name: String
}

extension Currency: Equatable {
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code == rhs.code
    }
}

extension Currency: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}
