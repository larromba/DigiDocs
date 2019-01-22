import Foundation

protocol MainViewStating {
    var appVersion: String { get }
    var isLoading: Bool { get }
    var isUserInteractionEnabled: Bool { get }
    var isListButtonEnabled: Bool { get }

    func copy(isListButtonEnabled: Bool) -> MainViewStating
}

struct MainViewState: MainViewStating {
    let appVersion: String = Bundle.appVersion
    let isLoading: Bool
    let isUserInteractionEnabled: Bool
    let isListButtonEnabled: Bool
}

extension MainViewState {
    func copy(isListButtonEnabled: Bool) -> MainViewStating {
        return MainViewState(isLoading: isLoading,
                             isUserInteractionEnabled: isUserInteractionEnabled,
                             isListButtonEnabled: isListButtonEnabled)
    }
}
