import UIKit

public func topAndBottomGradient(size: CGSize, clearLocations: [CGFloat], innerIntensity: CGFloat = 0.5) -> UIImage {

  let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), 8, 0, CGColorSpaceCreateDeviceGray(), CGImageAlphaInfo.None.rawValue)

  let colors = [
      UIColor.whiteColor(),
      UIColor(white: innerIntensity, alpha: 1.0),
      UIColor.blackColor(),
      UIColor(white: innerIntensity, alpha: 1.0),
      UIColor.whiteColor()
    ].map { $0.CGColor }
  let colorLocations : [CGFloat] = [0, clearLocations[0], (clearLocations[0] + clearLocations[1]) / 2.0, clearLocations[1], 1]
  
  let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceGray(), colors, colorLocations)
  
  let startPoint = CGPoint(x: 0, y: 0)
  let endPoint = CGPoint(x: 0, y: size.height)
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions())
  
  let cgImage = CGBitmapContextCreateImage(context)

  return UIImage(CGImage: cgImage!)
}
