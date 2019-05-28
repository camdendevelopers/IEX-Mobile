//
//  IEXSwift+Account.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/1/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation
import Alamofire

extension IEXSwift {
    func fetchAccountMetadata(parameters: Parameters = [:], completion: @escaping (Result<AccountMetadata>) -> Void) {
        let requestURL = environment.baseURL + IEXAccountEndpoint.metadata.path
        var finalParameters: Parameters = ["token": serviceToken]
        finalParameters.merge(parameters, uniquingKeysWith: { $1 })

        Alamofire.request(requestURL, method: .get, parameters: finalParameters).responseData(completionHandler: { response in
            if let error = response.error {
                completion(.failure(error))
                return
            }

            if let statusCode = response.response?.statusCode, 400...499 ~= statusCode {
                completion(.failure(IEXError.unauthorized))
                return 
            }

            guard let data = response.data else {
                completion(.failure(IEXError.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let status = try decoder.decode(AccountMetadata.self, from: data)

                completion(.success(status))
            } catch {
                completion(.failure(IEXError.corruptedData))
            }
        }).resume()
    }

    func updatePayAsYouGo(allow: Bool, completion: @escaping (Result<Bool>) -> Void) {
        let requestURL = environment.baseURL + IEXAccountEndpoint.payAsYouGo.path
        let finalParameters: Parameters = ["token": serviceToken, "allow": allow]

        Alamofire.request(requestURL, method: .post, parameters: finalParameters).responseData(completionHandler: { response in
            if response.error != nil {
                completion(.success(false))
            } else {
                completion(.success(true))
            }
        }).resume()
    }
}
