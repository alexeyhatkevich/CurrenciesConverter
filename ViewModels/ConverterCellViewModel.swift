//
//  ConverterCellViewModel.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum CurrencyDirection: Int {
    case from = 0
    case to
}

final class ConverterCellViewModel {
    var currency: Currency
    var currencyDirection: CurrencyDirection

    private var storage: Storage

    var value = BehaviorRelay<Double>(value: 0)
    private var currentBaseValue: Double = 0

    var rates: [Rate] {
        return currency.rates
    }

    private let disposeBag = DisposeBag()

    init(currency: Currency, currencyDirection: CurrencyDirection, storage: Storage) {
        self.currency = currency
        self.currencyDirection = currencyDirection
        self.storage = storage

        bindModel()
    }

    @objc func changeCurrencyValue() {
        storage.updateCurrencyValue(currency, baseValue: currentBaseValue)
    }

    func currencyName(for index: Int) -> String {
        if index >= currency.currencies.count {
            return "ERROR"
        }
        return currency.currencies[index]
    }

    private func bindModel() {
        value
            .skip(1)
            .subscribe(onNext: { [weak self] value in
                self?.currentBaseValue = value
            })
            .disposed(by: disposeBag)
    }
}
