import Foundation

protocol MainViewStating {
    var appVersion: String { get }
    var isLoading: Bool { get }
    var isUserInteractionEnabled: Bool { get }
    var isListButtonEnabled: Bool { get }

    func copy(isListButtonEnabled: Bool) -> MainViewStating
    func copy(isLoading: Bool) -> MainViewStating
}

struct MainViewState: MainViewStating {
    let appVersion: String = Bundle.appVersion
    let isLoading: Bool
    var isUserInteractionEnabled: Bool {
        return !isLoading
    }
    let isListButtonEnabled: Bool
}

extension MainViewState {
    func copy(isListButtonEnabled: Bool) -> MainViewStating {
        return MainViewState(isLoading: isLoading,
                             isListButtonEnabled: isListButtonEnabled)
    }

    func copy(isLoading: Bool) -> MainViewStating {
        return MainViewState(isLoading: isLoading,
                             isListButtonEnabled: isListButtonEnabled)
    }
}
