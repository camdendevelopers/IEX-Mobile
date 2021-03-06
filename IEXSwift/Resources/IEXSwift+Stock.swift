//
//  IEXSwift+Stock.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/29/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation
import Alamofire

extension IEXSwift {
    func fetchCompanyLogo(ticker: String, completion: @escaping (Result<CompanyLogo>) -> Void) {
        let requestURL = environment.baseURL + String(format: IEXStockEndpoint.logo.path, ticker)
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
                let logo = try decoder.decode(CompanyLogo.self, from: data)

                completion(.success(logo))
            } catch {
                completion(.failure(IEXError.corruptedData))
            }

        }).resume()
    }

    func fetchCompanyInformation(ticker: String, completion: @escaping (Result<CompanyInformation>) -> Void) {
        let requestURL = environment.baseURL + String(format: IEXStockEndpoint.company.path, ticker)
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
                let companyInformation = try decoder.decode(CompanyInformation.self, from: data)

                completion(.success(companyInformation))
            } catch {
                completion(.failure(IEXError.corruptedData))
            }
        }).resume()
    }

    func fetchAdvanceStatistics(ticker: String, completion: @escaping (Result<CompanyAdvancedStatistics>) -> Void) {
        let requestURL = environment.baseURL + String(format: IEXStockEndpoint.advancedStats.path, ticker)
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
                let advancedStats = try decoder.decode(CompanyAdvancedStatistics.self, from: data)

                completion(.success(advancedStats))
            } catch {
                completion(.failure(IEXError.corruptedData))
            }
        }).resume()
    }

    func fetchNews(ticker: String, completion: @escaping (Result<[CompanyNewsArticle]>) -> Void) {
        let requestURL = environment.baseURL + String(format: IEXStockEndpoint.news.path, ticker)
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
                decoder.dateDecodingStrategy = .millisecondsSince1970
                let articles = try decoder.decode([CompanyNewsArticle].self, from: data)
                completion(.success(articles))
            } catch {
                completion(.failure(IEXError.corruptedData))
            }
        }).resume()
    }

    func fetchChart(ticker: String, range: IEXChartRange, completion: @escaping (Result<[CompanyChartDataItem]>) -> Void) {
        let requestURL = environment.baseURL + String(format: IEXStockEndpoint.chart.path, ticker) + range.query
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
                let dataItems = try decoder.decode([CompanyChartDataItem].self, from: data)
                completion(.success(dataItems))
            } catch {
                completion(.failure(IEXError.corruptedData))
            }
        }).resume()
    }

    func fetchBalanceSheets(ticker: String, last: Int = 12, period: String = "annual", completion: @escaping (Result<BalanceSheets>) -> Void) {
        let requestURL = environment.baseURL + String(format: IEXStockEndpoint.balanceSheets.path, ticker) + "\(last)"
        let finalParameters: Parameters = ["token": serviceToken, "period": period, "last": last]

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
                let dataItems = try decoder.decode(BalanceSheets.self, from: data)
                completion(.success(dataItems))
            } catch {
                completion(.failure(IEXError.corruptedData))
            }
        }).resume()
    }
}
