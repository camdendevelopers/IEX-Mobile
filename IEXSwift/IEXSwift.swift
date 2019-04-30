//
//  IEXSwift.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/26/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation
import Alamofire

class IEXSwift {
    static let shared = IEXSwift()

    var publicToken: String = ""
    var privateToken: String?
    var testingPublicToken: String?
    var testingPrivateToken: String?
    var environment: IEXEnvironment = .v1
}
