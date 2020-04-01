//
//  CurrencySelectorViewController.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import UIKit

class CurrencySelectorViewController: UIViewController {
    @IBOutlet private weak var picker: UIPickerView!

    var viewModel: CurrencySelectorViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let index = viewModel.scrollIndex {
            picker.selectRow(index, inComponent: 0, animated: true)
        }
    }

    @IBAction func save() {
        viewModel.rateNameSelected()
    }
}

extension CurrencySelectorViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.sortedRates.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let rate = viewModel.sortedRates[row]
        return rate.name
    }
}

extension CurrencySelectorViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedRateName = viewModel.sortedRates[row].name
    }
}
