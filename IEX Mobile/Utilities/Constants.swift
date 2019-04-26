//
//  Constants.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/25/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

enum Constants {
    static let publicTokenKey = "publicTokenKey"
    static let privateTokenKey = "privateTokenKey"
    static let hasEnrolledInBiometricsKey = "hasEnrolledInBiometrics"
    static let hasAuthenticatedKey = "hasAuthenticatedKey"
    static let IEXRegisterURL = "https://iexcloud.io/cloud-login#/register/"

    static var hasTokens: Bool {
        return KeychainService.shared[publicTokenKey] != nil || KeychainService.shared[privateTokenKey] != nil
    }

    static var hasAuthenticated: Bool {
        get { return UserDefaults.standard.bool(forKey: hasAuthenticatedKey) }
        set { UserDefaults.standard.set(newValue, forKey: hasAuthenticatedKey) }
    }

    static var hasEnrolledInBiometrics: Bool {
        get { return UserDefaults.standard.bool(forKey: hasEnrolledInBiometricsKey) }
        set { UserDefaults.standard.set(newValue, forKey: hasEnrolledInBiometricsKey) }
    }
}
