//: Playground - noun: a place where people can play

import UIKit

struct Man: Codable {
    var name: String = ""
    var age: Int = 40
    var website: [String] = []
    var child: Child = Child()
}

struct Child: Codable {
    var name: String = "Baby"
    var age: Int = 2
    var toy: Toys = Toys()
}

class Toys: Codable {
    var weight: Double = 0.0
}

extension Man: RandMyModDelegate {
    
    func shouldIgnore(for key: String, in Container: String) -> Bool {
        switch (key, Container) {
        case ("name","child"):
            return true
        default:
            return false
        }
    }
  
    func specificRandType(for key: String, in Container: String, with seed: RandType) -> (() -> Any)? {
        switch (key, Container) {
        case ("age","child"):
            return { return seed.number.randomInt(min: 1, max: 6)}
        case ("weight",_):
            return { return seed.number.randomFloat() }
        default:
            return nil
        }
    }
}

let man = Man()
RandMyMod<Man>().randMe(baseOn: man) { (newMan) in
    guard let child = newMan?.child else { print("no"); return }
    print(child)
    print(child.name)
    print(child.age)
    print(child.toy.weight)
}

RandMyMod<Man>().randUs(amount: 5, baseOn: man) { (newManArr) in

}




