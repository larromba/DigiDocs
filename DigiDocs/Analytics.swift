//
//  Analytics.swift
//  EasyMusic
//
//  Created by Lee Arromba on 04/12/2015.
//  Copyright © 2015 Lee Arromba. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class Analytics {
    fileprivate(set) static var shared = Analytics()
    fileprivate var sessionStartDate: Date?
    fileprivate var isSetup: Bool
    fileprivate var AnalyticsType: FIRAnalytics.Type
    
    enum AnalyticsError: Error {
        case setup
    }
    
    init() {
        sessionStartDate = nil
        isSetup = false
        AnalyticsType = FIRAnalytics.self
    }
    
    // TESTING
    
    init(type: FIRAnalytics.Type, isSetup: Bool, sessionStartDate: Date) {
        self.sessionStartDate = sessionStartDate
        self.isSetup = isSetup
        self.AnalyticsType = type
    }
    
    // MARK: - Internal
    
    func setup() throws {
        let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        guard let options = FIROptions(contentsOfFile: path) else {
            throw AnalyticsError.setup
        }
        FIRApp.configure(with: options)
        isSetup = true
    }
    
    func startSession() {
        guard isSetup == true else {
            return
        }
        
        sessionStartDate = Date()
        logEvent(withName: kFIREventAppOpen, parameters: nil)
    }
    
    func endSession() {
        guard sessionStartDate != nil else {
            return
        }
        
        sendTimedAppEvent("app_closed", fromDate: sessionStartDate!, toDate: Date())
        sessionStartDate = nil
    }
    
    func sendScreenNameEvent(_ classId: Any) {
        logEvent(withName: "\(classId)", parameters: nil)
    }
    
    func sendEvent(_ event: String, classId: Any) {
        logEvent(withName: "\(classId)", parameters: [
            "event" : event as NSString
            ])
    }
    
    func sendButtonPressEvent(_ event: String, classId: Any) {
        logEvent(withName: "\(classId)", parameters: [
            "button_press" : event as NSString
            ])
    }
    
    func sendShareEvent(_ event: String, classId: Any) {
        logEvent(withName: "\(classId)", parameters: [
            "share" : event as NSString
            ])
    }
    
    func sendAlertEvent(_ event: String, classId: Any) {
        logEvent(withName: "\(classId)", parameters: [
            "alert" : event as NSString
            ])
    }
    
    func sendErrorEvent(_ error: Error, classId: Any) {
        let nsError = error as NSError
        logEvent(withName: "\(classId)", parameters: [
            "error-domain" : nsError.domain as NSString,
            "error-code" : NSNumber(integerLiteral: nsError.code),
            "error-description": nsError.localizedDescription as NSString
            ])
    }
    
    func sendTimedAppEvent(_ event: String, fromDate: Date, toDate: Date) {
        let sessionTimeSecs = toDate.timeIntervalSince(fromDate)
        let sessionTimeMilliSecs = NSNumber(value: UInt(sessionTimeSecs * 1000.0) as UInt)
        logEvent(withName: event, parameters: [
            "time" : sessionTimeMilliSecs
            ])
    }
    
    // MARK: - Private
    
    fileprivate func logEvent(withName name: String, parameters: [String: NSObject]?) {
        guard isSetup == true else {
            return
        }
        
        AnalyticsType.logEvent(withName: name, parameters: parameters)
    }
}
