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
    let arrCount: Int
    var specificBlock: (()->Any)?
    
    init(_ arrCount: Int, specificBlock: (()->Any)?) {
        self.arrCount = arrCount > 0 ? arrCount : faker.number.randomInt(min: 1, max: 10)
        self.specificBlock = specificBlock
    }
    
    func randValue(type: RandableType) -> Any {
        if let speciBlock = self.specificBlock {
            let specificValue = speciBlock()
            return specificValue
        }
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
    
    func randArray(type: RandableType) -> [Any] {
        var result: [Any] = []
        for _ in 0..<arrCount {
            result.append(randValue(type: type))
        }
        return result
    }
    
}

