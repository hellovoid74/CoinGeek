//
//  API.swift
//  CoinG
//
//  Created by Gleb Lanin on 24/03/2022.
//

import Foundation
import Combine

struct API {
    
    enum Error: LocalizedError {
        case addressUnreachable(URL)
        case invalidResponse
        
        var errorDescription: String? {
            switch self {
            case .invalidResponse: return "The server response is invalid."
            case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
            }
        }
    }
    
    /// API endpoints.
    enum EndPoint {
        static let baseURL = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=500&page=1&sparkline=false")!
        static let topURL = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=25&page=1&sparkline=false")!
    }
    
    private let decoder = JSONDecoder()
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
    
    //    func story(id: Int) -> AnyPublisher<CoinData, Error> {
    //      URLSession.shared.dataTaskPublisher(for: EndPoint.baseURL)
    //        .receive(on: apiQueue)
    //        .map { $0.0 }
    //        .decode(type: Story.self, decoder: decoder)
    //        .catch { _ in Empty() }
    //        .eraseToAnyPublisher()
    //    }
    
    func coins() -> AnyPublisher<[CoinData], Error> {
        URLSession.shared.dataTaskPublisher(for: EndPoint.topURL)
            .map { $0.0 }
            .decode(type: [CoinData].self, decoder: decoder)
            .mapError { error in
                switch error {
                case is URLError:
                    return Error.addressUnreachable(EndPoint.topURL)
                default: return Error.invalidResponse
                }
            }
            .map { coins in
                return coins
            }
            .eraseToAnyPublisher()
    }
}

enum WebServiceError: Error {
    case sessionFailed(error: Error)
    case decodingFailed
    case other(Error)
}

protocol WebServiceInterface {
    func publisher<T: Decodable>(for url: URL) -> AnyPublisher<T, WebServiceError>
}

class WebService {
    private let decoder = JSONDecoder()
    private let session = URLSession()
    
    deinit {
        session.finishTasksAndInvalidate()
    }
}

// MARK: - WebServiceInterface

extension WebService: WebServiceInterface {
    func publisher<T: Decodable>(for url: URL) -> AnyPublisher<T, WebServiceError> {
        session.dataTaskPublisher(for: url)
            .tryMap { output in
                guard
                    let response = output.response as? HTTPURLResponse,
                    200 ..< 300 ~= response.statusCode
                else {
                    throw WebServiceError.decodingFailed
                }
                return output.data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                switch error {
                case is Swift.DecodingError:           return .decodingFailed
                case let httpError as WebServiceError: return .sessionFailed(error: httpError.localizedDescription as! Error)
                default:                               return .other(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

