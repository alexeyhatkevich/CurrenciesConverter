//
//  ConverterViewModel.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol ConverterViewModelNetworkErrorProtocol {
    func processNetworkError(_ error: Error)
}

final class ConverterViewModel {
    let items = BehaviorRelay<[ConverterCellViewModel]?>(value: nil)

    private weak var coordinator: ConverterCoordinator?
    private var model: ConverterModel!
    private let disposeBag = DisposeBag()

    init(model: ConverterModel, coordinator: ConverterCoordinator) {
        self.model = model
        self.coordinator = coordinator
        bindModel()
    }

    func refresh() {
        model.refreshItem()
            .subscribe()
            .disposed(by: disposeBag)
    }

    func bindModel() {
        model.itemObvservable()
            .observeOn(MainScheduler.asyncInstance)
            .catchError({ [weak self] (error) -> Observable<Currency> in
                self?.processNetworkError(error)
                return Observable.never()
            })
            .map({ currency -> [ConverterCellViewModel] in
                var items: [ConverterCellViewModel] = []
                for direction in 0 ..< Converter.exchangeCount {
                    let currencyDirection = CurrencyDirection(rawValue: direction) ?? (direction == CurrencyDirection.from.rawValue ? .from : .to)
                    let item = ConverterCellViewModel(currency: currency,
                                                      currencyDirection: currencyDirection,
                                                      storage: self.model.storage)
                    items.append(item)
                }
                return items
            })
            .bind(to: items)
            .disposed(by: disposeBag)
    }

    func selectCell(at indexPath: IndexPath) {
        if let currency = items.value?[indexPath.row].currency {
            coordinator?.showCurrencySelector(storage: model.storage, currency: currency, index: indexPath.row)
        }
    }
}

extension ConverterViewModel: ConverterViewModelNetworkErrorProtocol {
    func processNetworkError(_ error: Error) {
        print(error.localizedDescription)
    }
}
