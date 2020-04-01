//
//  Storage.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxCocoa
import RxSwift

final class Storage {
    private var itemRelay = BehaviorRelay<Currency?>(value: nil)

    init() {
        itemRelay.accept(loadItemFromBase())
    }

    func itemObservable() -> Observable<Currency?> {
        return itemRelay.asObservable()
    }

    func append(_ item: Currency) {
        saveToBase(item)
        itemRelay.accept(loadItemFromBase())
    }

    func updateCurrency(_ item: Currency, index: Int, name: String) {
        _updateCurrency(item, index: index, name: name)
        itemRelay.accept(loadItemFromBase())
    }

    func updateCurrencyValue(_ currency: Currency, baseValue: Double) {
        _updateCurrencyValue(currency, baseValue: baseValue)
        itemRelay.accept(loadItemFromBase())
    }
}

private extension Storage {
    func _updateCurrencyValue(_ currency: Currency, baseValue: Double) {
        do {
            let realm = try Realm()
            try realm.write {
                currency.baseValue = baseValue
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func _updateCurrency(_ currency: Currency, index: Int, name: String) {
        do {
            let realm = try Realm()
            try realm.write {
                currency.replace(name: name, at: index)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func loadItemFromBase() -> Currency? {
        do {
            let realm = try Realm()
            let items = realm.objects(Currency.self)
            return items.last
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }

    func saveToBase(_ item: Currency) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(item, update: .modified)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
