import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        guard 0..<count ~= index else { return nil }
        return self[index]
    }
}
