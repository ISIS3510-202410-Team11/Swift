//
//  AnalyticsManager.swift
//  RideShare
//
//  Created by Cristian Caro on 21/05/24.
//

import Foundation
import FirebaseAnalytics
import FirebaseAnalyticsSwift

final class AnalyticsManager{
    static let shared = AnalyticsManager()
    private init() { }
    
    func logEvent(name: String, params:[String:Any]? = nil){
        Analytics.logEvent(name, parameters: params)
    }
    
    func setUserID(userId: String){
        Analytics.setUserID(userId)
    }
    
    func setUserPropertys(value: String?, property: String){
        Analytics.setUserProperty(value, forName: property)
    }
}

/*
 AnalyticsManager.shared.logEvent(name: "BQ#", params: ["view":"button"])
 
 */
