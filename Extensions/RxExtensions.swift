//
//  RxExtensions.swift
//  CurrenciesConverter
//
//  Created by Aliaksei Khatkevich.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    /// Cast `Optional<Wrapped>` to `Wrapped?`
    public var value: Wrapped? {
        return self
    }
}

public extension ObservableType where E: OptionalType {
    func filterNil() -> Observable<E.Wrapped> {
        return flatMap { (element) -> Observable<E.Wrapped> in
            guard let item = element.value else {
                return Observable.empty()
            }
            return Observable.just(item)
        }
    }
}
