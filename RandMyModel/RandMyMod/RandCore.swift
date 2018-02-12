//
//  RandCore.swift
//  RandMyModel
//
//  Created by 郭介騵 on 2018/1/24.
//  Copyright © 2018年 james12345. All rights reserved.
//

import Foundation
import Fakery

class RandCore {
    
    enum RandableType {
        case string
        case int
        case float
        case cgfloat
        case double
    }
    let faker: Faker = Faker()
    let type: RandableType
    
    init(_ type: RandableType) {
        self.type = type
    }
    
    func randValue() -> Any {
        switch type {
        case .string:
            return faker.lorem.characters(amount: 10)
        case .int:
            return faker.number.randomInt()
        case .float:
            return faker.number.randomFloat()
        case .cgfloat:
            return faker.number.randomCGFloat()
        case .double:
            return faker.number.randomDouble()
        }
    }
    
    func randArray() -> [Any] {
        return [randValue(),randValue()]
    }
    
}
