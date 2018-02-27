//
//  RandFactory.swift
//  RandMyModel
//
//  Created by 郭介騵 on 2018/1/24.
//  Copyright © 2018年 james12345. All rights reserved.
//

import UIKit

// to json & use Encoding to instance
class RandExtractor<T: Codable> {
    
    var delegate: RandMyModDelegate?
    
    init(delegate: RandMyModDelegate?) {
        self.delegate = delegate
    }
    
    func extractFromDictionary(_ dictionary: [String: Any]) -> T? {
        guard let newDicionary = RandFactory(dictionary, "Root", specificBlock: nil, delegate: delegate).randData() as? [String: Any] else { return nil }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: newDicionary, options: .prettyPrinted)
            let decoder = JSONDecoder()
            let newinstance = try decoder.decode(T.self, from: jsonData)
            return newinstance
        } catch {
            delegate?.catchError(with: error.localizedDescription)
            return nil
        }
    }
}

//Check a variable is pure(Randomable) or not
class RandFactory {
    
    let originKey: String
    let originValue:Any
    var delegate: RandMyModDelegate?
    let randCore: RandCore
    
    init(_ base:Any ,_ key: String ,specificBlock: (()->Any)? ,delegate: RandMyModDelegate?) {
        self.originKey = key
        self.originValue = base
        self.delegate = delegate
        let count = delegate?.countForArray(for: key) ?? -1
        self.randCore = RandCore(count, specificBlock: specificBlock)
    }
    
    public func randData() -> Any {
        switch originValue {
        case is String:
            return randCore.randValue(type: .string)
        case is [String]:
            return randCore.randArray(type: .string)
        case is Int:
            return randCore.randValue(type: .int)
        case is [Int]:
            return randCore.randArray(type: .int)
        case is Double:
            return randCore.randValue(type: .double)
        case is [Double]:
            return randCore.randArray(type: .double)
        case is Float:
            return randCore.randValue(type: .float)
        case is [Float]:
            return randCore.randArray(type: .float)
        case is CGFloat:
            return randCore.randValue(type: .cgfloat)
        case is [CGFloat]:
            return randCore.randArray(type: .cgfloat)
        case is [String: Any]:
            var dictionary = originValue as! [String: Any]
            var specificBlock: (()->Any)?
            for (_, variable) in dictionary.enumerated() {
                if let delegate = delegate {
                    if delegate.shouldIgnore(for: variable.key, in: originKey) {
                        continue
                    }
                    //Specific Type
                    specificBlock = delegate.specificRandType(for: variable.key, in: self.originKey, with: randCore.faker)
                }
                let factory = RandFactory(variable.value, variable.key, specificBlock: specificBlock, delegate: delegate).randData()
                dictionary.updateValue(factory, forKey: variable.key)
            }
            return dictionary
        default:
            let mirror = Mirror(reflecting: originValue)
            let type = mirror.subjectType
            let judgementString = "\(type)"
            
            ///if variable is nullable, can use this to check
            if judgementString.contains("Optional") {
                if judgementString.contains("String") {
                    return judgementString.contains("Array") ? randCore.randArray(type: .string) : randCore.randValue(type: .string)
                } else if judgementString.contains("Int") {
                    return judgementString.contains("Array") ? randCore.randArray(type: .int) : randCore.randValue(type: .int)
                } else if judgementString.contains("Double") {
                    return judgementString.contains("Array") ? randCore.randArray(type: .double) : randCore.randValue(type: .double)
                } else if judgementString.contains("Float") {
                    return judgementString.contains("Array") ? randCore.randArray(type: .float) : randCore.randValue(type: .float)
                } else if judgementString.contains("CGFloat") {
                    return judgementString.contains("Array") ? randCore.randArray(type: .cgfloat) : randCore.randValue(type: .cgfloat)
                }
            }
        }
        return 0
    }
}
