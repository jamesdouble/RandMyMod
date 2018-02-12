//
//  ViewController.swift
//  RandMyModel
//
//  Created by 郭介騵 on 2018/1/17.
//  Copyright © 2018年 james12345. All rights reserved.
//

import UIKit
import Fakery

class Man: Codable {
    var name: String = ""
    var address: String = ""
    var website: [String] = []
    var child: Child = Child()
}

extension Man: RandMyModDelegate {
    
    func shouldIgnore(for key: String, in Container: String) -> Bool {
        print(Container+key)
        switch (Container, key) {
        case ("child","name"):
            return true
        default:
            return false
        }
    }
    
    func specificRandType(for Key: String, in Container: String, with RandGenerator: Faker) -> Any? {
        switch (Container, Key) {
        case ("Root","name"):
            return RandGenerator.name.name()
        case ("Root","address"):
            return RandGenerator.address.streetName()
        case ("toy","weight"):
            return RandGenerator.number.randomDouble()
        default:
            return nil
        }
    }
    
}
struct Child: Codable {
    var name: String = "Baby"
    var age: Int = 2
    var toy: Toys = Toys()
}

class Toys: Codable {
    var weight: Double = 0.0
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        RandMyMod<Man>().randMe(baseOn: Man()) { (newInstance) in
            guard let instance = newInstance else { fatalError() }
            print(instance)
        }
    }
}
