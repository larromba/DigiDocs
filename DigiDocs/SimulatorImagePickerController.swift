import UIKit

// Camera doesn't work in the simulator, so we use this when targeting the simulator

#if DEBUG && targetEnvironment(simulator)
final class SimulatorImagePickerController: UIViewController, ImagePickerControlling {
    var allowsEditing: Bool = false
    var sourceType: UIImagePickerController.SourceType = .camera
    var showsCameraControls: Bool = false
    var cameraOverlayView: UIView?
    var cameraViewTransform: CGAffineTransform = .identity
    weak var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
    static var isSourceTypeAvailable = true
    private var imageView = UIImageView()

    static func isSourceTypeAvailable(_ sourceType: UIImagePickerController.SourceType) -> Bool {
        return isSourceTypeAvailable
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        imageView.image = Asset.exampleBill.image
        if UIDevice.current.userInterfaceIdiom == .pad {
            imageView.frame = view.bounds.insetBy(dx: 40, dy: 120)
        } else {
            imageView.frame = view.bounds.insetBy(dx: 20, dy: 60)
        }
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let cameraOverlayView = cameraOverlayView else { return }
        cameraOverlayView.bounds = view.frame
        view.addSubview(cameraOverlayView)
    }

    func takePicture() {
        delegate?.imagePickerController?(UIImagePickerController(), didFinishPickingMediaWithInfo: [
            .originalImage: Asset.exampleBill.image
        ])
    }
}
#endif
