//: [Previous](@previous)

import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

// dispatch_once

var token: dispatch_once_t = 0
func onceDemo() {
  dispatch_once(&token) {
    print("Performing setup the first time this is ever run")
  }
  print("Runs every time")
}

onceDemo()
onceDemo()
onceDemo()
onceDemo()





//: [Next](@next)
