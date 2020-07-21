import Foundation

// sourcery: name = App
protocol Appable {
    // 🦄
}

final class App: Appable {
    private let router: AppRouting

    init(router: AppRouting) {
        self.router = router
    }
}
