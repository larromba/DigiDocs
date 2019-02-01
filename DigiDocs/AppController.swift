import AsyncAwait
import Logging
import UIKit

// sourcery: name = AppController
protocol AppControlling: Mockable {
    // 🦄
}

final class AppController: AppControlling {
    private let homeController: HomeControlling
    private let cameraController: CameraControlling
    private let listController: ListControlling
    private let optionsController: OptionsControlling
    private let pdfController: PDFControlling
    private let namingController: NamingControlling
    private let shareController: ShareControlling
    private let alertController: AlertControlling

    init(homeController: HomeControlling, cameraController: CameraControlling, listController: ListControlling,
         optionsController: OptionsControlling, pdfController: PDFControlling, namingController: NamingControlling,
         shareController: ShareControlling, alertController: AlertControlling) {
        self.homeController = homeController
        self.cameraController = cameraController
        self.listController = listController
        self.optionsController = optionsController
        self.namingController = namingController
        self.shareController = shareController
        self.pdfController = pdfController
        self.alertController = alertController

        homeController.setDelegate(self)
        cameraController.setDelegate(self)
        optionsController.setDelegate(self)
    }

    // MARK: - private

    private func deleteAll() {
        async({
            try await(self.pdfController.deletePDFs(at: self.listController.list.paths))
            onMain { self.homeController.refreshUI() }
        }, onError: { error in
            onMain { self.alertController.showAlert(Alert(error: error)) }
        })
    }

    private func cameraFinishedWithPhotos(_ photos: [UIImage]) {
        async({
            let name = try await(self.namingController.getName())
            onMain { self.homeController.setIsLoading(true) }
            try await(self.pdfController.makePDF(fromPhotos: photos, withName: name))
            onMain {
                self.homeController.setIsLoading(false)
                self.homeController.refreshUI()
            }
        }, onError: { error in
            onMain { self.alertController.showAlert(Alert(error: error)) }
        })
    }
}

// MARK: - MainControllerDelegate

extension AppController: HomeControllerDelegate {
    func controller(_ controller: HomeControlling, performAction action: MainAction) {
        switch action {
        case .openCamera: cameraController.openCamera(in: homeController.presenter)
        case .openList: optionsController.displayOptions()
        }
    }
}

// MARK: - CameraControllerDelegate

extension AppController: CameraControllerDelegate {
    func controller(_ controller: CameraController, finishedWithPhotos photos: [UIImage]) {
        self.cameraFinishedWithPhotos(photos)
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
