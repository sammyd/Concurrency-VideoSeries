//: Playground - noun: a place where people can play
import UIKit
import XCPlayground


let inputImage = UIImage(named: "dark_road_small.jpg")!

var result: Int?

let calculateSum = NSBlockOperation(block: {
  result = 2 + 3
  sleep(5)
})

result

var startTime = NSDate()
calculateSum.start()
NSDate().timeIntervalSinceDate(startTime)

result

let multiPrinter = NSBlockOperation()
multiPrinter.addExecutionBlock { print("Hello"); sleep(5) }
multiPrinter.addExecutionBlock { print("my"); sleep(5) }
multiPrinter.addExecutionBlock { print("name"); sleep(5) }
multiPrinter.addExecutionBlock { print("is"); sleep(5) }
multiPrinter.addExecutionBlock { print("sam"); sleep(5) }

startTime = NSDate()
multiPrinter.start()
NSDate().timeIntervalSinceDate(startTime)


class BlurOperation: NSOperation {
  var inputImage: UIImage?
  var outputImage: UIImage?
  
  override func main() {
    guard let inputImage = inputImage else { return }
    
    let mask = topAndBottomGradient(inputImage.size, clearLocations: [0.35, 0.65], innerIntensity: 0.8)
    outputImage = inputImage.applyBlurWithRadius(3, maskImage: mask)
  }
}

let blur = BlurOperation()
blur.inputImage = inputImage
blur.outputImage
startTime = NSDate()
blur.start()
NSDate().timeIntervalSinceDate(startTime)
blur.outputImage
