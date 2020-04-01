//
//  Rate.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation
import RealmSwift

final class Rate: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var value: Double = 0

    required convenience init(name: String, value: Double) {
        self.init()

        self.name = name
        self.value = value
    }
}
