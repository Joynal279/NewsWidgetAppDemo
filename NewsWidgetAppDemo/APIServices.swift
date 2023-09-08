//
//  APIServices.swift
//  NewsWidgetAppDemo
//
//  Created by Joynal Abedin on 8/9/23.
//

import Foundation
import Combine

final class APIService {
    enum APIError: Error {
        case unknownError
    }

    func getObject<T: Codable>(object: T.Type, url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw APIError.unknownError
                    }
                    guard 200...299 ~= httpResponse.statusCode else {
                        throw URLError(URLError.Code(rawValue: httpResponse.statusCode), userInfo: httpResponse.allHeaderFields as? [String: Any] ?? [:] )
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
    }
}
