//
//  SimulatorImagePickerController.swift
//  DigiDocs
//
//  Created by Lee Arromba on 22/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import UIKit

class SimulatorImagePickerController: UIImagePickerController {
    override var sourceType: UIImagePickerControllerSourceType { get{ return .camera } set{} }
    override var showsCameraControls: Bool { get{ return true } set{} }
    override var cameraOverlayView: UIView? { get{ return nil } set{} }
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override class func isSourceTypeAvailable(_ sourceType: UIImagePickerControllerSourceType) -> Bool {
        return true
    }
}
