import UIKit

enum AppFactory {
    // swiftlint:disable function_body_length
    static func make(viewController: HomeViewController) -> Appable {
        viewController.preloadView()

        let fileManager = FileManager.default
        let pdfService = PDFService(fileManager: fileManager)
        #if DEBUG && targetEnvironment(simulator)
        if __isSnapshot { // if snapshotting, delete saved pdfs
            _ = pdfService.deleteList(pdfService.generateList())
        }
        #endif
        let homeController = HomeController(viewController: viewController, pdfService: pdfService, badge: AppBadge())
        let homeAlertController = AlertController(presenter: viewController)
        guard let overlay = UIStoryboard.camera
            .instantiateInitialViewController() as? CameraOverlayViewController else {
                fatalError("couldn't instantiate CameraOverlayViewController")
        }
        #if DEBUG && targetEnvironment(simulator)
        let pickerType = SimulatorImagePickerController.self
        #else
        let pickerType = UIImagePickerController.self
        #endif
        let camera = Camera(overlay: overlay, pickerType: pickerType)
        let cameraController = CameraController(camera: camera, cameraOverlay: overlay, presenter: viewController)
        let cameraAlertController = AlertController(presenter: overlay)
        let listController = ListController(presenter: viewController, pdfService: pdfService)
        let optionsController = OptionsController(presenter: viewController, popoverView: viewController.listButton)
        let pdfViewController = PDFViewController(viewState: PDFViewState(paths: []))
        let pdfAlertController = AlertController(presenter: pdfViewController)
        let pdfController = PDFController(viewController: pdfViewController, presenter: viewController,
                                          pdfService: pdfService)
        let namingController = NamingController(pdfService: pdfService)
        let shareController = ShareController(presenter: viewController)
        let homeCoordinator = HomeCoordinater(
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
        let router = AppRouter(homeCoordinator: homeCoordinator)
        return App(router: router)
    }
}
