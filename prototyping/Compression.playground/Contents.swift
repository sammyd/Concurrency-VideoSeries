import Foundation
import XCPlayground
import Compressor


let filename = "sample_09"

let outputURL = XCPlaygroundSharedDataDirectoryURL.URLByAppendingPathComponent("\(filename).compressed")

//let inputImage = NSImage(named: "dark_road_small.jpg")!
//let imagePath = NSBundle.mainBundle().pathForResource("dark_road_small", ofType: "jpg")

let imageData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource(filename, ofType: "jpg")!)

Compressor.saveDataAsCompressedFile(imageData!, path: outputURL.path!)

//let uncompressed = Compressor.loadCompressedFile(NSBundle.mainBundle().pathForResource("dark_road_small", ofType: "compressed")!)
//let image = UIImage(data: uncompressed!)
