//
//  ConverterCellView.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ConverterCellView: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueTextField: UITextField! {
        didSet {
            valueTextField.addDoneCancelToolbar(onDone: (target: self, action: #selector(done)),
                                                onCancel: (target: self, action: #selector(cancel)))
        }
    }

    var viewModel: ConverterCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        bindViewModel()
    }

    @objc private func done() {
        viewModel?.changeCurrencyValue()
    }

    @objc private func cancel() {
        resetCurrency()
        valueTextField.resignFirstResponder()
    }

    @objc private func resetCurrency() {
        guard let viewModel = viewModel else {
            return
        }

        let currencyName = viewModel.currencyName(for: viewModel.currencyDirection.rawValue)
        nameLabel.text = currencyName

        if let rate = currentRate() {
            let value = (rate.value * viewModel.currency.baseValue).roundTo(places: Converter.digitsRounded)
            valueTextField.text = "\(value)"
        }
    }

    private func currentRate() -> Rate? {
        guard let viewModel = viewModel else {
            return nil
        }
        let currencyName = viewModel.currencyName(for: viewModel.currencyDirection.rawValue)
        return viewModel.rates.first(where: { (rate) -> Bool in
            return rate.name == currencyName
        })
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }

        disposeBag = DisposeBag()

        valueTextField.rx.text
            .orEmpty
            .map({ [weak self] textValue -> Double in
                if let rateValue = self?.currentRate()?.value, let textValue = textValue.toDouble() {
                    return textValue / rateValue
                }
                return 0.0
            })
            .bind(to: viewModel.value)
            .disposed(by: disposeBag)

        valueTextField.rx.controlEvent(.editingDidEnd)
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.cancel()
            })
            .disposed(by: disposeBag)

        resetCurrency()
    }
}
