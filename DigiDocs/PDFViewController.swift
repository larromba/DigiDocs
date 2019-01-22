import Logging
import QuickLook

protocol PDFViewControlling: Presentable {
    var viewState: PDFViewStating { get set }

    func setDelegate(_ delegate: PDFViewControllerDelegate)
}

protocol PDFViewControllerDelegate: AnyObject {
    func viewController(_ viewController: PDFViewController, deleteItem item: PDFPreviewItem)
}

final class PDFViewController: QLPreviewController, PDFViewControlling {
    private weak var viewControllerDelegate: PDFViewControllerDelegate?

    var viewState: PDFViewStating {
        didSet { bind(viewState) }
    }

    init(viewState: PDFViewStating) {
        self.viewState = viewState
        super.init(nibName: nil, bundle: nil)
        dataSource = self
    }

    func setDelegate(_ delegate: PDFViewControllerDelegate) {
        viewControllerDelegate = delegate
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - private

    private func bind(_ viewState: PDFViewStating) {
        guard isViewLoaded else { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewState.deleteButtonTitle, style: .done,
                                                            target: self, action: #selector(deleteItem(_:)))
        reloadData()
    }

    @objc
    private func deleteItem(_ sender: UIBarButtonItem) {
        viewControllerDelegate?.viewController(self, deleteItem: viewState.items[currentPreviewItemIndex])
    }
}

// MARK: - QLPreviewControllerDataSource

extension PDFViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return viewState.items.count
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return viewState.items[index]
    }
}
