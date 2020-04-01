//
//  Currency.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

extension Currency {
    func replace(name: String, at index: Int) {
        currenciesList.replace(index: index, object: name)
    }
}

final class Currency: Object, Decodable {
    @objc dynamic var id = 1
    @objc dynamic var success: Bool = false
    @objc dynamic var timestamp: Int64 = 0
    @objc dynamic var base: String = ""
    @objc dynamic var date: String = ""

    private var ratesList: List = List<Rate>()
    var rates: [Rate] {
        return Array(ratesList)
    }

    private var currenciesList: List = List<String>()
    var currencies: [String] {
        return Array(currenciesList)
    }

    @objc dynamic var baseValue: Double = 1.0

    override static func primaryKey() -> String? {
        return "id"
    }

    public required convenience init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.timestamp = try container.decodeIfPresent(Int64.self, forKey: .timestamp) ?? 0
        self.base = try container.decodeIfPresent(String.self, forKey: .base) ?? ""
        self.date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""

        let json: [String: Double] = try container.decode([String: Double].self, forKey: .rates)

        let rates = json.map { (key, value) -> Rate in
            let rate = Rate(name: key, value: value)
            return rate
        }
        ratesList.append(objectsIn: rates)

        for _ in 1...Converter.exchangeCount {
            currenciesList.append(FixerAPI.defaultCurrency)
        }
    }

    enum CodingKeys: String, CodingKey {
        case success
        case timestamp
        case base
        case rates
        case date
        case participants
    }
}
