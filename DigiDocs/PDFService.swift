import AsyncAwait
import Logging
import Result
import UIKit

// sourcery: name = PDFService
protocol PDFServicing: Mockable {
    // sourcery: returnValue = "PDFList(paths: [])"
    func generateList() -> PDFList
    func deleteList(_ list: PDFList) -> Result<Void>
    func generatePDF(_ pdf: PDF) -> Async<Void>
}

final class PDFService: PDFServicing {
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
            if pdfDocuments.isEmpty {
                logWarning("no pdf docs")
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

    func deleteList(_ list: PDFList) -> Result<Void> {
        for url in list.paths {
            do {
                try fileManager.removeItem(at: url)
            } catch {
                return .failure(PDFError.framework(error))
            }
        }
        return .success(())
    }

    func generatePDF(_ pdf: PDF) -> Async<Void> {
        return Async { completion in
            guard !pdf.images.isEmpty else {
                logError("pdf images empty")
                completion(.failure(PDFError.noContent))
                return
            }
            DispatchQueue.global().async(execute: {
                let firstImage = pdf.images[0]
                let bounds = CGRect(x: 0, y: 0, width: firstImage.size.width, height: firstImage.size.height)
                guard UIGraphicsBeginPDFContextToFile(pdf.path.relativePath, bounds, nil) else {
                    completion(.failure(PDFError.context))
                    return
                }
                for image in pdf.images {
                    UIGraphicsBeginPDFPageWithInfo(bounds, nil)
                    image.draw(at: .zero)
                }
                UIGraphicsEndPDFContext()
                completion(.success(()))
            })
        }
    }
}
