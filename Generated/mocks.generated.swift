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
import CoreData
@testable import EasyLife
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
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - start

    func start() {
        let functionName = start1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum start1: String, _StringRawRepresentable {
        case name = "start1"
    }

    // MARK: - applicationWillTerminate

    func applicationWillTerminate() {
        let functionName = applicationWillTerminate2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum applicationWillTerminate2: String, _StringRawRepresentable {
        case name = "applicationWillTerminate2"
    }
}

class MockAppRouting: NSObject, AppRouting {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - start

    func start() {
        let functionName = start1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum start1: String, _StringRawRepresentable {
        case name = "start1"
    }

    // MARK: - handleSegue

    func handleSegue(_ segue: UIStoryboardSegue) {
        let functionName = handleSegue2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: segue, forKey: handleSegue2.params.segue)
        invocations.record(invocation)
    }

    enum handleSegue2: String, _StringRawRepresentable {
        case name = "handleSegue2"
        enum params: String, _StringRawRepresentable {
            case segue = "handleSegue(_segue:UIStoryboardSegue).segue"
        }
    }
}

class MockArchiveCell: NSObject, ArchiveCelling {
    var viewState: ArchiveCellViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: ArchiveCellViewStating?
    var _viewStateHistory: [_Variable<ArchiveCellViewStating?>] = []
}

class MockArchiveController: NSObject, ArchiveControlling {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: ArchiveControllerDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate1: String, _StringRawRepresentable {
        case name = "setDelegate1"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:ArchiveControllerDelegate).delegate"
        }
    }

    // MARK: - setViewController

    func setViewController(_ viewController: ArchiveViewControlling) {
        let functionName = setViewController2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewController, forKey: setViewController2.params.viewController)
        invocations.record(invocation)
    }

    enum setViewController2: String, _StringRawRepresentable {
        case name = "setViewController2"
        enum params: String, _StringRawRepresentable {
            case viewController = "setViewController(_viewController:ArchiveViewControlling).viewController"
        }
    }

    // MARK: - setAlertController

    func setAlertController(_ alertController: AlertControlling) {
        let functionName = setAlertController3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: alertController, forKey: setAlertController3.params.alertController)
        invocations.record(invocation)
    }

    enum setAlertController3: String, _StringRawRepresentable {
        case name = "setAlertController3"
        enum params: String, _StringRawRepresentable {
            case alertController = "setAlertController(_alertController:AlertControlling).alertController"
        }
    }
}

class MockArchiveCoordinator: NSObject, ArchiveCoordinating {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setNavigationController

    func setNavigationController(_ navigationController: UINavigationController) {
        let functionName = setNavigationController1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: navigationController, forKey: setNavigationController1.params.navigationController)
        invocations.record(invocation)
    }

    enum setNavigationController1: String, _StringRawRepresentable {
        case name = "setNavigationController1"
        enum params: String, _StringRawRepresentable {
            case navigationController = "setNavigationController(_navigationController:UINavigationController).navigationController"
        }
    }

    // MARK: - setViewController

    func setViewController(_ viewController: ArchiveViewControlling) {
        let functionName = setViewController2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewController, forKey: setViewController2.params.viewController)
        invocations.record(invocation)
    }

    enum setViewController2: String, _StringRawRepresentable {
        case name = "setViewController2"
        enum params: String, _StringRawRepresentable {
            case viewController = "setViewController(_viewController:ArchiveViewControlling).viewController"
        }
    }

    // MARK: - setAlertController

    func setAlertController(_ alertController: AlertControlling) {
        let functionName = setAlertController3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: alertController, forKey: setAlertController3.params.alertController)
        invocations.record(invocation)
    }

    enum setAlertController3: String, _StringRawRepresentable {
        case name = "setAlertController3"
        enum params: String, _StringRawRepresentable {
            case alertController = "setAlertController(_alertController:AlertControlling).alertController"
        }
    }
}

class MockArchiveRepository: NSObject, ArchiveRepositoring {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - undo

    func undo(item: TodoItem) -> Async<Void> {
        let functionName = undo1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: undo1.params.item)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum undo1: String, _StringRawRepresentable {
        case name = "undo1"
        enum params: String, _StringRawRepresentable {
            case item = "undo(item:TodoItem).item"
        }
    }

    // MARK: - clearAll

    func clearAll(items: [TodoItem]) -> Async<Void> {
        let functionName = clearAll2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: items, forKey: clearAll2.params.items)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum clearAll2: String, _StringRawRepresentable {
        case name = "clearAll2"
        enum params: String, _StringRawRepresentable {
            case items = "clearAll(items:[TodoItem]).items"
        }
    }

    // MARK: - fetchItems

    func fetchItems() -> Async<[TodoItem]> {
        let functionName = fetchItems3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<[TodoItem]>
    }

    enum fetchItems3: String, _StringRawRepresentable {
        case name = "fetchItems3"
    }
}

class MockArchiveViewControlling: NSObject, ArchiveViewControlling {
    var viewState: ArchiveViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: ArchiveViewStating?
    var _viewStateHistory: [_Variable<ArchiveViewStating?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: ArchiveViewControllerDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate1: String, _StringRawRepresentable {
        case name = "setDelegate1"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:ArchiveViewControllerDelegate).delegate"
        }
    }

    // MARK: - endEditing

    func endEditing() {
        let functionName = endEditing2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum endEditing2: String, _StringRawRepresentable {
        case name = "endEditing2"
    }

    // MARK: - present

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        let functionName = present3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewControllerToPresent, forKey: present3.params.viewControllerToPresent)
        invocation.set(parameter: flag, forKey: present3.params.flag)
        if let completion = completion {
            invocation.set(parameter: completion, forKey: present3.params.completion)
        }
        invocations.record(invocation)
    }

    enum present3: String, _StringRawRepresentable {
        case name = "present3"
        enum params: String, _StringRawRepresentable {
            case viewControllerToPresent = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).viewControllerToPresent"
            case flag = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).flag"
            case completion = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).completion"
        }
    }
}

class MockBadge: NSObject, Badge {
    var number: Int {
        get { return _number }
        set(value) { _number = value; _numberHistory.append(_Variable(value)) }
    }
    var _number: Int!
    var _numberHistory: [_Variable<Int?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setNumber

    func setNumber(_ number: Int) -> Async<Void> {
        let functionName = setNumber1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: number, forKey: setNumber1.params.number)
        invocations.record(invocation)
        actions.set(defaultReturnValue: Async.success(()), for: functionName)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum setNumber1: String, _StringRawRepresentable {
        case name = "setNumber1"
        enum params: String, _StringRawRepresentable {
            case number = "setNumber(_number:Int).number"
        }
    }
}

class MockBlockedByController: NSObject, BlockedByControlling {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setViewController

    func setViewController(_ viewController: BlockedByViewControlling) {
        let functionName = setViewController1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewController, forKey: setViewController1.params.viewController)
        invocations.record(invocation)
    }

    enum setViewController1: String, _StringRawRepresentable {
        case name = "setViewController1"
        enum params: String, _StringRawRepresentable {
            case viewController = "setViewController(_viewController:BlockedByViewControlling).viewController"
        }
    }

    // MARK: - setAlertController

    func setAlertController(_ alertController: AlertControlling) {
        let functionName = setAlertController2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: alertController, forKey: setAlertController2.params.alertController)
        invocations.record(invocation)
    }

    enum setAlertController2: String, _StringRawRepresentable {
        case name = "setAlertController2"
        enum params: String, _StringRawRepresentable {
            case alertController = "setAlertController(_alertController:AlertControlling).alertController"
        }
    }

    // MARK: - setItem

    func setItem(_ item: TodoItem) {
        let functionName = setItem3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: setItem3.params.item)
        invocations.record(invocation)
    }

    enum setItem3: String, _StringRawRepresentable {
        case name = "setItem3"
        enum params: String, _StringRawRepresentable {
            case item = "setItem(_item:TodoItem).item"
        }
    }
}

class MockBlockedByRepository: NSObject, BlockedByRepositoring {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - fetchItems

    func fetchItems(for item: TodoItem) -> Async<[TodoItem]> {
        let functionName = fetchItems1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: fetchItems1.params.item)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<[TodoItem]>
    }

    enum fetchItems1: String, _StringRawRepresentable {
        case name = "fetchItems1"
        enum params: String, _StringRawRepresentable {
            case item = "fetchItems(foritem:TodoItem).item"
        }
    }
}

class MockBlockedByViewControlling: NSObject, BlockedByViewControlling {
    var viewState: BlockedByViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: BlockedByViewStating?
    var _viewStateHistory: [_Variable<BlockedByViewStating?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: BlockedByViewControllerDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate1: String, _StringRawRepresentable {
        case name = "setDelegate1"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:BlockedByViewControllerDelegate).delegate"
        }
    }

    // MARK: - reload

    func reload() {
        let functionName = reload2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum reload2: String, _StringRawRepresentable {
        case name = "reload2"
    }

    // MARK: - reloadRows

    func reloadRows(at indexPath: IndexPath) {
        let functionName = reloadRows3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: indexPath, forKey: reloadRows3.params.indexPath)
        invocations.record(invocation)
    }

    enum reloadRows3: String, _StringRawRepresentable {
        case name = "reloadRows3"
        enum params: String, _StringRawRepresentable {
            case indexPath = "reloadRows(atindexPath:IndexPath).indexPath"
        }
    }

    // MARK: - present

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        let functionName = present4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewControllerToPresent, forKey: present4.params.viewControllerToPresent)
        invocation.set(parameter: flag, forKey: present4.params.flag)
        if let completion = completion {
            invocation.set(parameter: completion, forKey: present4.params.completion)
        }
        invocations.record(invocation)
    }

    enum present4: String, _StringRawRepresentable {
        case name = "present4"
        enum params: String, _StringRawRepresentable {
            case viewControllerToPresent = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).viewControllerToPresent"
            case flag = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).flag"
            case completion = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).completion"
        }
    }
}

class MockBlockedCell: NSObject, BlockedCelling {
    var viewState: ProjectCellViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: ProjectCellViewStating?
    var _viewStateHistory: [_Variable<ProjectCellViewStating?>] = []
}

class MockBlockedIndicatorView: NSObject, BlockedIndicatorViewing {
    var viewState: BlockedIndicatorViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: BlockedIndicatorViewStating?
    var _viewStateHistory: [_Variable<BlockedIndicatorViewStating?>] = []
}

class MockCoreDataManaging: NSObject, CoreDataManaging {
    var isLoaded: Bool {
        get { return _isLoaded }
        set(value) { _isLoaded = value; _isLoadedHistory.append(_Variable(value)) }
    }
    var _isLoaded: Bool!
    var _isLoadedHistory: [_Variable<Bool?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - insert<T: NSManagedObject>

    func insert<T: NSManagedObject>(entityClass: T.Type, context: CoreDataContext) -> T {
        let functionName = insert1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: entityClass, forKey: insert1.params.entityClass)
        invocation.set(parameter: context, forKey: insert1.params.context)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! T
    }

    enum insert1: String, _StringRawRepresentable {
        case name = "insert1"
        enum params: String, _StringRawRepresentable {
            case entityClass = "insert<T:NSManagedObject>(entityClass:T.Type,context:CoreDataContext).entityClass"
            case context = "insert<T:NSManagedObject>(entityClass:T.Type,context:CoreDataContext).context"
        }
    }

    // MARK: - insertTransient<T: NSManagedObject>

    func insertTransient<T: NSManagedObject>(entityClass: T.Type, context: CoreDataContext) -> Result<T> {
        let functionName = insertTransient2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: entityClass, forKey: insertTransient2.params.entityClass)
        invocation.set(parameter: context, forKey: insertTransient2.params.context)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<T>
    }

    enum insertTransient2: String, _StringRawRepresentable {
        case name = "insertTransient2"
        enum params: String, _StringRawRepresentable {
            case entityClass = "insertTransient<T:NSManagedObject>(entityClass:T.Type,context:CoreDataContext).entityClass"
            case context = "insertTransient<T:NSManagedObject>(entityClass:T.Type,context:CoreDataContext).context"
        }
    }

    // MARK: - copy<T: NSManagedObject>

    func copy<T: NSManagedObject>(_ entity: T, context: CoreDataContext) -> Result<T> {
        let functionName = copy3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: entity, forKey: copy3.params.entity)
        invocation.set(parameter: context, forKey: copy3.params.context)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<T>
    }

    enum copy3: String, _StringRawRepresentable {
        case name = "copy3"
        enum params: String, _StringRawRepresentable {
            case entity = "copy<T:NSManagedObject>(_entity:T,context:CoreDataContext).entity"
            case context = "copy<T:NSManagedObject>(_entity:T,context:CoreDataContext).context"
        }
    }

    // MARK: - delete<T: NSManagedObject>

    func delete<T: NSManagedObject>(_ entity: T, context: CoreDataContext) {
        let functionName = delete4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: entity, forKey: delete4.params.entity)
        invocation.set(parameter: context, forKey: delete4.params.context)
        invocations.record(invocation)
    }

    enum delete4: String, _StringRawRepresentable {
        case name = "delete4"
        enum params: String, _StringRawRepresentable {
            case entity = "delete<T:NSManagedObject>(_entity:T,context:CoreDataContext).entity"
            case context = "delete<T:NSManagedObject>(_entity:T,context:CoreDataContext).context"
        }
    }

    // MARK: - fetch<T: NSManagedObject>

    func fetch<T: NSManagedObject>(entityClass: T.Type, sortBy: [NSSortDescriptor]?, context: CoreDataContext, predicate: NSPredicate?) -> Async<[T]> {
        let functionName = fetch5.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: entityClass, forKey: fetch5.params.entityClass)
        if let sortBy = sortBy {
            invocation.set(parameter: sortBy, forKey: fetch5.params.sortBy)
        }
        invocation.set(parameter: context, forKey: fetch5.params.context)
        if let predicate = predicate {
            invocation.set(parameter: predicate, forKey: fetch5.params.predicate)
        }
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<[T]>
    }

    enum fetch5: String, _StringRawRepresentable {
        case name = "fetch5"
        enum params: String, _StringRawRepresentable {
            case entityClass = "fetch<T:NSManagedObject>(entityClass:T.Type,sortBy:[NSSortDescriptor]?,context:CoreDataContext,predicate:NSPredicate?).entityClass"
            case sortBy = "fetch<T:NSManagedObject>(entityClass:T.Type,sortBy:[NSSortDescriptor]?,context:CoreDataContext,predicate:NSPredicate?).sortBy"
            case context = "fetch<T:NSManagedObject>(entityClass:T.Type,sortBy:[NSSortDescriptor]?,context:CoreDataContext,predicate:NSPredicate?).context"
            case predicate = "fetch<T:NSManagedObject>(entityClass:T.Type,sortBy:[NSSortDescriptor]?,context:CoreDataContext,predicate:NSPredicate?).predicate"
        }
    }

    // MARK: - load

    func load() -> Async<Void> {
        let functionName = load6.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum load6: String, _StringRawRepresentable {
        case name = "load6"
    }

    // MARK: - save

    func save(context: CoreDataContext) -> Async<Void> {
        let functionName = save7.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: context, forKey: save7.params.context)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum save7: String, _StringRawRepresentable {
        case name = "save7"
        enum params: String, _StringRawRepresentable {
            case context = "save(context:CoreDataContext).context"
        }
    }

    // MARK: - reset

    func reset() -> Async<Void> {
        let functionName = reset8.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum reset8: String, _StringRawRepresentable {
        case name = "reset8"
    }
}

class MockFatalViewControlling: NSObject, FatalViewControlling {
    var viewState: FatalViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: FatalViewStating?
    var _viewStateHistory: [_Variable<FatalViewStating?>] = []
}

class MockItemDetailController: NSObject, ItemDetailControlling {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setViewController

    func setViewController(_ viewController: ItemDetailViewControlling) {
        let functionName = setViewController1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewController, forKey: setViewController1.params.viewController)
        invocations.record(invocation)
    }

    enum setViewController1: String, _StringRawRepresentable {
        case name = "setViewController1"
        enum params: String, _StringRawRepresentable {
            case viewController = "setViewController(_viewController:ItemDetailViewControlling).viewController"
        }
    }

    // MARK: - setAlertController

    func setAlertController(_ alertController: AlertControlling) {
        let functionName = setAlertController2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: alertController, forKey: setAlertController2.params.alertController)
        invocations.record(invocation)
    }

    enum setAlertController2: String, _StringRawRepresentable {
        case name = "setAlertController2"
        enum params: String, _StringRawRepresentable {
            case alertController = "setAlertController(_alertController:AlertControlling).alertController"
        }
    }

    // MARK: - setDelegate

    func setDelegate(_ delegate: ItemDetailControllerDelegate) {
        let functionName = setDelegate3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate3.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate3: String, _StringRawRepresentable {
        case name = "setDelegate3"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:ItemDetailControllerDelegate).delegate"
        }
    }

    // MARK: - setItem

    func setItem(_ item: TodoItem) {
        let functionName = setItem4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: setItem4.params.item)
        invocations.record(invocation)
    }

    enum setItem4: String, _StringRawRepresentable {
        case name = "setItem4"
        enum params: String, _StringRawRepresentable {
            case item = "setItem(_item:TodoItem).item"
        }
    }
}

class MockItemDetailRepository: NSObject, ItemDetailRepositoring {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - fetchItems

    func fetchItems(for item: TodoItem) -> Async<[TodoItem]> {
        let functionName = fetchItems1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: fetchItems1.params.item)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<[TodoItem]>
    }

    enum fetchItems1: String, _StringRawRepresentable {
        case name = "fetchItems1"
        enum params: String, _StringRawRepresentable {
            case item = "fetchItems(foritem:TodoItem).item"
        }
    }

    // MARK: - fetchProjects

    func fetchProjects(for item: TodoItem) -> Async<[Project]> {
        let functionName = fetchProjects2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: fetchProjects2.params.item)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<[Project]>
    }

    enum fetchProjects2: String, _StringRawRepresentable {
        case name = "fetchProjects2"
        enum params: String, _StringRawRepresentable {
            case item = "fetchProjects(foritem:TodoItem).item"
        }
    }

    // MARK: - save

    func save(item: TodoItem) -> Async<Void> {
        let functionName = save3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: save3.params.item)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum save3: String, _StringRawRepresentable {
        case name = "save3"
        enum params: String, _StringRawRepresentable {
            case item = "save(item:TodoItem).item"
        }
    }

    // MARK: - delete

    func delete(item: TodoItem) -> Async<Void> {
        let functionName = delete4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: delete4.params.item)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum delete4: String, _StringRawRepresentable {
        case name = "delete4"
        enum params: String, _StringRawRepresentable {
            case item = "delete(item:TodoItem).item"
        }
    }
}

class MockItemDetailViewControlling: NSObject, ItemDetailViewControlling {
    var viewState: ItemDetailViewState? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: ItemDetailViewState?
    var _viewStateHistory: [_Variable<ItemDetailViewState?>] = []
    var responders: [UIResponder]! {
        get { return _responders }
        set(value) { _responders = value; _respondersHistory.append(_Variable(value)) }
    }
    var _responders: [UIResponder]! = []
    var _respondersHistory: [_Variable<[UIResponder]?>] = []
    var currentResponder: UIResponder? {
        get { return _currentResponder }
        set(value) { _currentResponder = value; _currentResponderHistory.append(_Variable(value)) }
    }
    var _currentResponder: UIResponder? = UIResponder()
    var _currentResponderHistory: [_Variable<UIResponder?>] = []
    var nextResponderInArray: UIResponder? {
        get { return _nextResponderInArray }
        set(value) { _nextResponderInArray = value; _nextResponderInArrayHistory.append(_Variable(value)) }
    }
    var _nextResponderInArray: UIResponder? = UIResponder()
    var _nextResponderInArrayHistory: [_Variable<UIResponder?>] = []
    var previousResponderInArray: UIResponder? {
        get { return _previousResponderInArray }
        set(value) { _previousResponderInArray = value; _previousResponderInArrayHistory.append(_Variable(value)) }
    }
    var _previousResponderInArray: UIResponder? = UIResponder()
    var _previousResponderInArrayHistory: [_Variable<UIResponder?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: ItemDetailViewControllerDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate1: String, _StringRawRepresentable {
        case name = "setDelegate1"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:ItemDetailViewControllerDelegate).delegate"
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

    // MARK: - nextResponderBecomeFirst

    func nextResponderBecomeFirst() {
        let functionName = nextResponderBecomeFirst3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum nextResponderBecomeFirst3: String, _StringRawRepresentable {
        case name = "nextResponderBecomeFirst3"
    }

    // MARK: - previousResponderBecomeFirst

    func previousResponderBecomeFirst() {
        let functionName = previousResponderBecomeFirst4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum previousResponderBecomeFirst4: String, _StringRawRepresentable {
        case name = "previousResponderBecomeFirst4"
    }
}

class MockPlanCell: NSObject, PlanCellable {
    var viewState: PlanCellViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: PlanCellViewStating?
    var _viewStateHistory: [_Variable<PlanCellViewStating?>] = []
}

class MockPlanController: NSObject, PlanControlling {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - start

    func start() {
        let functionName = start1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum start1: String, _StringRawRepresentable {
        case name = "start1"
    }

    // MARK: - setDelegate

    func setDelegate(_ delegate: PlanControllerDelegate) {
        let functionName = setDelegate2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate2.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate2: String, _StringRawRepresentable {
        case name = "setDelegate2"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:PlanControllerDelegate).delegate"
        }
    }

    // MARK: - setStoryboardRouter

    func setStoryboardRouter(_ router: StoryboardRouting) {
        let functionName = setStoryboardRouter3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: router, forKey: setStoryboardRouter3.params.router)
        invocations.record(invocation)
    }

    enum setStoryboardRouter3: String, _StringRawRepresentable {
        case name = "setStoryboardRouter3"
        enum params: String, _StringRawRepresentable {
            case router = "setStoryboardRouter(_router:StoryboardRouting).router"
        }
    }
}

class MockPlanCoordinator: NSObject, PlanCoordinating {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - start

    func start() {
        let functionName = start1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum start1: String, _StringRawRepresentable {
        case name = "start1"
    }
}

class MockPlanRepository: NSObject, PlanRepositoring {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - newItem

    func newItem() -> Result<TodoItem> {
        let functionName = newItem1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<TodoItem>
    }

    enum newItem1: String, _StringRawRepresentable {
        case name = "newItem1"
    }

    // MARK: - fetchMissedItems

    func fetchMissedItems() -> Async<[TodoItem]> {
        let functionName = fetchMissedItems2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<[TodoItem]>
    }

    enum fetchMissedItems2: String, _StringRawRepresentable {
        case name = "fetchMissedItems2"
    }

    // MARK: - fetchLaterItems

    func fetchLaterItems() -> Async<[TodoItem]> {
        let functionName = fetchLaterItems3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<[TodoItem]>
    }

    enum fetchLaterItems3: String, _StringRawRepresentable {
        case name = "fetchLaterItems3"
    }

    // MARK: - fetchTodayItems

    func fetchTodayItems() -> Async<[TodoItem]> {
        let functionName = fetchTodayItems4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<[TodoItem]>
    }

    enum fetchTodayItems4: String, _StringRawRepresentable {
        case name = "fetchTodayItems4"
    }

    // MARK: - delete

    func delete(item: TodoItem) -> Async<Void> {
        let functionName = delete5.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: delete5.params.item)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum delete5: String, _StringRawRepresentable {
        case name = "delete5"
        enum params: String, _StringRawRepresentable {
            case item = "delete(item:TodoItem).item"
        }
    }

    // MARK: - later

    func later(item: TodoItem) -> Async<Void> {
        let functionName = later6.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: later6.params.item)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum later6: String, _StringRawRepresentable {
        case name = "later6"
        enum params: String, _StringRawRepresentable {
            case item = "later(item:TodoItem).item"
        }
    }

    // MARK: - done

    func done(item: TodoItem) -> Async<Void> {
        let functionName = done7.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: done7.params.item)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum done7: String, _StringRawRepresentable {
        case name = "done7"
        enum params: String, _StringRawRepresentable {
            case item = "done(item:TodoItem).item"
        }
    }

    // MARK: - split

    func split(item: TodoItem) -> Async<Void> {
        let functionName = split8.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: split8.params.item)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum split8: String, _StringRawRepresentable {
        case name = "split8"
        enum params: String, _StringRawRepresentable {
            case item = "split(item:TodoItem).item"
        }
    }
}

class MockPlanViewController: NSObject, PlanViewControlling {
    var viewState: PlanViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: PlanViewStating?
    var _viewStateHistory: [_Variable<PlanViewStating?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: PlanViewControllerDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate1: String, _StringRawRepresentable {
        case name = "setDelegate1"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:PlanViewControllerDelegate).delegate"
        }
    }

    // MARK: - setTableHeaderAnimation

    func setTableHeaderAnimation(_ animation: RepeatColorViewAnimation) {
        let functionName = setTableHeaderAnimation2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: animation, forKey: setTableHeaderAnimation2.params.animation)
        invocations.record(invocation)
    }

    enum setTableHeaderAnimation2: String, _StringRawRepresentable {
        case name = "setTableHeaderAnimation2"
        enum params: String, _StringRawRepresentable {
            case animation = "setTableHeaderAnimation(_animation:RepeatColorViewAnimation).animation"
        }
    }

    // MARK: - setIsTableHeaderAnimating

    func setIsTableHeaderAnimating(_ isAnimating: Bool) {
        let functionName = setIsTableHeaderAnimating3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: isAnimating, forKey: setIsTableHeaderAnimating3.params.isAnimating)
        invocations.record(invocation)
    }

    enum setIsTableHeaderAnimating3: String, _StringRawRepresentable {
        case name = "setIsTableHeaderAnimating3"
        enum params: String, _StringRawRepresentable {
            case isAnimating = "setIsTableHeaderAnimating(_isAnimating:Bool).isAnimating"
        }
    }

    // MARK: - present

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        let functionName = present4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewControllerToPresent, forKey: present4.params.viewControllerToPresent)
        invocation.set(parameter: flag, forKey: present4.params.flag)
        if let completion = completion {
            invocation.set(parameter: completion, forKey: present4.params.completion)
        }
        invocations.record(invocation)
    }

    enum present4: String, _StringRawRepresentable {
        case name = "present4"
        enum params: String, _StringRawRepresentable {
            case viewControllerToPresent = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).viewControllerToPresent"
            case flag = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).flag"
            case completion = "present(_viewControllerToPresent:UIViewController,animatedflag:Bool,completion:(()->Void)?).completion"
        }
    }

    // MARK: - performSegue

    func performSegue(withIdentifier identifier: String, sender: Any?) {
        let functionName = performSegue5.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: identifier, forKey: performSegue5.params.identifier)
        if let sender = sender {
            invocation.set(parameter: sender, forKey: performSegue5.params.sender)
        }
        invocations.record(invocation)
    }

    enum performSegue5: String, _StringRawRepresentable {
        case name = "performSegue5"
        enum params: String, _StringRawRepresentable {
            case identifier = "performSegue(withIdentifieridentifier:String,sender:Any?).identifier"
            case sender = "performSegue(withIdentifieridentifier:String,sender:Any?).sender"
        }
    }
}

class MockProjectCell: NSObject, ProjectCelling {
    var viewState: ProjectCellViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: ProjectCellViewStating?
    var _viewStateHistory: [_Variable<ProjectCellViewStating?>] = []
}

class MockProjectsControlling: NSObject, ProjectsControlling {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setViewController

    func setViewController(_ viewController: ProjectsViewControlling) {
        let functionName = setViewController1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewController, forKey: setViewController1.params.viewController)
        invocations.record(invocation)
    }

    enum setViewController1: String, _StringRawRepresentable {
        case name = "setViewController1"
        enum params: String, _StringRawRepresentable {
            case viewController = "setViewController(_viewController:ProjectsViewControlling).viewController"
        }
    }

    // MARK: - setAlertController

    func setAlertController(_ alertController: AlertControlling) {
        let functionName = setAlertController2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: alertController, forKey: setAlertController2.params.alertController)
        invocations.record(invocation)
    }

    enum setAlertController2: String, _StringRawRepresentable {
        case name = "setAlertController2"
        enum params: String, _StringRawRepresentable {
            case alertController = "setAlertController(_alertController:AlertControlling).alertController"
        }
    }

    // MARK: - setDelegate

    func setDelegate(_ delegate: ProjectsControllerDelegate) {
        let functionName = setDelegate3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate3.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate3: String, _StringRawRepresentable {
        case name = "setDelegate3"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:ProjectsControllerDelegate).delegate"
        }
    }
}

class MockProjectsCoordinator: NSObject, ProjectsCoordinating {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setNavigationController

    func setNavigationController(_ navigationController: UINavigationController) {
        let functionName = setNavigationController1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: navigationController, forKey: setNavigationController1.params.navigationController)
        invocations.record(invocation)
    }

    enum setNavigationController1: String, _StringRawRepresentable {
        case name = "setNavigationController1"
        enum params: String, _StringRawRepresentable {
            case navigationController = "setNavigationController(_navigationController:UINavigationController).navigationController"
        }
    }

    // MARK: - setViewController

    func setViewController(_ viewController: ProjectsViewControlling) {
        let functionName = setViewController2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewController, forKey: setViewController2.params.viewController)
        invocations.record(invocation)
    }

    enum setViewController2: String, _StringRawRepresentable {
        case name = "setViewController2"
        enum params: String, _StringRawRepresentable {
            case viewController = "setViewController(_viewController:ProjectsViewControlling).viewController"
        }
    }

    // MARK: - setAlertController

    func setAlertController(_ alertController: AlertControlling) {
        let functionName = setAlertController3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: alertController, forKey: setAlertController3.params.alertController)
        invocations.record(invocation)
    }

    enum setAlertController3: String, _StringRawRepresentable {
        case name = "setAlertController3"
        enum params: String, _StringRawRepresentable {
            case alertController = "setAlertController(_alertController:AlertControlling).alertController"
        }
    }
}

class MockProjectsRepository: NSObject, ProjectsRepositoring {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - delete

    func delete(project: Project) -> Async<Void> {
        let functionName = delete1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: project, forKey: delete1.params.project)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum delete1: String, _StringRawRepresentable {
        case name = "delete1"
        enum params: String, _StringRawRepresentable {
            case project = "delete(project:Project).project"
        }
    }

    // MARK: - addProject

    func addProject(name: String) -> Async<Project> {
        let functionName = addProject2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: name, forKey: addProject2.params.name)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Project>
    }

    enum addProject2: String, _StringRawRepresentable {
        case name = "addProject2"
        enum params: String, _StringRawRepresentable {
            case name = "addProject(name:String).name"
        }
    }

    // MARK: - updateName

    func updateName(_ name: String, for project: Project) -> Async<Void> {
        let functionName = updateName3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: name, forKey: updateName3.params.name)
        invocation.set(parameter: project, forKey: updateName3.params.project)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum updateName3: String, _StringRawRepresentable {
        case name = "updateName3"
        enum params: String, _StringRawRepresentable {
            case name = "updateName(_name:String,forproject:Project).name"
            case project = "updateName(_name:String,forproject:Project).project"
        }
    }

    // MARK: - prioritize

    func prioritize(project: Project, max: Int) -> Async<Void> {
        let functionName = prioritize4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: project, forKey: prioritize4.params.project)
        invocation.set(parameter: max, forKey: prioritize4.params.max)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum prioritize4: String, _StringRawRepresentable {
        case name = "prioritize4"
        enum params: String, _StringRawRepresentable {
            case project = "prioritize(project:Project,max:Int).project"
            case max = "prioritize(project:Project,max:Int).max"
        }
    }

    // MARK: - prioritise

    func prioritise(_ projectA: Project, above projectB: Project) -> Async<Void> {
        let functionName = prioritise5.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: projectA, forKey: prioritise5.params.projectA)
        invocation.set(parameter: projectB, forKey: prioritise5.params.projectB)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum prioritise5: String, _StringRawRepresentable {
        case name = "prioritise5"
        enum params: String, _StringRawRepresentable {
            case projectA = "prioritise(_projectA:Project,aboveprojectB:Project).projectA"
            case projectB = "prioritise(_projectA:Project,aboveprojectB:Project).projectB"
        }
    }

    // MARK: - prioritise

    func prioritise(_ projectA: Project, below projectB: Project) -> Async<Void> {
        let functionName = prioritise6.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: projectA, forKey: prioritise6.params.projectA)
        invocation.set(parameter: projectB, forKey: prioritise6.params.projectB)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum prioritise6: String, _StringRawRepresentable {
        case name = "prioritise6"
        enum params: String, _StringRawRepresentable {
            case projectA = "prioritise(_projectA:Project,belowprojectB:Project).projectA"
            case projectB = "prioritise(_projectA:Project,belowprojectB:Project).projectB"
        }
    }

    // MARK: - deprioritize

    func deprioritize(project: Project) -> Async<Void> {
        let functionName = deprioritize7.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: project, forKey: deprioritize7.params.project)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<Void>
    }

    enum deprioritize7: String, _StringRawRepresentable {
        case name = "deprioritize7"
        enum params: String, _StringRawRepresentable {
            case project = "deprioritize(project:Project).project"
        }
    }

    // MARK: - fetchPrioritizedProjects

    func fetchPrioritizedProjects() -> Async<[Project]> {
        let functionName = fetchPrioritizedProjects8.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<[Project]>
    }

    enum fetchPrioritizedProjects8: String, _StringRawRepresentable {
        case name = "fetchPrioritizedProjects8"
    }

    // MARK: - fetchOtherProjects

    func fetchOtherProjects() -> Async<[Project]> {
        let functionName = fetchOtherProjects9.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<[Project]>
    }

    enum fetchOtherProjects9: String, _StringRawRepresentable {
        case name = "fetchOtherProjects9"
    }
}

class MockProjectsViewControlling: NSObject, ProjectsViewControlling {
    var viewState: ProjectsViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: ProjectsViewStating?
    var _viewStateHistory: [_Variable<ProjectsViewStating?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: ProjectsViewControllerDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate1: String, _StringRawRepresentable {
        case name = "setDelegate1"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:ProjectsViewControllerDelegate).delegate"
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

class MockSimpleDatePicker: NSObject, SimpleDatePickering {
    var viewState: SimpleDatePickerViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: SimpleDatePickerViewStating?
    var _viewStateHistory: [_Variable<SimpleDatePickerViewStating?>] = []
}

class MockTagView: NSObject, TagViewable {
    var viewState: TagViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: TagViewStating?
    var _viewStateHistory: [_Variable<TagViewStating?>] = []
}
