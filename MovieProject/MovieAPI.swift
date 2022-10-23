//
//  MovieAPI.swift
//  MovieProject
//
//  Created by Pranjal Verma on 24/10/22.
//

import Foundation
import ElegantAPI

enum MovieAPI {
    private static let apiKey = "aefe4863"
    case search(searchText: String, pageNo: Int)
}

extension MovieAPI: API {
    var baseURL: URL {
        URL(string: "http://www.omdbapi.com/")!
    }
    
    var path: String {
        switch self {
        case .search:
            return ""
        }
    }
    
    var method: ElegantAPI.Method {
        switch self {
        case .search:
            return .get
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: ElegantAPI.Task {
        switch self {
        case .search(let searchText, let pageNo):
            return .requestParameters(parameters: [
                "s": searchText,
                "page": pageNo,
                "apikey": Self.apiKey
            ], encoding: .URLEncoded)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .search:
            return ["Content-Type": "application/json"]
        }
    }
    
}
