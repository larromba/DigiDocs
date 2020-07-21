import AsyncAwait
import Logging
import UIKit

// sourcery: name = HomeCoordinator
protocol HomeCoordinating: Mockable {
    // 🦄
}

final class HomeCoordinater: HomeCoordinating {
    private let homeController: HomeControlling
    private let homeAlertController: AlertControlling
    private let cameraController: CameraControlling
    private let cameraAlertController: AlertControlling
    private let listController: ListControlling
    private let optionsController: OptionsControlling
    private let pdfController: PDFControlling
    private let pdfAlertController: AlertControlling
    private let namingController: NamingControlling
    private let shareController: ShareControlling
    private var context = PDFContext()

    init(homeController: HomeControlling, homeAlertController: AlertControlling, cameraController: CameraControlling,
         cameraAlertController: AlertControlling, listController: ListControlling,
         optionsController: OptionsControlling, pdfController: PDFControlling, pdfAlertController: AlertControlling,
         namingController: NamingControlling, shareController: ShareControlling) {
        self.homeController = homeController
        self.homeAlertController = homeAlertController
        self.cameraController = cameraController
        self.cameraAlertController = cameraAlertController
        self.listController = listController
        self.optionsController = optionsController
        self.namingController = namingController
        self.shareController = shareController
        self.pdfController = pdfController
        self.pdfAlertController = pdfAlertController

        homeController.setDelegate(self)
        cameraController.setDelegate(self)
        optionsController.setDelegate(self)
        namingController.setDelegate(self)
        pdfController.setDelegate(self)
    }
}

// MARK: - MainControllerDelegate

extension HomeCoordinater: HomeControllerDelegate {
    func controller(_ controller: HomeControlling, performAction action: HomeAction) {
        switch action {
        case .openCamera: cameraController.openCamera()
        case .openList: optionsController.displayOptions()
        }
    }
}

// MARK: - CameraControllerDelegate

extension HomeCoordinater: CameraControllerDelegate {
    func controller(_ controller: CameraControlling, finishedWithPhotos photos: [UIImage]) {
        controller.closeCamera { [weak self] in
            guard !photos.isEmpty else { return }
            self?.context.photos = photos
            self?.namingController.getName()
        }
    }

    func controller(_ controller: CameraControlling, showAlert alert: Alert) {
        if controller.isPresenting {
            cameraAlertController.showAlert(alert)
        } else {
            homeAlertController.showAlert(alert)
        }
    }
}

// MARK: - OptionsControllerDelegate

extension HomeCoordinater: OptionsControllerDelegate {
    func controller(_ controller: OptionsController, performAction action: OptionAction) {
        let list = listController.all
        switch action {
        case .viewAll: listController.openList(list)
        case .deleteAll: pdfController.showDeleteDialogue(for: list.paths)
        case .shareAll: shareController.shareItems(list.paths)
        }
    }
}

// MARK: - NamingControllerDelegate

extension HomeCoordinater: NamingControllerDelegate {
    func controller(_ controller: NamingControlling, showAlert alert: Alert) {
        homeAlertController.showAlert(alert)
    }

    func controller(_ controller: NamingControlling, setIsAlertButtonEnabled isEnabled: Bool, at index: Int) {
        homeAlertController.setIsButtonEnabled(isEnabled, at: index)
    }

    func controller(_ controller: NamingControlling, gotName name: String) {
        context.name = name
        guard let pdf = context.currentPDF else { return }
        homeController.setIsLoading(true)
        homeController.refreshBadge()
        pdfController.showPDF(pdf)
    }
}

// MARK: - PDFControllerDelegate

extension HomeCoordinater: PDFControllerDelegate {
    func controller(_ controller: PDFControlling, didShow: Bool, pdf: PDF) {
        homeController.setIsLoading(false)
        context.reset()
    }

    func controller(_ controller: PDFControlling, showAlert alert: Alert) {
        if controller.isPresenting {
            pdfAlertController.showAlert(alert)
        } else {
            homeAlertController.showAlert(alert)
        }
    }

    func controller(_ controller: PDFControlling, didDeleteItemsAtPaths: [URL]) {
        homeController.refreshBadge()
    }
}
