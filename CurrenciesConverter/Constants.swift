//
//  Constants.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import UIKit

struct Converter {
    static let exchangeCount = 2
    static let digitsRounded = 2
}

struct FixerAPI {
    static let apiKey = "84172de56a28ef7d20efc14326a50511"
    static let defaultCurrency = "EUR"
}

extension URL {
    static let baseURL = "http://data.fixer.io/api"
    static let latestPath = "/latest"
}
