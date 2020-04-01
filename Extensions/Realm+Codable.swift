//
//  Eealm+Codable.swift
//  sam-app-ios
//
//  Created by Dmitry on 5/3/19.
//  Copyright © 2019 Aliaksei Khatkevich. All rights reserved.
//

import RealmSwift

extension List: Decodable where Element: Decodable {
    public convenience init(from decoder: Decoder) throws {
        self.init()
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            let element = try container.decode(Element.self)
            self.append(element)
        }
    }
}

extension List: Encodable where Element: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self {
            try element.encode(to: container.superEncoder())
        }
    }
}
