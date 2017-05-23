//
//  Camera.swift
//  DigiDocs
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import UIKit

protocol CameraDelegate: class {
    func camera(_ camera: Camera, didTakePhoto photo: UIImage)
    func cameraDidCancel(_ camera: Camera)
    func cameraDidFinish(_ camera: Camera)
}

class Camera: NSObject {
    fileprivate let PickerController: UIImagePickerController.Type
    fileprivate let overlay: CameraOverlayViewController
   
    weak var picker: UIImagePickerController?
    weak var delegate: CameraDelegate?
    var isAvailable: Bool {
        return PickerController.isSourceTypeAvailable(.camera)
    }
    var isDoneEnabled: Bool {
        get {
            return overlay.doneButton.isEnabled
        }
        set {
            overlay.doneButton.isEnabled = newValue
            if newValue {
                overlay.doneButton.alpha = 1.0
            } else {
                overlay.doneButton.alpha = 0.3
            }
        }
    }
    
    override init() {
        self.PickerController = UIImagePickerController.self
        guard let overlay = UIStoryboard.camera.instantiateInitialViewController() as? CameraOverlayViewController else {
            fatalError("couldn't load \(CameraOverlayViewController.self)")
        }
        self.overlay = overlay
        super.init()
        overlay.delegate = self
    }
    
    // TESTING
    init(type: UIImagePickerController.Type = UIImagePickerController.self, picker: UIImagePickerController, overlay: CameraOverlayViewController) {
        self.PickerController = type
        self.picker = picker
        self.overlay = overlay
        super.init()
        overlay.delegate = self
    }
    
    // MARK: - Internal
    
    func open(in viewController: UIViewController, delegate: CameraDelegate, completion: ((Void) -> Void)? = nil) {
        guard isAvailable else {
            debugPrint("dangerous call - camera not available")
            return
        }
        Analytics.shared.sendEvent("camera_opened", classId: classForCoder)
        
        self.delegate = delegate
        
        let picker = PickerController.init()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.showsCameraControls = false
        picker.cameraOverlayView = overlay.view

        let screenSize = UIScreen.main.bounds.size
        let ratio: CGFloat = 4.0 / 3.0
        let cameraHeight = screenSize.width * ratio
        picker.cameraViewTransform = CGAffineTransform(translationX: 0, y: (screenSize.height - cameraHeight) / 4.0)
        
// full screen
//        let scale = screenSize.height / cameraHeight
//        picker.cameraViewTransform = picker.cameraViewTransform.scaledBy(x: scale, y: scale)

        viewController.present(picker, animated: true, completion: {
            completion?()
            Analytics.shared.sendScreenNameEvent(picker.classForCoder)
        })
        self.picker = picker
    }
}

// MARK: - UIImagePickerControllerDelegate

extension Camera: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let photo = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("missing \(UIImagePickerControllerOriginalImage)")
        }
        delegate?.camera(self, didTakePhoto: photo)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.cameraDidCancel(self)
    }
}

// MARK: - CameraOverlayViewControllerDelegate

extension Camera: CameraOverlayViewControllerDelegate {
    func cameraOverlayTakePressed(_ cameraOverlay: CameraOverlayViewController) {
        picker?.takePicture()
    }
    
    func cameraOverlayDonePressed(_ cameraOverlay: CameraOverlayViewController) {
        picker?.dismiss(animated: true, completion: { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.cameraDidFinish(self)
        })
    }
    
    func cameraOverlayCancelPressed(_ cameraOverlay: CameraOverlayViewController) {
        picker?.dismiss(animated: true, completion: { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.cameraDidCancel(self)
        })
    }
}
