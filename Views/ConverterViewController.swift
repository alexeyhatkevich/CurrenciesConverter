//
//  ConverterViewController.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class ConverterViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    var viewModel: ConverterViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.refresh()
    }

    func bindViewModel() {
        viewModel.items
            .bind(onNext: { [weak self] (_) in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension ConverterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value?.count ?? Converter.exchangeCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.currencyTableViewCell, for: indexPath)!
        if let item = viewModel.items.value?[indexPath.row] {
            cell.viewModel = item
        }

        return cell
    }
}

extension ConverterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        viewModel.selectCell(at: indexPath)
    }
}
