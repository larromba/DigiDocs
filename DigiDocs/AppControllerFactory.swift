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
        #if targetEnvironment(simulator)
        let pickerType = SimulatorImagePickerController.self
        #else
        let pickerType = UIImagePickerController.self
        #endif
        let camera = Camera(overlay: overlay, pickerType: pickerType)
        let alertController = AlertController(presenter: viewController)
        let cameraController = CameraController(camera: camera, cameraOverlay: overlay,
                                                alertController: alertController,
                                                overlayAlertController: AlertController(presenter: overlay))

        let listController = ListController(alertController: alertController, presenter: viewController,
                                            pdfService: pdfService)

        let optionsController = OptionsController(presenter: viewController)

        let pdfViewController = PDFViewController(viewState: PDFViewState(paths: []))
        let pdfController = PDFController(viewController: pdfViewController, alertController: alertController,
                                          pdfAlertController: AlertController(presenter: pdfViewController),
                                          presenter: viewController, pdfService: pdfService)

        let namingController = NamingController(alertController: alertController, pdfService: pdfService)

        let shareController = ShareController(presenter: viewController)

        return AppController(mainController: mainController, cameraController: cameraController,
                             listController: listController, optionsController: optionsController,
                             pdfController: pdfController, namingController: namingController,
                             shareController: shareController, alertController: alertController)
    }
}
