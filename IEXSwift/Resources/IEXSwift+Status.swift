//
//  IEXSwift+Status.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/30/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation
import Alamofire

extension IEXSwift {
    func fetchStatus(completion: @escaping (Result<IEXServiceStatus>) -> Void) {
        let requestURL = environment.baseURL + IEXServiceEndpoint.status.path

        Alamofire.request(requestURL, method: .get).responseData(completionHandler: { response in
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
                let status = try decoder.decode(IEXServiceStatus.self, from: data)

                completion(.success(status))
            } catch {
                completion(.failure(IEXError.corruptedData))
            }
        }).resume()
    }
}
