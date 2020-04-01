//
//  CurrencySelectorModel.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation
import RealmSwift

final class CurrencySelectorModel {
    private var currency: Currency
    private var storage: Storage
    private var index: Int

    init(storage: Storage, currency: Currency, index: Int) {
        self.storage = storage
        self.currency = currency
        self.index = index
    }

    var currencyName: String {
        return currency.currencies[index]
    }

    var rates: [Rate] {
        return currency.rates
    }

    func updateCurrency(with name: String) {
        storage.updateCurrency(currency, index: index, name: name)
    }
}
