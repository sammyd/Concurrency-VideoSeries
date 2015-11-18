/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class LoadAndFilterImageOperation: NSOperation {
  let imageName: String
  let completion: (UIImage?) -> ()
  
  init(imageName: String, completion: (UIImage?) -> ()) {
    self.imageName = imageName
    self.completion = completion
    super.init()
  }
  
  override func main() {
    guard let url = NSBundle.mainBundle().URLForResource(imageName, withExtension: "") else { return }
    
    // Create temporary buffers for operation results
    var dataBuffer: NSData?
    var imageBuffer: UIImage?
    
    // Create the separate operations
    let dataLoad = DataLoadOperation(url: url) {
      uncompressedData in
      dataBuffer = uncompressedData
    }
    
    let imageDecompress = ImageDecompressionOperation(data: dataBuffer) {
      image in
      imageBuffer = image
    }
    
    let tiltShift = TiltShiftOperation(image: imageBuffer) {
      image in
      self.completion(image)
    }
    
    // Add operation dependencies
    imageDecompress.addDependency(dataLoad)
    tiltShift.addDependency(imageDecompress)
    
    NSOperationQueue.currentQueue()?.addOperations([dataLoad, imageDecompress, tiltShift], waitUntilFinished: true)
    
  }
}
