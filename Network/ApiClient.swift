//
//  ApiClient.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum APIService {
    case latest
}

extension APIService: TargetType {
    var method: Moya.Method {
        switch self {
        case .latest:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestParameters(parameters: ["access_key": FixerAPI.apiKey], encoding: URLEncoding.default)
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    var baseURL: URL {
        return URL(string: URL.baseURL)!
    }

    var path: String {
        switch self {
        case .latest:
            return URL.latestPath
        }
    }

    var parameterEncoding: Moya.ParameterEncoding {
        return JSONEncoding.default
    }
}

let provider = MoyaProvider<APIService>(plugins: [NetworkLoggerPlugin(verbose: true)])
