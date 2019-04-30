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
    func fetchCompanyInformation(ticker: String, completion: @escaping (Result<CompanyInformation>) -> Void) {
        let token = privateToken ?? publicToken
        let requestURL = environment.baseURL + String(format: IEXStockEndpoint.company.path, ticker)
        let parameters: Parameters = ["token": token]
        Alamofire.request(requestURL, method: .get, parameters: parameters).responseData(completionHandler: { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let companyInformation = try decoder.decode(CompanyInformation.self, from: data)

                completion(.success(companyInformation))
            } catch {
                completion(.failure(error))
            }
        }).resume()
    }

    func fetchAdvanceStatistics(ticker: String, completion: @escaping (Result<CompanyAdvancedStatistics>) -> Void) {
        let token = privateToken ?? publicToken
        let requestURL = environment.baseURL + String(format: IEXStockEndpoint.advancedStats.path, ticker)
        let parameters: Parameters = ["token": token]
        Alamofire.request(requestURL, method: .get, parameters: parameters).responseData(completionHandler: { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let advancedStats = try decoder.decode(CompanyAdvancedStatistics.self, from: data)

                completion(.success(advancedStats))
            } catch {
                completion(.failure(error))
            }
        }).resume()
    }

    func fetchNews(ticker: String, completion: @escaping (Result<[CompanyNewsArticle]>) -> Void) {
        let token = privateToken ?? publicToken
        let requestURL = environment.baseURL + String(format: IEXStockEndpoint.news.path, ticker)
        let parameters: Parameters = ["token": token]
        Alamofire.request(requestURL, method: .get, parameters: parameters).responseData(completionHandler: { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .millisecondsSince1970
                let articles = try decoder.decode([CompanyNewsArticle].self, from: data)
                completion(.success(articles))
            } catch {
                completion(.failure(error))
            }
        }).resume()
    }

    func fetchChart(ticker: String, range: IEXChartRange, completion: @escaping (Result<[CompanyChartDataItem]>) -> Void) {
        let token = privateToken ?? publicToken
        let requestURL = environment.baseURL + String(format: IEXStockEndpoint.chart.path, ticker) + range.query
        let parameters: Parameters = ["token": token]
        Alamofire.request(requestURL, method: .get, parameters: parameters).responseData(completionHandler: { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-d"
                decoder.dateDecodingStrategy = .formatted(formatter)
                let dataItems = try decoder.decode([CompanyChartDataItem].self, from: data)
                completion(.success(dataItems))
            } catch {
                completion(.failure(error))
            }
        }).resume()
    }
}
