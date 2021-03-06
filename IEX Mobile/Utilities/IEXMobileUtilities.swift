//
//  IEXMobileUtilities.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/28/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation
import SwiftDate
import Alamofire

enum IEXMobileUtilities {
    static func clearRecentSearches() {
        let emptySearches: [StockSymbol] = []
        UserDefaults.standard.set(try? PropertyListEncoder().encode(emptySearches), forKey: Constants.recentSearchesKey)
    }

    static func fetchCountryFlag(with code: String, completion: @escaping (UIImage) -> Void) {
        var code = code
        code.removeLast(1)
        let url = String(format: URLs.flags, code)
        Alamofire.request(url).response { response in
            guard let data = response.data, let image = UIImage(data: data) else {
                completion(#imageLiteral(resourceName: "defaultFlag-icon"))
                return
            }
            completion(image)
        }
    }

    static func relativeFormattingFromToday(_ date: Date) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full

        let componentsLeftTime = Calendar.current.dateComponents([.minute , .hour , .day,.month, .weekOfMonth,.year], from: date, to: Date())

        let year = componentsLeftTime.year ?? 0
        if  year > 0 {
            formatter.allowedUnits = [.year]
            return formatter.string(from: date, to: Date())
        }


        let month = componentsLeftTime.month ?? 0
        if  month > 0 {
            formatter.allowedUnits = [.month]
            return formatter.string(from: date, to: Date())
        }

        let weekOfMonth = componentsLeftTime.weekOfMonth ?? 0
        if  weekOfMonth > 0 {
            formatter.allowedUnits = [.weekOfMonth]
            return formatter.string(from: date, to: Date())
        }

        let day = componentsLeftTime.day ?? 0
        if  day > 0 {
            formatter.allowedUnits = [.day]
            return formatter.string(from: date, to: Date())
        }

        let hour = componentsLeftTime.hour ?? 0
        if  hour > 0 {
            formatter.allowedUnits = [.hour]
            return formatter.string(from: date, to: Date())
        }

        let minute = componentsLeftTime.minute ?? 0
        if  minute > 0 {
            formatter.allowedUnits = [.minute]
            return formatter.string(from: date, to: Date()) ?? ""
        }

        return nil
    }
}
