import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true


// Part 1. Function that Does some calculation and updates the UI

// 1. Use a global queue
let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
let mainQueue = dispatch_get_main_queue()

// 2. Create your own queue
let workerQueue = dispatch_queue_create("com.raywenderlich.worker", DISPATCH_QUEUE_SERIAL)


// 3. Get queue name
func currentQueueName() -> String? {
  let label = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)
  return String(CString: label, encoding: NSUTF8StringEncoding)
}

let currentQueue = currentQueueName()
print(currentQueue)


// 3. Dispatch work asynchronously
print("=== Sending asynchronously to Worker Queue ===")
dispatch_async(workerQueue) {
  print("=== ASYNC:: Executing on \(currentQueueName()) ===")
}
print("=== Completed sending asynchronously to worker queue ===\n")



// 4. Dispatch work synchronously
print("=== Sending SYNChronously to Worker Queue ===")
dispatch_sync(workerQueue) {
  print("=== SYNC:: Executing on \(currentQueueName()) ===")
}
print("=== Completed sending synchronously to worker queue ===\n")



// 5: Concurrent or serial
func doComplexWork() {
  sleep(1)
  print("\(stopClock()) :: \(currentQueueName()) :: Done!")
}

startClock()
print(" === Starting Serial ===")
dispatch_async(workerQueue, doComplexWork)
dispatch_async(workerQueue, doComplexWork)
dispatch_async(workerQueue, doComplexWork)
dispatch_async(workerQueue, doComplexWork)

sleep(5)

let concurrentQueue = dispatch_queue_create("com.raywenderlich.concurrent", DISPATCH_QUEUE_CONCURRENT)

startClock()
print("\n === Starting concurrent ===")
dispatch_async(concurrentQueue, doComplexWork)
dispatch_async(concurrentQueue, doComplexWork)
dispatch_async(concurrentQueue, doComplexWork)
dispatch_async(concurrentQueue, doComplexWork)

sleep(5)

// Challenge 1: Change sync slowSum(Int,Int) -> Int into an async function

print("=== Starting Sync ===")
let result = slowSum(1, rhs: 2)
print("Sync Result = \(result)")



print("=== Starting Async ===")

func asyncSum(input: (Int, Int), completion:(Int) -> ()) {
  dispatch_async(workerQueue) {
    let result = slowSum(input.0, rhs: input.1)
    dispatch_async(dispatch_get_main_queue()) {
      completion(result)
    }
  }
}

asyncSum((1,2)) {
  result in
  print("Async Result = \(result)")
  XCPlaygroundPage.currentPage.finishExecution()
}

print("=== End of File ===")
