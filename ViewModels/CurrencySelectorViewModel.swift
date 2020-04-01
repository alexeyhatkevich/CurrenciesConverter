//
//  CurrencySelectorViewModel.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation

class CurrencySelectorViewModel {
    private var coordinator: CurrencySelectorCoordinator?
    private var model: CurrencySelectorModel!

    var selectedRateName: String = ""

    var scrollIndex: Int? {
        return sortedRates.firstIndex { (rate) -> Bool in
            return rate.name == title
        }
    }

    init(model: CurrencySelectorModel, coordinator: CurrencySelectorCoordinator) {
        self.model = model
        self.coordinator = coordinator
    }

    var sortedRates: [Rate] {
        return model.rates.sorted { $0.name < $1.name }
    }

    var title: String {
        return model.currencyName
    }

    func rateNameSelected() {
        model.updateCurrency(with: selectedRateName)
        coordinator?.finish()
    }
}
