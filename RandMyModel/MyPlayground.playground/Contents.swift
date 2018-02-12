//: Playground - noun: a place where people can play

import UIKit


class RandCore {
    
    enum RandableType {
        case string
        case int
        case float
        case cgfloat
        case double
    }

    let type: RandableType
    
    init(_ type: RandableType) {
        self.type = type
    }
    
    func randValue() -> Any {
        switch type {
        case .string:
            return "randon"
        case .int:
            return 666
        case .float:
            return 666.0
        case .cgfloat:
            return 666.0
        case .double:
            return 666.0
        }
    }
    
    func randArray() -> [Any] {
        return [randValue(),randValue()]
    }
    
}


class RandFactory {
    
    let originValue:Any
    
    init(_ base:Any) {
        originValue = base
    }
    
    func randData() -> Any {
        switch originValue {
        case is String:
            return RandCore(.string).randValue()
        case is [String]:
            return RandCore(.string).randArray()
        case is Int:
            return RandCore(.int).randValue()
        case is [Int]:
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
            
            //May be something unRandable, Check if it is still a Codable or not
            if let stillCodable = originValue as? Codable {
                originValue.self
                //                RandMyMod<>().randMe(baseOn: originValue) { (newInstance) in
                //                    guard let instance = newInstance else { fatalError() }
                //                    print(instance)
                //                }
            }
        }
        return 0
    }
}

struct Mystruct: Codable {
    var name: String?
    var age: Int = 0
    var struct2: MyStruct2 = MyStruct2()
}

struct MyStruct2: Codable {
    var sub1: String = ""
    var sub2: Double = 0
}

let mystruct = Mystruct()
let jsonEncoder = JSONEncoder()
let jsonData = try jsonEncoder.encode(mystruct)
let jsonDic = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
let jsonDictionary = jsonDic as! [String: Any]
for (_, value) in jsonDictionary.enumerated() {
    let factory = RandFactory(value.value).randData()
    print("\(factory)")
}



