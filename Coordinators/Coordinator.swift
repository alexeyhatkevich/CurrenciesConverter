//
//  Coordinator.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?, parent: Coordinator? = nil) {
        self.navigationController = navigationController
        self.parent = parent
    }

    private func append(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    private func remove(_ coordinator: Coordinator) {
        childCoordinators.removeAll { (coord) -> Bool in
            return coordinator === coord
        }
    }

    func start() {
        parent?.append(self)
    }

    func finish() {
        parent?.remove(self)
    }
}
