import AsyncAwait
import Logging
import UIKit

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
    private let alertController: AlertControlling

    init(mainController: MainControlling, cameraController: CameraControlling, listController: ListControlling,
         optionsController: OptionsControlling, pdfController: PDFControlling, namingController: NamingControlling,
         shareController: ShareControlling, alertController: AlertControlling) {
        self.mainController = mainController
        self.cameraController = cameraController
        self.listController = listController
        self.optionsController = optionsController
        self.namingController = namingController
        self.shareController = shareController
        self.pdfController = pdfController
        self.alertController = alertController

        mainController.setDelegate(self)
        cameraController.setDelegate(self)
        optionsController.setDelegate(self)
    }

    // MARK: - private

    private func deleteAll() {
        async({
            try await(self.pdfController.deletePDFs(at: self.listController.list.paths))
            onMain { self.mainController.refreshUI() }
        }, onError: { error in
            onMain { self.alertController.showAlert(Alert(error: error)) }
        })
    }

    private func finishedWithPhotos(_ photos: [UIImage]) {
        async({
            let name = try await(self.namingController.getName())
            onMain { self.mainController.setIsLoading(true) }
            try await(self.pdfController.makePDF(fromPhotos: photos, withName: name))
            onMain {
                self.mainController.setIsLoading(false)
                self.mainController.refreshUI()
            }
        }, onError: { error in
            onMain { self.alertController.showAlert(Alert(error: error)) }
        })
    }
}

// MARK: - MainControllerDelegate

extension AppController: MainControllerDelegate {
    func controller(_ controller: MainControlling, performAction action: MainAction) {
        switch action {
        case .openCamera: cameraController.openCamera(in: mainController.presenter)
        case .openList: optionsController.displayOptions()
        }
    }
}

// MARK: - CameraControllerDelegate

extension AppController: CameraControllerDelegate {
    func controller(_ controller: CameraController, finishedWithPhotos photos: [UIImage]) {
        self.finishedWithPhotos(photos)
    }
}

// MARK: - OptionsControllerDelegate

extension AppController: OptionsControllerDelegate {
    func controller(_ controller: OptionsController, performAction action: OptionAction) {
        switch action {
        case .viewAll: listController.openList(listController.list)
        case .deleteAll: deleteAll()
        case .shareAll: shareController.shareItems(listController.list.paths)
        }
    }
}
