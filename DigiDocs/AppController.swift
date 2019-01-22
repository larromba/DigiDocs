import UIKit
import Logging

// TODO: remove L10n.longerNameAlertTitle

// sourcery: name = AppController
protocol AppControlling: Mockable {
    // 🦄
}

final class AppController: AppControlling {
    private let mainController: MainControlling
    private let cameraController: CameraControlling
    private let listController: ListControlling
    private let optionsController: OptionsControlling
    private let pdfController: PDFControlling
    private let namingController: NamingControlling
    private let shareController: ShareControlling

    init(mainController: MainControlling, cameraController: CameraControlling, listController: ListControlling,
         optionsController: OptionsControlling, pdfController: PDFControlling, namingController: NamingControlling,
         shareController: ShareControlling) {
        self.mainController = mainController
        self.cameraController = cameraController
        self.listController = listController
        self.optionsController = optionsController
        self.namingController = namingController
        self.shareController = shareController
        self.pdfController = pdfController

        mainController.setDelegate(self)
        optionsController.setDelegate(self)
    }
}

// MARK: - MainControllerDelegate

extension AppController: MainControllerDelegate {
    func controller(_ controller: MainControlling, performAction action: MainAction) {
        switch action {
        case .openCamera:
            cameraController.openCamera(in: mainController.presenter)
        case .openList:
            if listController.documentCount == 1 {
                listController.openList(listController.list)
            } else {
                optionsController.displayOptions()
            }
        }
    }
}

// MARK: - CameraControllerDelegate

extension AppController: CameraControllerDelegate {
    func controller(_ controller: CameraController, finishedWithPhotos photos: [UIImage]) {
        namingController.getName { name in
            self.pdfController.makePDF(fromPhotos: photos, withName: name ?? "") //TODO: ??
            self.mainController.updatedPDFList() // TODO: correct here?
        }
    }
}

// MARK: - OptionsControllerDelegate

extension AppController: OptionsControllerDelegate {
    func controller(_ controller: OptionsController, performAction action: OptionAction) {
        switch action {
        case .viewAll: listController.openList(listController.list)
        case .deleteAll: pdfController.deletePDFs(at: listController.list.paths)
        case .shareAll: shareController.shareItems(listController.list.paths)
        }
    }
}
