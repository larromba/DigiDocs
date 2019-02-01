import Foundation

protocol MainViewStating {
    var appVersion: String { get }
    var isLoading: Bool { get }
    var isUserInteractionEnabled: Bool { get }
    var isListButtonEnabled: Bool { get }
    var badgeNumber: Int { get }

    func copy(badgeNumber: Int) -> MainViewStating
    func copy(isLoading: Bool) -> MainViewStating
}

struct MainViewState: MainViewStating {
    let appVersion: String = Bundle.appVersion
    let isLoading: Bool
    var isUserInteractionEnabled: Bool {
        return !isLoading
    }
    var isListButtonEnabled: Bool {
        return badgeNumber > 0
    }
    let badgeNumber: Int
}

extension MainViewState {
    func copy(badgeNumber: Int) -> MainViewStating {
        return MainViewState(isLoading: isLoading, badgeNumber: badgeNumber)
    }

    func copy(isLoading: Bool) -> MainViewStating {
        return MainViewState(isLoading: isLoading, badgeNumber: badgeNumber)
    }
}
