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
        let token = privateToken ?? publicToken
        var finalParameters: Parameters = ["token": token]
        finalParameters.merge(parameters, uniquingKeysWith: { $1 })

        Alamofire.request(requestURL, method: .get, parameters: finalParameters).responseData(completionHandler: { response in
            if let error = response.error {
                if let statusCode = response.response?.statusCode, 400...499 ~= statusCode {
                    completion(.failure(IEXError.unauthorized))
                }

                completion(.failure(error))
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
}
