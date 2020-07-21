import UIKit

// sourcery: name = AppRouter
protocol AppRouting {
    // 🦄
}

final class AppRouter: AppRouting {
    let homeCoordinator: HomeCoordinating

    init(homeCoordinator: HomeCoordinating) {
        self.homeCoordinator = homeCoordinator
    }
}
