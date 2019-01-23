// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Are you sure?
  internal static let areYouSureAlertTitle = L10n.tr("Localizable", "are you sure alert title")
  /// Cancel
  internal static let cancelButtonTitle = L10n.tr("Localizable", "cancel button title")
  /// Delete all
  internal static let deleteAllOption = L10n.tr("Localizable", "delete all option")
  /// Delete
  internal static let deleteButtonTitle = L10n.tr("Localizable", "delete button title")
  /// Done
  internal static let doneButtonTitle = L10n.tr("Localizable", "done button title")
  /// Error
  internal static let errorAlertTitle = L10n.tr("Localizable", "error alert title")
  /// Something went wrong - please try again. If the problem persists, please contact the developer
  internal static let foobarAlertTitle = L10n.tr("Localizable", "foobar alert title")
  /// Message
  internal static let messageAlertTitle = L10n.tr("Localizable", "message alert title")
  /// What name would you like to give the document?
  internal static let newDocumentAlertMessage = L10n.tr("Localizable", "new document alert message")
  /// e.g. December Invoice
  internal static let newDocumentAlertPlaceholder = L10n.tr("Localizable", "new document alert placeholder")
  /// Document Name
  internal static let newDocumentAlertTitle = L10n.tr("Localizable", "new document alert title")
  /// No
  internal static let noButtonTitle = L10n.tr("Localizable", "no button title")
  /// Your camera is currently not available
  internal static let noCameraAlertTitle = L10n.tr("Localizable", "no camera alert title")
  /// OK
  internal static let okButtonTitle = L10n.tr("Localizable", "ok button title")
  /// The photo was not taken - there was a problem with the photo's orientation. Hold the camera upright and move from landscape, to portrait, to reset the orientation. Then try again
  internal static let photoNotTakenAlertTitle = L10n.tr("Localizable", "photo not taken alert title")
  /// %d photos
  internal static func photosLabel(_ p1: Int) -> String {
    return L10n.tr("Localizable", "photos label", p1)
  }
  /// Random
  internal static let randomButtonTitle = L10n.tr("Localizable", "random button title")
  /// Share all
  internal static let shareAllOption = L10n.tr("Localizable", "share all option")
  /// Take
  internal static let takeButtonTitle = L10n.tr("Localizable", "take button title")
  /// View all
  internal static let viewAllOption = L10n.tr("Localizable", "view all option")
  /// Warning
  internal static let warningAlertTitle = L10n.tr("Localizable", "warning alert title")
  /// Yes
  internal static let yesButtonTitle = L10n.tr("Localizable", "yes button title")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
