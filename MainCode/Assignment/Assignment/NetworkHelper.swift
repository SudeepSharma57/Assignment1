//
//  NetworkHelper.swift
//  Assignment
//
//  Created by Sudeep Sharma on 29/06/23.
//

import Foundation

class NetworkHelper {
    
    static let shared = NetworkHelper()
    private init(){}
    
    enum API:String {
        case facilities = "https://my-json-server.typicode.com/iranjith4/ad-assignment/db"
    }
    
    enum APIType:String{
        case GET
    }
    
    enum ErrorType:Error{
        case invalidURL
        case dataNotAvailable
        case unknown
    }
    
    
    func callAPI<T:Codable>(name:API, type:APIType, model:T.Type) async throws -> T {
        guard let url = URL(string: name.rawValue) else {
            throw ErrorType.invalidURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = type.rawValue
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(model, from: data)
        
    }
}
