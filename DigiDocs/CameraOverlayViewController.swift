//
//  CameraOverlayViewController.swift
//  DigiDocs
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import UIKit

protocol CameraOverlayViewControllerDelegate: class {
    func cameraOverlayTakePressed(_ cameraOverlay: CameraOverlayViewController)
    func cameraOverlayDonePressed(_ cameraOverlay: CameraOverlayViewController)
    func cameraOverlayCancelPressed(_ cameraOverlay: CameraOverlayViewController)
}

class CameraOverlayViewController: UIViewController {
    @IBOutlet var takeButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    weak var delegate: CameraOverlayViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takeButton.setTitle("Take".localized, for: .normal)
        doneButton.setTitle("Done".localized, for: .normal)
        cancelButton.setTitle("Cancel".localized, for: .normal)
    }
    
    // MARK: - Action
    
    @IBAction fileprivate func takeButtonPressed(sender: UIButton) {
        delegate?.cameraOverlayTakePressed(self)
    }
    
    @IBAction fileprivate func cancelButtonPressed(sender: UIButton) {
        delegate?.cameraOverlayCancelPressed(self)
    }
    
    @IBAction fileprivate func doneButtonPressed(sender: UIButton) {
        delegate?.cameraOverlayDonePressed(self)
    }
}
