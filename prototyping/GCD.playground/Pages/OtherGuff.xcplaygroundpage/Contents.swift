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

//onceDemo()
//onceDemo()
//onceDemo()
//onceDemo()




class CrapCache {
  private lazy var store: [String : String]? = self.loadStoreFromDisc()
  
  func getValueForKey(key: String) -> String? {
    return store?[key]
  }
  
  func setValueForKey(key: String, value: String) {
    store?[key] = value
  }
  
  private func loadStoreFromDisc() -> [String : String] {
    print("Loading cache from disc...")
    randomDelay(5)
    return [
      "banana" : "yellow",
      "orange" : "orange",
      "apple" : "green"
    ]
  }
}

let cache = CrapCache()

let workerQueue = dispatch_queue_create("com.raywenderlich.cacheQueue", DISPATCH_QUEUE_CONCURRENT)

dispatch_async(workerQueue) { print(cache.getValueForKey("apple")) }
dispatch_async(workerQueue) { print(cache.getValueForKey("banana")) }

/*
class BetterCache {
  private var onceToken: dispatch_once_t = 0
  private var _store: [String : String]?
  private var store: [String : String]? {
    dispatch_once(&onceToken) {
      self._store = self.loadStoreFromDisc()
    }
    return self._store
  }
  
  func getValueForKey(key: String) -> String? {
    return store?[key]
  }
  
  private func loadStoreFromDisc() -> [String : String] {
    print("Loading cache from disc...")
    randomDelay(5)
    return [
      "banana" : "yellow",
      "orange" : "orange",
      "apple" : "green"
    ]
  }
}

let betterCache = BetterCache()

dispatch_async(workerQueue) { print(betterCache.getValueForKey("apple")) }
dispatch_async(workerQueue) { print(betterCache.getValueForKey("banana")) }




// dispatch_after

func delay(delay: Double, closure: () -> ()) {
  let startTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
  dispatch_after(startTime, dispatch_get_main_queue(), closure)
}


class Pollster {
  let callback: (String) -> ()
  private var active: Bool = false
  private let isoloationQueue = dispatch_queue_create("com.raywenderlich.pollster.isolation", DISPATCH_QUEUE_SERIAL)
  
  init(callback: (String) -> ()) {
    self.callback = callback
  }
  
  
  func start() {
    active = true
    dispatch_async(isoloationQueue) {
      self.makeRequest()
    }
  }
  
  func stop() {
    active = false
  }
  
  private func makeRequest() {
    if active {
      callback("\(NSDate())")
      let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1))
      dispatch_after(dispatchTime, isoloationQueue) {
        self.makeRequest()
      }
    }
  }
}


let pollster = Pollster(callback: { print($0) })

pollster.start()

delay(5) {
  pollster.stop()
  print("Stop polling")
  delay(2) {
    print("Finished")
    XCPlaygroundPage.currentPage.finishExecution()
  }
}
*/


//: [Next](@next)
