//: [Previous](@previous)


import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let workerQueue = dispatch_queue_create("com.raywenderlich.worker", DISPATCH_QUEUE_CONCURRENT)

func asyncSum(input: (Int, Int), queue: dispatch_queue_t, completion: (Int) -> ()) {
  dispatch_async(workerQueue) {
    let result = slowSum(input.0, rhs: input.1)
    dispatch_async(queue) {
      completion(result)
    }
  }
}

let numberArray = [(0,1), (2,3), (4,5), (6,7), (8,9)]

let firstGroup = dispatch_group_create()

for inValue in numberArray {
  dispatch_group_async(firstGroup, workerQueue) {
    let result = slowSum(inValue.0, rhs: inValue.1)
    //dispatch_group_async(firstGroup, dispatch_get_main_queue()) {
      print("Result = \(result)")
    //}
  }
}

dispatch_group_notify(firstGroup, dispatch_get_main_queue()) {
  print("Completed all operations in group")
}

// DANGER of synchronous dispatch
dispatch_group_wait(firstGroup, DISPATCH_TIME_FOREVER)
print("===Starting next group")

let secondGroup = dispatch_group_create()

//: Wrapping an existing API
func asyncSum(input: (Int, Int), queue: dispatch_queue_t, group: dispatch_group_t, completion: (Int) -> ()) {
  dispatch_group_enter(group)
  asyncSum(input, queue: queue) {
    completion($0)
    dispatch_group_leave(group)
  }
}

for pair in numberArray {
  asyncSum(pair, queue: workerQueue, group: secondGroup) {
    print("Result = \($0)")
  }
}

dispatch_group_notify(secondGroup, dispatch_get_main_queue()) {
  print("Completed all operations in group")
}



//: Challenge: Wrap another async function

extension UIView {
  static func animateWithDuration(duration: NSTimeInterval, animations: () -> Void, completionQueue: dispatch_queue_t, group: dispatch_group_t, completion: ((Bool) -> Void)?) {
    dispatch_group_enter(group)
    animateWithDuration(duration, animations: animations, completion: {
      success in
      dispatch_async(completionQueue) {
        completion?(success)
        dispatch_group_leave(group)
      }
    })
  }
}


let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.backgroundColor = UIColor.redColor()
let box = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
box.backgroundColor = UIColor.yellowColor()
view.addSubview(box)

XCPlaygroundPage.currentPage.liveView = view

let animationGroup = dispatch_group_create()

UIView.animateWithDuration(1, animations: {
  box.center = CGPoint(x: 180, y: 180)
  }, completionQueue: dispatch_get_main_queue(), group: animationGroup) {
    _ in
    UIView.animateWithDuration(2, animations: {
      box.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
      }, completionQueue: dispatch_get_main_queue(), group: animationGroup, completion: nil)
}

UIView.animateWithDuration(4, animations: { () -> Void in
  view.backgroundColor = UIColor.blueColor()
  }, completionQueue: dispatch_get_main_queue(), group: animationGroup, completion: nil)

dispatch_group_notify(animationGroup, dispatch_get_main_queue()) {
  print("Animations completed!")
  XCPlaygroundPage.currentPage.finishExecution()
}


//: [Next](@next)
