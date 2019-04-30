//
//  IEXSwift+ReferenceData.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/29/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation
import Alamofire

extension IEXSwift {
    func fetchStockSymbols(completion: @escaping (Result<[StockSymbol]>) -> Void) {
        let token = privateToken ?? publicToken
        let requestURL = environment.baseURL + IEXReferenceDataEndpoint.symbols.path
        let parameters: Parameters = ["token": token]
        Alamofire.request(requestURL, method: .get, parameters: parameters).responseData(completionHandler: { response in
            guard let data = response.data else { return }
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-d"
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let stocks = try decoder.decode([StockSymbol].self, from: data)

                completion(.success(stocks))
            } catch {
                completion(.failure(error))
            }
        }).resume()
    }
}
