//
//  CurrencySelectorCoordinator.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import UIKit

final class CurrencySelectorCoordinator: Coordinator {
    var storage: Storage
    var currency: Currency
    var index: Int

    override func start() {
        super.start()

        let model = CurrencySelectorModel(storage: storage, currency: currency, index: index)
        let viewModel = CurrencySelectorViewModel(model: model, coordinator: self)
        let viewController = R.storyboard.currencySelectorViewController.currencySelectorViewController()!
        viewController.viewModel = viewModel
        navigationController?.show(viewController, sender: self)
    }

    init(navigationController: UINavigationController?, parent: Coordinator? = nil, storage: Storage, currency: Currency, index: Int) {
        self.storage = storage
        self.currency = currency
        self.index = index

        super.init(navigationController: navigationController, parent: parent)
    }

    override func finish() {
        navigationController?.popViewController(animated: true)
        super.finish()
    }
}
