import Foundation
import XCPlayground
import Compressor

let outputURL = XCPlaygroundSharedDataDirectoryURL.URLByAppendingPathComponent("dark_road_small.compressed")

//let inputImage = NSImage(named: "dark_road_small.jpg")!
let imagePath = NSBundle.mainBundle().pathForResource("dark_road_small", ofType: "jpg")

let imageData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("dark_road_small", ofType: "jpg")!)

//Compressor.saveDataAsCompressedFile(imageData!, path: outputURL.path!)

let uncompressed = Compressor.loadCompressedFile(NSBundle.mainBundle().pathForResource("dark_road_small", ofType: "compressed")!)
let image = UIImage(data: uncompressed!)