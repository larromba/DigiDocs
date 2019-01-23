import Foundation

extension Bundle {
    static var appVersion: String {
        return "v\(main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?")"
    }
}
