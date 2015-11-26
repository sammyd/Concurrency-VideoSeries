//: [Previous](@previous)

import Foundation
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

class Person {
  private var firstName: String
  private var lastName: String
  
  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
  
  func changeName(firstName firstName: String, lastName: String) {
    randomDelay(0.1)
    self.firstName = firstName
    randomDelay(1)
    self.lastName = lastName
  }
  
  var name: String {
    return "\(firstName) \(lastName)"
  }
}


let nameList = [("Brian", "Biggles"), ("Charlie", "Cheesecake"), ("Delia", "Dingle"), ("Eva", "Evershed"), ("Freddie", "Frost")]


let workerQueue = dispatch_queue_create("com.raywenderlich.worker", DISPATCH_QUEUE_CONCURRENT)
let nameChangeGroup = dispatch_group_create()

let nameChangingPerson = Person(firstName: "Anna", lastName: "Adams")

for name in nameList {
  dispatch_group_async(nameChangeGroup, workerQueue) {
    nameChangingPerson.changeName(firstName: name.0, lastName: name.1)
    print(nameChangingPerson.name)
  }
}

dispatch_group_notify(nameChangeGroup, dispatch_get_main_queue()) {
  print("Final name: \(nameChangingPerson.name)")
}





let threadSafeNameGroup = dispatch_group_create()

class ThreadSafePerson: Person {
  
  let isolationQueue = dispatch_queue_create("com.raywenderlich.person.isolation", DISPATCH_QUEUE_CONCURRENT)
  
  override func changeName(firstName firstName: String, lastName: String) {
    dispatch_barrier_async(isolationQueue) {
      super.changeName(firstName: firstName, lastName: lastName)
    }
  }
  
  override var name: String {
    var result = ""
    dispatch_sync(isolationQueue) {
      result = super.name
    }
    return result
  }
}

let threadSafePerson = ThreadSafePerson(firstName: "Anna", lastName: "Adams")

for name in nameList {
  dispatch_group_async(threadSafeNameGroup, workerQueue) {
    threadSafePerson.changeName(firstName: name.0, lastName: name.1)
    print(threadSafePerson.name)
  }
}

dispatch_group_notify(threadSafeNameGroup, dispatch_get_main_queue()) {
  print("Final threadsafe name: \(threadSafePerson.name)")
  //XCPlaygroundPage.currentPage.finishExecution()
}



// Challenge?

// Make the following threadsafe

class Number {
  var value: Int
  var name: String
  
  init(value: Int, name: String) {
    self.value = value
    self.name = name
  }
  
  func changeNumber(value: Int, name: String) {
    randomDelay(0.1)
    self.value = value
    randomDelay(0.5)
    self.name = name
  }
  
  var number: String {
    return "\(value) :: \(name)"
  }
}

let numberGroup = dispatch_group_create()
let numberArray = [(1, "one"), (2, "two"), (3, "three"), (4, "four"), (5, "five"), (6, "six")]

let changingNumber = Number(value: 0, name: "zero")

for pair in numberArray {
  dispatch_group_async(numberGroup, workerQueue) {
    changingNumber.changeNumber(pair.0, name: pair.1)
    print("Current number: \(changingNumber.number)")
  }
}

dispatch_group_notify(threadSafeNameGroup, dispatch_get_main_queue()) {
  print("Final number: \(changingNumber.number)")
  XCPlaygroundPage.currentPage.finishExecution()
}



//: [Next](@next)
