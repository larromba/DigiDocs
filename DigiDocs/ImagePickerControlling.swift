import UIKit

protocol ImagePickerControlling: AnyObject, ViewControllerCastable {
    var allowsEditing: Bool { get set }
    var sourceType: UIImagePickerController.SourceType { get set }
    var showsCameraControls: Bool { get set }
    var cameraOverlayView: UIView? { get set }
    var cameraViewTransform: CGAffineTransform { get set }
    var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? { get set }
    var modalPresentationStyle: UIModalPresentationStyle { get set }

    init()
    static func isSourceTypeAvailable(_ sourceType: UIImagePickerController.SourceType) -> Bool
    func takePicture()
}
extension UIImagePickerController: ImagePickerControlling {}
