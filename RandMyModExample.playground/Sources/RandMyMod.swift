//
//  RandMyMod.swift
//  RandMyModel
//
//  Created by 郭介騵 on 2018/1/18.
//  Copyright © 2018年 james12345. All rights reserved.
//

import Foundation
import Fakery

public protocol RandMyModDelegate {
    func countForArray(for key: String) -> Int
    func shouldIgnore(for key: String, in Container: String) -> Bool
    func catchError(with errorStr: String)
    func specificRandType(for key: String, in Container: String, with seed: RandType) -> (()->Any)?
}

public extension RandMyModDelegate {
    func shouldIgnore(for key: String, in Container: String) -> Bool {
        return false
    }
    
    func catchError(with errorStr: String) {
        
    }
    
    func countForArray(for key: String) -> Int {
        return -1
    }
}
public typealias RandType = Faker
public class RandMyMod<T: Codable> {
    
    public init(forceUnWrapOptional force: Bool = false) {
        
    }
    
    //Random Array
    public func randUs(amount: Int, baseOn instance: T, completion: ([T])->()) -> [T] {
        var result: [T] = []
        for _ in 0..<amount {
            randMe(baseOn: instance, completion: { (object) in
                if let element = object {
                    result.append(element)
                }
            })
        }
        return result
    }
    
    //Random Single
    public func randMe(baseOn instance: T, completion: (T?)-> ()) {
        /// Convert Variable To flat Dictionary
        let delegate = instance as? RandMyModDelegate
        do {
            let jsonData = try JSONEncoder().encode(instance)
            let jsonDic = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            guard let jsonDictionary = jsonDic as? [String: Any] else { completion(nil); return }
            let newinstance = RandExtractor<T>(delegate: delegate).extractFromDictionary(jsonDictionary)
            completion(newinstance)
            return
        } catch {
            delegate?.catchError(with: error.localizedDescription)
        }
    }
}
