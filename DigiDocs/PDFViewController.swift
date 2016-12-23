//
//  PDFViewController.swift
//  DigiDocs
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import QuickLook

class PDFViewController: QLPreviewController, Messaging {
    fileprivate var items: [PDFPreviewItem]
    
    init?(paths: [URL]) {
        items = [PDFPreviewItem]()

        for path in paths {
            let item = PDFPreviewItem(path: path)
            guard QLPreviewController.canPreview(item) else {
                return nil
            }
            items.append(item)
        }
        
        super.init(nibName: nil, bundle: nil)
        
        dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete".localized, style: .done, target: self, action: #selector(deleteItem(_:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.shared.sendScreenNameEvent(classForCoder)
    }
    
    // MARK - Action
    
    @objc fileprivate func deleteItem(_ sender: UIBarButtonItem) {
        guard currentPreviewItemIndex < items.count else {
            debugPrint("bad index")
            return // shouldnt happen
        }
        getConfirmation({
            let item = self.items[self.currentPreviewItemIndex]
            guard let url = item.previewItemURL else {
                self.showFatalError()
                return
            }
            do {
                try FileManager.default.removeItem(at: url)
                self.items.remove(at: self.currentPreviewItemIndex)
                guard self.items.count > 0 else {
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                self.reloadData()
            } catch {
                debugPrint(error.localizedDescription)
                let message = String(format: "Couldn't delete %@. %@".localized, url.lastPathComponent, error.localizedDescription)
                self.showMessage(message)
                Analytics.shared.sendErrorEvent(error, classId: self.classForCoder)
            }
        })
    }
    
    // MARK: - Private
    
    fileprivate func getConfirmation(_ handler: @escaping ((Void) -> Void)) {
        Analytics.shared.sendEvent("delete_confirmation_show", classId: classForCoder)
        let alert = UIAlertController(title: "Warning".localized, message: "Are you sure?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No".localized, style: .default, handler: { (_) in
            Analytics.shared.sendButtonPressEvent("no", classId: self.classForCoder)
        }))
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (_) in
            Analytics.shared.sendButtonPressEvent("yes", classId: self.classForCoder)
            handler()
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - QLPreviewControllerDataSource

extension PDFViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return items.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return items[index]
    }
}
