//
//  ConverterModel.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Moya

class ConverterModel {
    var storage = Storage()

    let disposeBag = DisposeBag()

    func itemObvservable() -> Observable<Currency> {
        let webItem = fetchItemFromWeb().asObservable()
        let databaseItem = storage.itemObservable().filterNil()

        return databaseItem
            .flatMapLatest({ [weak self] currency -> Observable<Currency> in
                if let webNeed = self?.isNeedWeb(for: currency), webNeed {
                    return webItem
                        .catchError({ (error) -> Observable<Currency> in
                            print(error.localizedDescription)
                            return databaseItem
                        })
                }
                return databaseItem
            })
    }
}

extension ConverterModel {
    func refreshItem() -> Completable {
        return itemObvservable().asSingle().asCompletable()
    }

    func isNeedWeb(for currency: Currency) -> Bool {
        if let dbDate = currency.date.toDate(), let daysCount = Date().days(sinceDate: dbDate) {
            if daysCount >= 1 {
                return true
            }
        }
        return false
    }

    private func fetchItemFromWeb() -> Single<Currency> {
        return provider.rx
            .request(.latest)
            .map(Currency.self)
            .do(onSuccess: { [weak self] (currency) in
                self?.storage.append(currency)
                }, onError: { (error) in
                    print(error.localizedDescription)
            })

    }
}
