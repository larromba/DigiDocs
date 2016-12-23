//
//  ViewController.swift
//  DigiDocs
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, Messaging {
    @IBOutlet fileprivate var cameraButton: UIButton!
    @IBOutlet fileprivate var listButton: UIButton!
    @IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
    
    fileprivate let camera: Camera
    fileprivate(set) var photos: [UIImage]
    fileprivate var isLoading: Bool {
        set {
            if newValue {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
            isUiEnabled = !newValue
        }
        get {
            return activityIndicator.isAnimating
        }
    }
    fileprivate var isUiEnabled: Bool {
        set {
            cameraButton.isEnabled = newValue
            listButton.isEnabled = newValue
        }
        get {
            return (
                cameraButton.isEnabled &&
                listButton.isEnabled
            )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        photos = [UIImage]()
        camera = Camera()
        super.init(coder: aDecoder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Analytics.shared.sendScreenNameEvent(classForCoder)
    }
    
    // TESTING
    init(photos: [UIImage], camera: Camera, cameraButton: UIButton, listButton: UIButton, activityIndicator: UIActivityIndicatorView, isLoading: Bool? = nil, isUiEnabled: Bool? = nil) {
        self.photos = photos
        self.camera = camera
        self.cameraButton = cameraButton
        self.listButton = listButton
        self.activityIndicator = activityIndicator
        super.init(nibName: nil, bundle: nil)
        if let isLoading = isLoading { self.isLoading = isLoading }
        if let isUiEnabled = isUiEnabled { self.isUiEnabled = isUiEnabled }
        cameraButton.addTarget(self, action: #selector(cameraPressed(sender:)), for: .touchUpInside)
        listButton.addTarget(self, action: #selector(listPressed(sender:)), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @IBAction fileprivate func cameraPressed(sender: UIButton) {
        Analytics.shared.sendButtonPressEvent("camera", classId: classForCoder)
        guard camera.isAvailable else {
            showMessage("Your camera is currently not available".localized)
            Analytics.shared.sendEvent("camera_unavailable", classId: classForCoder)
            return
        }
        camera.open(in: self, delegate: self, completion: { [weak camera] in
            camera?.isDoneEnabled = false
        })
    }
    
    @IBAction fileprivate func listPressed(sender: UIButton) {
        Analytics.shared.sendButtonPressEvent("list", classId: classForCoder)
        guard let list = PDFList() else {
            showMessage("You have no documents saved".localized)
            return
        }
        isLoading = true
        guard let preview = PDFViewController(paths: list.paths) else {
            isLoading = false
            showFatalError()
            Analytics.shared.sendEvent("list_pdf_failed", classId: classForCoder)
            return
        }
        present(preview, animated: true, completion: {
            self.isLoading = false
        })
    }
    
    // MARK: - Private
    
    fileprivate func getName(_ completion: @escaping ((_ name: String?) -> Void)) {
        let alert = UIAlertController(title: "Document Name".localized, message: "What name would you like to give the document?".localized, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) -> Void in
            textField.placeholder = "e.g. December Invoice".localized
        }
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields?.first else {
                self.showFatalError()
                return
            }
            completion(textField.text)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func makePDF(fromPhotos photos: [UIImage], withName name: String) {
        guard let pdf = PDF(images: photos, name: name) else {
            showFatalError()
            Analytics.shared.sendEvent("pdf_init_failed", classId: classForCoder)
            return
        }
        isLoading = true
        pdf.generate({ (error: Error?) in
            guard let preview = PDFViewController(paths: [pdf.path]) else {
                self.isLoading = false
                self.showFatalError()
                Analytics.shared.sendEvent("view_pdf_failed", classId: self.classForCoder)
                return
            }
            self.present(preview, animated: true, completion: {
                self.isLoading = false
            })
        })
    }
}

// MARK: - CameraDelegate

extension MainViewController: CameraDelegate {
    func cameraDidCancel(_ camera: Camera) {
        photos.removeAll()
    }
    
    func cameraDidFinish(_ camera: Camera) {
        Analytics.shared.sendEvent("camera_finished", classId: classForCoder)
        getName({ (name: String?) in
            guard let name = name, name.characters.count > 0 else {
                Analytics.shared.sendEvent("name_too_short", classId: self.classForCoder)
                self.showMessage("You must enter a longer name".localized, handler: { (action: UIAlertAction) -> Void in
                    self.cameraDidFinish(camera) // try again
                })
                return
            }
            guard !PDFList.contains(name) else {
                Analytics.shared.sendEvent("file_exists", classId: self.classForCoder)
                self.showMessage("A document with that name already exists, please try again".localized, handler: { (action: UIAlertAction) -> Void in
                    self.cameraDidFinish(camera) // try again
                })
                return
            }
            self.makePDF(fromPhotos: self.photos, withName: name)
            self.photos.removeAll()
        })
    }
    
    func camera(_ camera: Camera, didTakePhoto photo: UIImage) {
        photos.append(photo)
        camera.isDoneEnabled = true
    }
}
