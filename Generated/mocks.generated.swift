// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import AsyncAwait
@testable import DigiDocs
import Result

// MARK: - Sourcery Helper

protocol _StringRawRepresentable: RawRepresentable {
    var rawValue: String { get }
}

struct _Variable<T> {
    let date = Date()
    var variable: T

    init(_ variable: T) {
        self.variable = variable
    }
}

final class _Invocation {
    let name: String
    let date = Date()
    private var parameters: [String: Any] = [:]

    init(name: String) {
        self.name = name
    }

    fileprivate func set<T: _StringRawRepresentable>(parameter: Any, forKey key: T) {
        parameters[key.rawValue] = parameter
    }
    func parameter<T: _StringRawRepresentable>(for key: T) -> Any? {
        return parameters[key.rawValue]
    }
}

final class _Actions {
    enum Keys: String, _StringRawRepresentable {
        case returnValue
        case defaultReturnValue
        case error
    }
    private var invocations: [_Invocation] = []

    // MARK: - returnValue

    func set<T: _StringRawRepresentable>(returnValue value: Any, for functionName: T) {
        let invocation = self.invocation(for: functionName)
        invocation.set(parameter: value, forKey: Keys.returnValue)
    }
    func returnValue<T: _StringRawRepresentable>(for functionName: T) -> Any? {
        let invocation = self.invocation(for: functionName)
        return invocation.parameter(for: Keys.returnValue) ?? invocation.parameter(for: Keys.defaultReturnValue)
    }

    // MARK: - defaultReturnValue

    fileprivate func set<T: _StringRawRepresentable>(defaultReturnValue value: Any, for functionName: T) {
        let invocation = self.invocation(for: functionName)
        invocation.set(parameter: value, forKey: Keys.defaultReturnValue)
    }
    fileprivate func defaultReturnValue<T: _StringRawRepresentable>(for functionName: T) -> Any? {
        let invocation = self.invocation(for: functionName)
        return invocation.parameter(for: Keys.defaultReturnValue) as? (() -> Void)
    }

    // MARK: - error

    func set<T: _StringRawRepresentable>(error: Error, for functionName: T) {
        let invocation = self.invocation(for: functionName)
        invocation.set(parameter: error, forKey: Keys.error)
    }
    func error<T: _StringRawRepresentable>(for functionName: T) -> Error? {
        let invocation = self.invocation(for: functionName)
        return invocation.parameter(for: Keys.error) as? Error
    }

    // MARK: - private

    private func invocation<T: _StringRawRepresentable>(for name: T) -> _Invocation {
        if let invocation = invocations.filter({ $0.name == name.rawValue }).first {
            return invocation
        }
        let invocation = _Invocation(name: name.rawValue)
        invocations += [invocation]
        return invocation
    }
}

final class _Invocations {
    private var history = [_Invocation]()

    fileprivate func record(_ invocation: _Invocation) {
        history += [invocation]
    }

    func isInvoked<T: _StringRawRepresentable>(_ name: T) -> Bool {
        return history.contains(where: { $0.name == name.rawValue })
    }

    func count<T: _StringRawRepresentable>(_ name: T) -> Int {
        return history.filter {  $0.name == name.rawValue }.count
    }

    func all() -> [_Invocation] {
        return history.sorted { $0.date < $1.date }
    }

    func find<T: _StringRawRepresentable>(_ name: T) -> [_Invocation] {
        return history.filter {  $0.name == name.rawValue }.sorted { $0.date < $1.date }
    }
}

// MARK: - Sourcery Mocks

class MockAlertController: NSObject, AlertControlling {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - showAlert

    func showAlert(_ alert: Alert) {
        let functionName = showAlert1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: alert, forKey: showAlert1.params.alert)
        invocations.record(invocation)
    }

    enum showAlert1: String, _StringRawRepresentable {
        case name = "showAlert1"
        enum params: String, _StringRawRepresentable {
            case alert = "showAlert(_alert:Alert).alert"
        }
    }

    // MARK: - setIsButtonEnabled

    func setIsButtonEnabled(_ isEnabled: Bool, at index: Int) {
        let functionName = setIsButtonEnabled2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: isEnabled, forKey: setIsButtonEnabled2.params.isEnabled)
        invocation.set(parameter: index, forKey: setIsButtonEnabled2.params.index)
        invocations.record(invocation)
    }

    enum setIsButtonEnabled2: String, _StringRawRepresentable {
        case name = "setIsButtonEnabled2"
        enum params: String, _StringRawRepresentable {
            case isEnabled = "setIsButtonEnabled(_isEnabled:Bool,atindex:Int).isEnabled"
            case index = "setIsButtonEnabled(_isEnabled:Bool,atindex:Int).index"
        }
    }
}

class MockAppController: NSObject, AppControlling {
}

class MockCameraController: NSObject, CameraControlling {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - openCamera

    func openCamera(in presenter: Presentable) {
        let functionName = openCamera1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: presenter, forKey: openCamera1.params.presenter)
        invocations.record(invocation)
    }

    enum openCamera1: String, _StringRawRepresentable {
        case name = "openCamera1"
        enum params: String, _StringRawRepresentable {
            case presenter = "openCamera(inpresenter:Presentable).presenter"
        }
    }

    // MARK: - setDelegate

    func setDelegate(_ delegate: CameraControllerDelegate) {
        let functionName = setDelegate2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate2.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate2: String, _StringRawRepresentable {
        case name = "setDelegate2"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:CameraControllerDelegate).delegate"
        }
    }
}

class MockCameraOverlayViewController: NSObject, CameraOverlayViewControlling {
    var viewState: CameraViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: CameraViewStating?
    var _viewStateHistory: [_Variable<CameraViewStating?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: CameraOverlayViewControllerDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate1: String, _StringRawRepresentable {
        case name = "setDelegate1"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:CameraOverlayViewControllerDelegate).delegate"
        }
    }

    // MARK: - present

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        let functionName = present2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewControllerToPresent, forKey: present2.params.viewControllerToPresent)
        invocation.set(parameter: flag, forKey: present2.params.flag)
        if let completion = completion {
            invocation.set(parameter: completion, forKey: present2.params.completion)
        }
        invocations.record(invocation)
    }

    enum present2: String, _StringRawRepresentable {
        case name = "present2"
        enum params: String, _StringRawRepresentable {
            case viewControllerToPresent = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).viewControllerToPresent"
            case flag = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).flag"
            case completion = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).completion"
        }
    }
}

class MockCamera: NSObject, Camerable {
    var isAvailable: Bool {
        get { return _isAvailable }
        set(value) { _isAvailable = value; _isAvailableHistory.append(_Variable(value)) }
    }
    var _isAvailable: Bool!
    var _isAvailableHistory: [_Variable<Bool?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: CameraDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate1: String, _StringRawRepresentable {
        case name = "setDelegate1"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:CameraDelegate).delegate"
        }
    }

    // MARK: - open

    func open(in viewController: Presentable) -> Bool {
        let functionName = open2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewController, forKey: open2.params.viewController)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Bool
    }

    enum open2: String, _StringRawRepresentable {
        case name = "open2"
        enum params: String, _StringRawRepresentable {
            case viewController = "open(inviewController:Presentable).viewController"
        }
    }

    // MARK: - takePicture

    func takePicture() {
        let functionName = takePicture3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum takePicture3: String, _StringRawRepresentable {
        case name = "takePicture3"
    }

    // MARK: - dismiss

    func dismiss() {
        let functionName = dismiss4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum dismiss4: String, _StringRawRepresentable {
        case name = "dismiss4"
    }
}

class MockHomeController: NSObject, HomeControlling {
    var presenter: Presentable {
        get { return _presenter }
        set(value) { _presenter = value; _presenterHistory.append(_Variable(value)) }
    }
    var _presenter: Presentable!
    var _presenterHistory: [_Variable<Presentable?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setIsLoading

    func setIsLoading(_ isLoading: Bool) {
        let functionName = setIsLoading1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: isLoading, forKey: setIsLoading1.params.isLoading)
        invocations.record(invocation)
    }

    enum setIsLoading1: String, _StringRawRepresentable {
        case name = "setIsLoading1"
        enum params: String, _StringRawRepresentable {
            case isLoading = "setIsLoading(_isLoading:Bool).isLoading"
        }
    }

    // MARK: - setDelegate

    func setDelegate(_ delegate: HomeControllerDelegate) {
        let functionName = setDelegate2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate2.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate2: String, _StringRawRepresentable {
        case name = "setDelegate2"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:HomeControllerDelegate).delegate"
        }
    }

    // MARK: - refreshUI

    func refreshUI() {
        let functionName = refreshUI3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum refreshUI3: String, _StringRawRepresentable {
        case name = "refreshUI3"
    }
}

class MockHomeViewController: NSObject, HomeViewControlling {
    var viewState: MainViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: MainViewStating?
    var _viewStateHistory: [_Variable<MainViewStating?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: HomeViewControllerDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate1: String, _StringRawRepresentable {
        case name = "setDelegate1"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:HomeViewControllerDelegate).delegate"
        }
    }

    // MARK: - present

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        let functionName = present2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewControllerToPresent, forKey: present2.params.viewControllerToPresent)
        invocation.set(parameter: flag, forKey: present2.params.flag)
        if let completion = completion {
            invocation.set(parameter: completion, forKey: present2.params.completion)
        }
        invocations.record(invocation)
    }

    enum present2: String, _StringRawRepresentable {
        case name = "present2"
        enum params: String, _StringRawRepresentable {
            case viewControllerToPresent = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).viewControllerToPresent"
            case flag = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).flag"
            case completion = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).completion"
        }
    }
}

class MockListController: NSObject, ListControlling {
    var documentCount: Int {
        get { return _documentCount }
        set(value) { _documentCount = value; _documentCountHistory.append(_Variable(value)) }
    }
    var _documentCount: Int!
    var _documentCountHistory: [_Variable<Int?>] = []
    var list: PDFList {
        get { return _list }
        set(value) { _list = value; _listHistory.append(_Variable(value)) }
    }
    var _list: PDFList!
    var _listHistory: [_Variable<PDFList?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - openList

    func openList(_ list: PDFList) {
        let functionName = openList1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: list, forKey: openList1.params.list)
        invocations.record(invocation)
    }

    enum openList1: String, _StringRawRepresentable {
        case name = "openList1"
        enum params: String, _StringRawRepresentable {
            case list = "openList(_list:PDFList).list"
        }
    }
}

class MockNamingController: NSObject, NamingControlling {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - getName

    func getName() -> Async<String> {
        let functionName = getName1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<String>
    }

    enum getName1: String, _StringRawRepresentable {
        case name = "getName1"
    }
}

class MockOptionsController: NSObject, OptionsControlling {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: OptionsControllerDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate1: String, _StringRawRepresentable {
        case name = "setDelegate1"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:OptionsControllerDelegate).delegate"
        }
    }

    // MARK: - displayOptions

    func displayOptions() {
        let functionName = displayOptions2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum displayOptions2: String, _StringRawRepresentable {
        case name = "displayOptions2"
    }
}

class MockPDFController: NSObject, PDFControlling {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - deletePDFs

    func deletePDFs(at paths: [URL]) -> Async<Void> {
        let functionName = deletePDFs1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: paths, forKey: deletePDFs1.params.paths)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum deletePDFs1: String, _StringRawRepresentable {
        case name = "deletePDFs1"
        enum params: String, _StringRawRepresentable {
            case paths = "deletePDFs(atpaths:[URL]).paths"
        }
    }

    // MARK: - makePDF

    func makePDF(fromPhotos photos: [UIImage], withName name: String) -> Async<Void> {
        let functionName = makePDF2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: photos, forKey: makePDF2.params.photos)
        invocation.set(parameter: name, forKey: makePDF2.params.name)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum makePDF2: String, _StringRawRepresentable {
        case name = "makePDF2"
        enum params: String, _StringRawRepresentable {
            case photos = "makePDF(fromPhotosphotos:[UIImage],withNamename:String).photos"
            case name = "makePDF(fromPhotosphotos:[UIImage],withNamename:String).name"
        }
    }
}

class MockPDFService: NSObject, PDFServicing {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - generateList

    func generateList() -> PDFList {
        let functionName = generateList1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.set(defaultReturnValue: PDFList(paths: []), for: functionName)
        return actions.returnValue(for: functionName) as! PDFList
    }

    enum generateList1: String, _StringRawRepresentable {
        case name = "generateList1"
    }

    // MARK: - deleteList

    func deleteList(_ list: PDFList) -> Result<Void> {
        let functionName = deleteList2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: list, forKey: deleteList2.params.list)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<Void>
    }

    enum deleteList2: String, _StringRawRepresentable {
        case name = "deleteList2"
        enum params: String, _StringRawRepresentable {
            case list = "deleteList(_list:PDFList).list"
        }
    }

    // MARK: - generatePDF

    func generatePDF(_ pdf: PDF) -> Async<Void> {
        let functionName = generatePDF3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: pdf, forKey: generatePDF3.params.pdf)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum generatePDF3: String, _StringRawRepresentable {
        case name = "generatePDF3"
        enum params: String, _StringRawRepresentable {
            case pdf = "generatePDF(_pdf:PDF).pdf"
        }
    }
}

class MockPDFViewController: NSObject, PDFViewControlling {
    var viewState: PDFViewStating {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: PDFViewStating!
    var _viewStateHistory: [_Variable<PDFViewStating?>] = []
    var asViewController: UIViewController {
        get { return _asViewController }
        set(value) { _asViewController = value; _asViewControllerHistory.append(_Variable(value)) }
    }
    var _asViewController: UIViewController! = UIViewController()
    var _asViewControllerHistory: [_Variable<UIViewController?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: PDFViewControllerDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate1: String, _StringRawRepresentable {
        case name = "setDelegate1"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:PDFViewControllerDelegate).delegate"
        }
    }

    // MARK: - present

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        let functionName = present2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewControllerToPresent, forKey: present2.params.viewControllerToPresent)
        invocation.set(parameter: flag, forKey: present2.params.flag)
        if let completion = completion {
            invocation.set(parameter: completion, forKey: present2.params.completion)
        }
        invocations.record(invocation)
    }

    enum present2: String, _StringRawRepresentable {
        case name = "present2"
        enum params: String, _StringRawRepresentable {
            case viewControllerToPresent = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).viewControllerToPresent"
            case flag = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).flag"
            case completion = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).completion"
        }
    }
}

class MockShareController: NSObject, ShareControlling {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - shareItems

    func shareItems(_ items: [URL]) {
        let functionName = shareItems1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: items, forKey: shareItems1.params.items)
        invocations.record(invocation)
    }

    enum shareItems1: String, _StringRawRepresentable {
        case name = "shareItems1"
        enum params: String, _StringRawRepresentable {
            case items = "shareItems(_items:[URL]).items"
        }
    }
}
