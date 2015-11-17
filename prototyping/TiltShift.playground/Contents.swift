//: Playground - noun: a place where people can play
import UIKit
import XCPlayground


let inputImage = UIImage(named: "dark_road_small.jpg")!

let mask = topAndBottomGradient(inputImage.size, clearLocations: [0.35, 0.65], innerIntensity: 0.8)


let blurred = inputImage.applyBlurWithRadius(3, maskImage: mask)




