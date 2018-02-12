//
//  RandFactory.swift
//  RandMyModel
//
//  Created by 郭介騵 on 2018/1/24.
//  Copyright © 2018年 james12345. All rights reserved.
//

import UIKit

// to new json & use Encoding to instance
class RandExtractor<T: Codable> {
    
    var delegate: RandMyModDelegate?
    
    init(delegate: RandMyModDelegate?) {
        self.delegate = delegate
    }
    
    func extractFromDictionary(_ dictionary: [String: Any]) -> T? {
        guard let newDicionary = RandFactory(dictionary, "Root", delegate: delegate).randData() as? [String: Any] else { return nil }
        let jsonData = try! JSONSerialization.data(withJSONObject: newDicionary, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let newinstance = try! decoder.decode(T.self, from: jsonData)
        return newinstance
    }
}

//Check a variable is pure(Randomable) or not
class RandFactory {
    
    let originKey: String
    let originValue:Any
    var delegate: RandMyModDelegate?
    
    init(_ base:Any ,_ key: String, delegate: RandMyModDelegate?) {
        self.originKey = key
        originValue = base
        self.delegate = delegate
    }
    
    public func randData() -> Any {
        switch originValue {
        case is String:
            return RandCore(.string).randValue()
        case is [String]:
            return RandCore(.string).randArray()
        case is Int:
            return RandCore(.int).randValue()
        case is [Int]:
            print("Int Arr")
            return RandCore(.int).randArray()
        case is Double:
            return RandCore(.double).randValue()
        case is [Double]:
            return RandCore(.double).randArray()
        case is Float:
            return RandCore(.float).randValue()
        case is [Float]:
            return RandCore(.float).randArray()
        case is CGFloat:
            return RandCore(.cgfloat).randValue()
        case is [CGFloat]:
            return RandCore(.cgfloat).randArray()
        case is [String: Any]:  //Maybe is the variable I don't know
            var dictionary = originValue as! [String: Any]
            for (_, value) in dictionary.enumerated() {
                if let delegate = delegate {
                    if delegate.shouldIgnore(for: value.key, in: originKey) {
                        continue
                    }
                }
                let factory = RandFactory(value.value, value.key, delegate: delegate).randData()
                dictionary.updateValue(factory, forKey: value.key)
            }
            return dictionary
        default:
            let mirror = Mirror(reflecting: originValue)
            let type = mirror.subjectType
            let judgementString = "\(type)"
            
            ///if variable is nullable, can use this to check
            if judgementString.contains("Optional") {
                if judgementString.contains("String") {
                    return judgementString.contains("Array") ? RandCore(.string).randArray() : RandCore(.string).randValue()
                } else if judgementString.contains("Int") {
                    return judgementString.contains("Array") ? RandCore(.int).randArray() : RandCore(.int).randValue()
                } else if judgementString.contains("Double") {
                    return judgementString.contains("Array") ? RandCore(.double).randArray() : RandCore(.double).randValue()
                } else if judgementString.contains("Float") {
                    return judgementString.contains("Array") ? RandCore(.float).randArray() : RandCore(.float).randValue()
                } else if judgementString.contains("CGFloat") {
                    return judgementString.contains("Array") ? RandCore(.cgfloat).randArray() : RandCore(.cgfloat).randValue()
                }
            }
        }
        return 0
    }
}
