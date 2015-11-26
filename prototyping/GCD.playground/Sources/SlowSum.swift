import Foundation

public func slowSum(lhs: Int, rhs: Int) -> Int {
  sleep(1)
  return lhs + rhs
}