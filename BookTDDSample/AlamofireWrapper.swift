//
//  AlamofireWrapper.swift
//  BookTDDSample
//
//  Created by Arrr Park on 08/05/2022.
//

import Foundation
import Alamofire
import Combine
import ObjectMapper

enum NetworkError: Error {
    case badForm
    case networkError
}

struct AlamofireWrapper {
    static let shared = AlamofireWrapper()
    
    private init() { }
    
    private let baseURL = "https://api.itbook.store/"
    
    private func configureHeaders() -> HTTPHeaders {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    func byGet<T: Mappable>(url: String, parameters: [String: Any]? = nil) -> Future<T, NetworkError> {
        return Future<T, NetworkError>({ promise in
            AF.request("\(baseURL)\(url)", parameters: parameters, headers: configureHeaders())
                .validate(statusCode: 200..<300)
                .response(completionHandler: { response in
                    guard let data = response.data,
                          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                          let result = T(JSON: json) else {
                        promise(.failure(.badForm))
                        return
                    }
                    promise(.success(result))
                })
        })
    }
}
