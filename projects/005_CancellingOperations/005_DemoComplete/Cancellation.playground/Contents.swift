import UIKit
import XCPlayground


XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

class ArraySumOperation: NSOperation {
  let inputArray: [(Int, Int)]
  var outputArray = [Int]()
  
  init(input: [(Int, Int)]) {
    inputArray = input
    super.init()
  }
  
  override func main() {
    for pair in inputArray {
      if cancelled { return }
      outputArray.append(slowAdd(pair))
    }
  }
}


class AnotherArraySumOperation: NSOperation {
  let inputArray: [(Int, Int)]
  var outputArray: [Int]?
  
  init(input: [(Int, Int)]) {
    inputArray = input
    super.init()
  }
  
  override func main() {
    outputArray = slowAddArray(inputArray) {
      _ in
      return !self.cancelled
    }
  }
}


let numberArray = [(1,2), (3,4), (5,6), (7,8), (9,10)]

let sumOperation = AnotherArraySumOperation(input: numberArray)

let queue = NSOperationQueue()

startClock()
queue.addOperation(sumOperation)

sumOperation.cancel()

queue.waitUntilAllOperationsAreFinished()
stopClock()

sumOperation.outputArray

XCPlaygroundPage.currentPage.finishExecution()


