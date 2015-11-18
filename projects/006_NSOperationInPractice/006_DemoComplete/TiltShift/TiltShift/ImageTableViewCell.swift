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

class ImageTableViewCell: UITableViewCell {
  
  var imageLoadQueue: NSOperationQueue?
  
  var tiltShiftImage: TiltShiftImage? {
    didSet {
      if let tiltShiftImage = tiltShiftImage {
        titleLabel.text = tiltShiftImage.title
        loadImage(tiltShiftImage)
      }
    }
  }
  private var imageLoadOperation: LoadAndFilterImageOperation?
  
  @IBOutlet var tsImageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  
  override func prepareForReuse() {
    imageLoadOperation?.cancel()
    tsImageView.image = nil
  }
  
  private func loadImage(tsImage: TiltShiftImage) {
    imageLoadOperation?.cancel()
    let loadOp = LoadAndFilterImageOperation(imageName: tsImage.imageName) {
      image in
      NSOperationQueue.mainQueue().addOperationWithBlock {
        self.tsImageView.image = image
      }
    }
    imageLoadOperation = loadOp
    
    imageLoadQueue?.addOperation(loadOp)
  }
}
