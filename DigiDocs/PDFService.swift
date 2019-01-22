import UIKit
import Logging

protocol PDFServicing {
    func generateList() -> PDFList
    func deleteList(_ list: PDFList) -> Error?
    func generatePDF(_ pdf: PDF, _ completion: @escaping ((_ error: Error?) -> Void))
}

final class PDFService: PDFServicing {
    enum ErrorType: Error {
        case context
    }

    let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func generateList() -> PDFList {
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last else {
            logError("couldn't find documentDirectory")
            return PDFList(paths: [])
        }
        do {
            let documents = try fileManager.contentsOfDirectory(atPath: documentsPath.relativePath)
            let pdfDocuments = documents.filter { $0.contains(".\(FileExtension.pdf.rawValue)") }
            guard !pdfDocuments.isEmpty else {
                logWarning("no pdf documents found")
                return PDFList(paths: [])
            }
            return PDFList(paths: pdfDocuments.map { name -> URL in
                let path = documentsPath.appendingPathComponent(name)
                return path
            })
        } catch {
            logError(error.localizedDescription)
            return PDFList(paths: [])
        }
    }

    func deleteList(_ list: PDFList) -> Error? {
        for url in list.paths {
            do {
                try fileManager.removeItem(at: url)
            } catch {
                return error
            }
        }
        return nil
    }

    func generatePDF(_ pdf: PDF, _ completion: @escaping ((_ error: Error?) -> Void)) {
        guard !pdf.images.isEmpty else {
            // TODO: return error?
            return
        }
        DispatchQueue.global().async(execute: {
            let firstImage = pdf.images[0]
            let bounds = CGRect(x: 0, y: 0, width: firstImage.size.width, height: firstImage.size.height)
            guard UIGraphicsBeginPDFContextToFile(pdf.path.relativePath, bounds, nil) else {
                DispatchQueue.main.async(execute: {
                    completion(ErrorType.context)
                })
                return
            }
            for image in pdf.images {
                UIGraphicsBeginPDFPageWithInfo(bounds, nil)
                image.draw(at: .zero)
            }
            UIGraphicsEndPDFContext()
            DispatchQueue.main.async(execute: {
                completion(nil)
            })
        })
    }
}
