import Foundation

@objc public class NordicDFU: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
