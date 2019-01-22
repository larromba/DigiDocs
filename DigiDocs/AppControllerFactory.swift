import UIKit

enum AppControllerFactory {
    static func makeAppController(viewController: MainViewControlling) -> AppControlling {
        let fileManager = FileManager.default
        let pdfService = PDFService(fileManager: fileManager)
        let mainController = MainController(viewController: viewController, pdfService: pdfService)

        guard let overlay = UIStoryboard.camera
            .instantiateInitialViewController() as? CameraOverlayViewController else {
                fatalError("couldn't instantiate CameraOverlayViewController")
        }
        let camera = Camera(overlay: overlay)
        let cameraController = CameraController(camera: camera, cameraOverlay: overlay,
                                                alertController: AlertController(presenter: overlay))

        let listController = ListController(alertController: AlertController(presenter: viewController),
                                            presenter: viewController,
                                            pdfService: pdfService)

        let optionsController = OptionsController(presenter: viewController,
                                                  alertController: AlertController(presenter: viewController))

        // TODO: empty view state?
        let pdfViewController = PDFViewController(viewState: PDFViewState(paths: []))
        let pdfController = PDFController(viewController: pdfViewController,
                                          alertController: AlertController(presenter: pdfViewController),
                                          presenter: viewController, pdfService: pdfService)

        let namingController = NamingController(alertController: AlertController(presenter: viewController),
                                                pdfService: pdfService)

        let shareController = ShareController(presenter: viewController)

        return AppController(mainController: mainController, cameraController: cameraController,
                             listController: listController, optionsController: optionsController,
                             pdfController: pdfController, namingController: namingController,
                             shareController: shareController)
    }
}
