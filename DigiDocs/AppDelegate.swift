import Logging
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appController: AppControlling?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
            log("app is in test mode")
            return true
        }
        #endif

        guard let viewController = window?.rootViewController as? MainViewControlling else {
            assertionFailure("expected MainViewController")
            return true
        }
        appController = AppControllerFactory.makeAppController(viewController: viewController)
        return true
    }
}
