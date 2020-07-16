import AsyncAwait
import Logging
import UIKit
import UserNotifications

protocol Badge: AnyObject, Mockable {
    var number: Int { get }

    // sourcery: returnValue = Async<Void, BadgeError>.success(())
    func setNumber(_ number: Int) -> Async<Void, BadgeError>
}

final class AppBadge: Badge {
    private let notificationCenter: UNUserNotificationCenter
    private let application: UIApplication
    var number: Int {
        return application.applicationIconBadgeNumber
    }

    init(notificationCenter: UNUserNotificationCenter = .current(), application: UIApplication = .shared) {
        self.notificationCenter = notificationCenter
        self.application = application
    }

    func setNumber(_ number: Int) -> Async<Void, BadgeError> {
        return Async { completion in
            #if DEBUG
            if __isSnapshot { return completion(.success(())) }
            #endif
            self.notificationCenter.requestAuthorization(options: [.badge]) { granted, error in
                if let error = error {
                    completion(.failure(BadgeError.frameworkError(error)))
                    return
                }
                guard granted else {
                    completion(.failure(.unauthorized))
                    return
                }
                onMain { self.application.applicationIconBadgeNumber = number }
                completion(.success(()))
            }
        }
    }
}
