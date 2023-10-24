//
//  Endpoint.swift
//  LearningAcademy
//
//  Created by Manish Parihar on 24.10.23.
//

import Foundation

enum Endpoint {
    case user(offset: Int) // page (1)  = offset (0) and per_page (6) = limit (10)
    // case detail(id: Int)
    case create(submissionData: Data?)
}

extension Endpoint {
    
    enum MethodType: Equatable {
        case GET
        case POST(data: Data?)
    }
}

extension Endpoint {
    var host: String { "api.slingacademy.com" }
    
    var path: String {
        switch self {
        case .user:
            return "/v1/sample-data/users?"
        /*
        case .detail(let id):
            return "https://api.slingacademy.com/v1/sample-data/users/11"
         */
        case .create:
            return "/api/users"
                
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .user:
            return .GET
        case .create(let data):
            return .POST(data: data)
        }
    }
    
    // For pagination and infinite scroll
    var queryItems: [String: String]? {
        switch self {
        case .user(let offset):
            return ["offset":"\(offset)"]
        default :
            return nil
        }
    }
}

extension Endpoint {
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        var requestQueryItems = [URLQueryItem]()
        
        queryItems?.forEach {item in
            requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
        
        #if DEBUG
        requestQueryItems.append(URLQueryItem(name: "delay", value: "2"))
        #endif
        
        urlComponents.queryItems = requestQueryItems
        
        return urlComponents.url
    }
}
