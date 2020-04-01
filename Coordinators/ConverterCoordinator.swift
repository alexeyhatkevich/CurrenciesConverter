//
//  ConverterCoordinator.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation
import UIKit

final class ConverterCoordinator: Coordinator {
    override func start() {
        super.start()

        let model = ConverterModel()
        let viewModel = ConverterViewModel(model: model, coordinator: self)
        let viewController = R.storyboard.converterViewController.converterViewControllerID()!
        viewController.viewModel = viewModel
        self.navigationController?.setViewControllers([viewController], animated: false)
    }

    func showCurrencySelector(storage: Storage, currency: Currency, index: Int) {
        let converterCoordinator = CurrencySelectorCoordinator(navigationController: navigationController, storage: storage, currency: currency, index: index)
        converterCoordinator.start()
    }
}
