@testable import DigiDocs
import UIKit

final class AppTestEnvironment {
    var homeViewController: HomeViewControlling
    var pdfService: PDFServicing
    var camera: Camerable
    var cameraOverlay: CameraOverlayViewControlling
    var pdfViewController: PDFViewControlling

    private(set) var alertController: AlertControlling!
    private(set) var overlayAlertController: AlertControlling!
    private(set) var pdfAlertController: AlertControlling!
    private(set) var homeController: HomeControlling!
    private(set) var cameraController: CameraControlling!
    private(set) var listController: ListControlling!
    private(set) var optionsController: OptionsControlling!
    private(set) var pdfController: PDFControlling!
    private(set) var namingController: NamingControlling!
    private(set) var shareController: ShareControlling!
    private(set) var appController: AppControlling!

    init(homeViewController: HomeViewControlling = MockHomeViewController(),
         pdfService: PDFServicing = MockPDFService(),
         camera: Camerable = MockCamera(),
         cameraOverlay: CameraOverlayViewControlling = MockCameraOverlayViewController(),
         pdfViewController: PDFViewControlling = MockPDFViewController()) {
        type(of: self).resetStaticMocks()
        self.homeViewController = homeViewController
        self.pdfService = pdfService
        self.camera = camera
        self.cameraOverlay = cameraOverlay
        self.pdfViewController = pdfViewController
    }

    func setInWindow(_ viewController: UIViewController) {
        let window = UIWindow()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
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
        alertController = AlertController(presenter: homeViewController)
        homeController = HomeController(viewController: homeViewController, pdfService: pdfService)
        overlayAlertController = AlertController(presenter: cameraOverlay)
        cameraController = CameraController(camera: camera, cameraOverlay: cameraOverlay,
                                            alertController: alertController,
                                            overlayAlertController: overlayAlertController)
        listController = ListController(alertController: alertController, presenter: homeViewController,
                                        pdfService: pdfService)
        optionsController = OptionsController(presenter: homeViewController)
        pdfAlertController = AlertController(presenter: pdfViewController)
        pdfController = PDFController(viewController: pdfViewController, alertController: alertController,
                                      pdfAlertController: pdfAlertController, presenter: homeViewController,
                                      pdfService: pdfService)
        namingController = NamingController(alertController: alertController, pdfService: pdfService)
        shareController = ShareController(presenter: homeViewController)
        appController = AppController(homeController: homeController, cameraController: cameraController,
                                      listController: listController, optionsController: optionsController,
                                      pdfController: pdfController, namingController: namingController,
                                      shareController: shareController, alertController: alertController)
    }
}
