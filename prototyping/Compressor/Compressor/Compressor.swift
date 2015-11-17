import Foundation

public struct Compressor {
  public static func loadCompressedFile(path: String) -> NSData? {
    return NSData(contentsOfArchive: path, compression: .LZMA)
  }
  
  public static func saveDataAsCompressedFile(data: NSData, path: String) -> Bool {
    guard let compressedData = data.compressedDataUsingCompression(.LZMA) else { return false
    }
    print("compressed!")
    return compressedData.writeToFile(path, atomically: true)
  }
} 