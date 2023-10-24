//
//  NetworkingManager.swift
//  LearningAcademy
//
//  Created by Manish Parihar on 24.10.23.
//

import Foundation

protocol NetworkingManagerImpl {
    // We want to move our request here, we take out default .shared from session.
    func request<T: Codable>(session: URLSession,
                             endpoint: Endpoint,
                             type:T.Type) async throws -> T
    
    func request(session: URLSession,
                 _ endpoint: Endpoint) async throws
}


final class NetworkingManager: NetworkingManagerImpl {
    
    static let shared = NetworkingManager()
    
    private init() {}
    
    // Make generic constraint so make request with Type T and Codable
    // We want to actually pass in a type so we allow someone to say the model that they want to map it to within the request function so we are going to say type and want that type to be T.type
    func request<T: Codable>(session: URLSession = .shared,
                             endpoint: Endpoint,
                             type: T.Type) async throws -> T {
        // check for is endpoint valid ?
        guard let url = endpoint.url else {
            throw NetworkingError.invalidUrl
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
        
        // Decode here
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let res = try decoder.decode(T.self, from: data)
        
        return res
    }
    
    // POST Request -

    func request(session: URLSession, 
                 _ endpoint: Endpoint) async throws {
        
        guard let url = endpoint.url else {
            throw NetworkingError.invalidUrl
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let (_, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
    }
    
}

extension NetworkingManager {
    enum NetworkingError: LocalizedError {
        case invalidUrl
        case custom(error:Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
    }
}

// Added this because our NetworkingManagerTest for unsuccessful for 400 got error
extension NetworkingManager.NetworkingError: Equatable {
    static func == (lhs: NetworkingManager.NetworkingError, rhs: NetworkingManager.NetworkingError) -> Bool {
        switch(lhs, rhs) {
        case (.invalidUrl, .invalidUrl):
            return true
        case (.custom(let lhsType), .custom(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        case (.invalidStatusCode(let lhsType), .invalidStatusCode(let rhsType)):
            return lhsType == rhsType
        case (.invalidData, .invalidData):
            return true
        case (.failedToDecode(let lhsType), .failedToDecode(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}

// Error Mapping
extension NetworkingManager.NetworkingError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "URL isn't valid"
        case .invalidStatusCode:
            return "Status code falls into the wrong group"
        case .invalidData:
            return "Response data is invalid"
        case .failedToDecode:
            return "Failed to decode"
        case .custom(let err):
            return "Something went wrong \(err.localizedDescription)"
        }
    }
}

// i dont want to expose the extension to access outside this network manager
private extension NetworkingManager {
    func buildRequest(from url:URL,
                      methodType:Endpoint.MethodType) -> URLRequest {
        var request = URLRequest(url: url)
        
        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        case .POST(let data):
            request.httpMethod = "POST"
            request.httpBody = data
        }
        return request
    }
}
