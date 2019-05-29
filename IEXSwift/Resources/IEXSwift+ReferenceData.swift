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

    func fetchCurrencies(completion: @escaping (Result<[Currency]>) -> Void) {
        let requestURL = environment.baseURL + IEXReferenceDataEndpoint.currencies.path
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
                let decoder = JSONDecoder()
                let symbols = try decoder.decode(CurrencySymbols.self, from: data)

                completion(.success(symbols.currencies))
            } catch {
                completion(.failure(IEXError.corruptedData))
            }
        }).resume()
    }

    func fetchExchangeRate(from fromCurrency: String, to toCurrency: String, completion: @escaping (Result<ExchangeRate>) -> Void) {
        var requestURL = environment.baseURL + IEXReferenceDataEndpoint.exchangeRate.path
        requestURL = String(format: requestURL, arguments: [fromCurrency, toCurrency])
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
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-d"
                decoder.dateDecodingStrategy = .formatted(formatter)

                let rate = try decoder.decode(ExchangeRate.self, from: data)

                completion(.success(rate))
            } catch {
                completion(.failure(IEXError.corruptedData))
            }
        }).resume()
    }
}
