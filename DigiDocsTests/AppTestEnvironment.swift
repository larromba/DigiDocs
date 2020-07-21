@testable import DigiDocs
import UIKit

final class AppTestEnvironment {
    var homeViewController: HomeViewControlling
    var pdfService: PDFServicing
    var camera: Camerable
    var cameraOverlay: CameraOverlayViewControlling
    var pdfViewController: PDFViewControlling
    var badge: Badge

    private(set) var overlayAlertController: AlertControlling!
    private(set) var pdfAlertController: AlertControlling!
    private(set) var homeController: HomeControlling!
    private(set) var homeAlertController: AlertControlling!
    private(set) var cameraController: CameraControlling!
    private(set) var cameraAlertController: AlertControlling!
    private(set) var listController: ListControlling!
    private(set) var optionsController: OptionsControlling!
    private(set) var pdfController: PDFControlling!
    private(set) var namingController: NamingControlling!
    private(set) var shareController: ShareControlling!
    private(set) var homeCoordinator: HomeCoordinating!
    private(set) var appRouter: AppRouting!
    private(set) var app: App!
    private(set) var window: UIWindow?

    init(homeViewController: HomeViewControlling = MockHomeViewController(),
         pdfService: PDFServicing = MockPDFService(),
         camera: Camerable = MockCamera(),
         cameraOverlay: CameraOverlayViewControlling = MockCameraOverlayViewController(),
         pdfViewController: PDFViewControlling = MockPDFViewController(),
         badge: Badge = MockBadge()) {
        type(of: self).resetStaticMocks()
        self.homeViewController = homeViewController
        self.pdfService = pdfService
        self.camera = camera
        self.cameraOverlay = cameraOverlay
        self.pdfViewController = pdfViewController
        self.badge = badge
    }

    func setInWindow(_ viewController: UIViewController) {
        window = UIWindow()
        window?.rootViewController = viewController
    }

    func setNumberOfPDFs(_ number: Int) {
        let fileManager = FileManager.default
        let docsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last!
        let origURL = Bundle(for: AppTestEnvironment.self).url(forResource: "test", withExtension: "pdf")!
        (0..<number).forEach { _ in
            let pdfURL = docsUrl
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension("pdf")
            // swiftlint:disable force_try
            try! fileManager.copyItem(at: origURL, to: pdfURL)
        }
    }

    // MARK: - private

    private static func resetStaticMocks() {
        SimulatorImagePickerController.isSourceTypeAvailable = true
    }
}

// MARK: - TestEnvironment

extension AppTestEnvironment: TestEnvironment {
    func inject() {
        homeAlertController = AlertController(presenter: homeViewController)
        homeController = HomeController(viewController: homeViewController, pdfService: pdfService, badge: badge)
        overlayAlertController = AlertController(presenter: cameraOverlay)
        cameraController = CameraController(camera: camera, cameraOverlay: cameraOverlay, presenter: homeViewController)
        cameraAlertController = AlertController(presenter: cameraOverlay)
        listController = ListController(presenter: homeViewController, pdfService: pdfService)
        // popoverView required for ipad, but safe to inject dummy view as we're only testing iphone
        optionsController = OptionsController(presenter: homeViewController, popoverView: UIView())
        pdfAlertController = AlertController(presenter: pdfViewController)
        pdfController = PDFController(viewController: pdfViewController, presenter: homeViewController,
                                      pdfService: pdfService)
        namingController = NamingController(pdfService: pdfService)
        shareController = ShareController(presenter: homeViewController)
        homeCoordinator = HomeCoordinater(
            homeController: homeController,
            homeAlertController: homeAlertController,
            cameraController: cameraController,
            cameraAlertController: cameraAlertController,
            listController: listController,
            optionsController: optionsController,
            pdfController: pdfController,
            pdfAlertController: pdfAlertController,
            namingController: namingController,
            shareController: shareController
        )
        appRouter = AppRouter(homeCoordinator: homeCoordinator)
        app = App(router: appRouter)
        window?.makeKeyAndVisible()
    }
}
