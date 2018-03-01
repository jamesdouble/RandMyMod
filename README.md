![Alt text](https://raw.githubusercontent.com/jamesdouble/RandMyMod/master/Readme_img/logo.png)

**RandMyMod** is an IOS Native Framework helps you generate one or a set of variable base on your own model.

No matter your model is Class / Struct.

![Alt text](https://img.shields.io/badge/SwiftVersion-4.0-red.svg?link=http://left&link=http://right)
![Alt text](https://img.shields.io/badge/IOSVersion-8.0+-green.svg)
![Alt text](https://img.shields.io/badge/BuildVersion-1.0.0-green.svg)
![Alt text](https://img.shields.io/badge/Author-JamesDouble-blue.svg?link=http://https://jamesdouble.github.io/index.html&link=http://https://jamesdouble.github.io/index.html)


## Installation
* Cocoapods

```
pod 'RandMyMod'
```

# Basic Usage

* ### Model must conform *Codable*

```swift
import RandMyMod
```

* **Create a Random Model**

	```swift
	let instance = MyStruct()
	RandMyMod<MyStruct>().randMe(baseOn: instance) { 
		(newInstance) in
    	guard let newinstance = newInstance else { print("error"); return }
    }
	```

* **Create a set of Random Model**

	```swift
	let instance = MyStruct()
	RandMyMod<MyStruct>().randUs(baseOn: instance) { 
		(newInstanceArr) in
    	for newInstance in newInstanceArr {
    		guard let newinstance = newInstance else { print("error"); return }
    	}
    }
	```
	
* **RandMyModDelegate**

	```swift
	public protocol RandMyModDelegate {
    	func countForArray(for key: String) -> Int
    	func shouldIgnore(for key: String, in Container: String) -> Bool
    	func catchError(with errorStr: String)
    	func specificRandType(for key: String, in Container: String, with seed: RandType) -> (()->Any)?
	}
	```

* **Swift fake data generator**

 	*vadymmarkov/Fakery : https://github.com/vadymmarkov/Fakery*
	
# Notice

1. if the variable in class / stuct is Declared with **『 let 』** , rand mod will not change this variable's value.

	```swift 
	struct MyStruct {
		let nochange: Int = 0
	}
	let mystruct = MyStruct()
	RandMyMod<MyStruct>().randMe(baseOn: mystruct) { (newstruct) in 
		newstruct.nochange  // 0
	}
	```
	
2. if the variable in class / stuct is Declared with **『 Optional 』** and ***have no initial Value*** , rand mod will ignore this variable's value and keep it nil.	(Mirror may resolve this issue, may fix in the future)

	```swift 
	struct MyStruct {
		var opt: Int? = 0
		var opt2: Int?
	}
	let mystruct = MyStruct()
	RandMyMod<MyStruct>().randMe(baseOn: mystruct) { (newstruct) in 
		mystruct.opt  // 4242
		mystruct.opt2 // nil
	}
	```
	
	
# Example

### 1. Stuct / Class with native variable type and no special specific:

```swift
	class Man: Codable {
    	var name: String = ""
    	var address: String = ""
    	var website: [String] = []
   	}
   	
   	let man = Man()
	RandMyMod<Man>().randMe(baseOn: man) { (newMan) in
    	guard let new = newMan else { return }
    	print(new.address) 	//mnxvpkalug
    	print(new.name) 	//iivjohpggb
    	print(new.website)	//["pbmsualvei", "vlqhlwpajf", "npgtxdmfyt"]
	}
	
```
	
### 2. Stuct / Class with native variable type and specific Rand Type:

```swift
struct Man: Codable {
    var name: String = ""
    var age: Int = 40
    var website: [String] = []
}

extension Man: RandMyModDelegate {
    
    func countForArray(for key: String) -> Int {
        switch key {
        case "website":
            return 3
        default:
            return 0
        }
    }
    
    func specificRandType(for key: String, in Container: String, with seed: RandType) -> (() -> Any)? {
        switch key {
        case "name":
            return { return seed.name.name() }
        case "age":
            return { return seed.number.randomInt(min: 1, max: 60)}
        case "website":
            return { return seed.internet.url() }
        default:
            return nil
        }   
    }
}

let man = Man()
RandMyMod<Man>().randMe(baseOn: man) { (newMan) in
    guard let new = newMan else { print("no"); return }
    print(new.age) 		//32
    print(new.name) 	//Lavada Krajcik
    print(new.website)	//["https://littleohara.name/johathangleason6379", "https://kautzerwunsch.biz/karleejones8880", "https://purdy.net/olivercorkery"]
}
```

### 3. Stuct / Class with own defined variable type and specific Rand Type:
	 
```swift 
struct Man: Codable {
    var name: String = ""
    var age: Int = 40
    var website: [String] = []
    var child: Child = Child()
}

struct Child: Codable {
    var name: String = "Baby" //Baby has no name yet.
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
    print(child.name)	//Baby
    print(child.age)	//3
    print(child.toy.weight)	//392.807067871094
}


```

# Distribution

Feel free to fork / pull request / open an issue.
	

