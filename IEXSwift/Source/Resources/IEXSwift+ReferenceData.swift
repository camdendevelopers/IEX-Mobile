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
        let requestURL = environment.baseURL + IEXReferenceDataEndpoint.symbols.path
        let finalParameters: Parameters = ["token": serviceToken]
        Alamofire.request(requestURL, method: .get, parameters: finalParameters).responseData(completionHandler: { response in
            if let error = response.error {
                completion(.failure(error))
                return
            }

            guard let data = response.data else {
                completion(.failure(IEXError.noData))
                return
            }
            
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-d"
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let stocks = try decoder.decode([StockSymbol].self, from: data)

                completion(.success(stocks))
            } catch {
                completion(.failure(IEXError.corruptedData))
            }
        }).resume()
    }
}
