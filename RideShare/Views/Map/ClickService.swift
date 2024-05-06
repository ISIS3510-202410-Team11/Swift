//
//  ClickService.swift
//  RideShare
//
//  Created by Cristian Caro on 24/04/24.
//

import Foundation

class ClickCounter {
    static let shared = ClickCounter() // Singleton
    
    private var paymentOptions: [String: Int] =
    [
        "Nequi":0,
        "PayPal":0,
        "DaviPlata":0,
        "PSE":0,
        "Bold":0,
        "Credit/Card":0,
        "Other":0
    ]
    private var timeToLoad: Double = 0
    private(set) var totalCount: Int = 0
    private(set) var ridesPayed: Int = 0
    private(set) var ridesPayedEalyHours: Int = 0
    private(set) var ridesPayedLateHours: Int = 0
    private init() {} // Constructor is private so there is just 1 instance
    
    // TYPE QUESTION 1
    func getAppDeploymentTime(time: Double){
        timeToLoad = time
        print("DEBUG: TIME TO LOAD APP IS: \(timeToLoad)")
    }
    // TYPE 2 QUESTION IS HERE
    func incrementCount() {
        totalCount += 1
        print("DEBUG: NUMBER OF CLICKS IN ALL THE APP IS: \(totalCount)")
    }
    // TYPE 4 QUESTION IS HERE
    func incrementRidesPayed(){
        ridesPayed += 1
        print("DEBUG: NUMBER OF RIDES PAYED IS: \(ridesPayed)")
    }
    // TYPE 1 QUESTION HERE
    func incrementRidesEalyHours(rides: [ActiveTrips]){ //7:00am to 9:00am
        for trip in rides{
            switch trip.start_time{
            case "7:00":
                ridesPayedEalyHours += 1
                break
            case "7:30":
                ridesPayedEalyHours += 1
                break
            case "8:00":
                ridesPayedEalyHours += 1
                break
            case "8:30":
                ridesPayedEalyHours += 1
                break
            case "9:00":
                ridesPayedEalyHours += 1
                break
            default:
                break
            }
        }
        print("DEBUG: NUMBER OF RIDES PAYED ON EALY HOURS: \(ridesPayedEalyHours)")
    }
    // TYPE 1 QUESTION IS HERE
    func incrementRidesLateHours(rides: [ActiveTrips]){ //3:00pm to 5:00pm
        for trip in rides{
            switch trip.start_time{
            case "15:00":
                ridesPayedLateHours += 1
                break
            case "15:30":
                ridesPayedLateHours += 1
                break
            case "16:00":
                ridesPayedLateHours += 1
                break
            case "16:30":
                ridesPayedLateHours += 1
                break
            case "17:00":
                ridesPayedLateHours += 1
                break
            default:
                break
            }
        }
        print("DEBUG: NUMBER OF RIDES PAYED ON LATE HOURS: \(ridesPayedLateHours)")
    }
    // TYPE 3 QUESTIONS ARE HERE
    func frecuencyPaymentMethod(paymentMethod: String){
        switch paymentMethod{
        case "Nequi":
            paymentOptions["Nequi"]! += 1
            break
        case "PayPal":
            paymentOptions["PayPal"]! += 1
            break
        case "DaviPlata":
            paymentOptions["DaviPlata"]! += 1
            break
        case "PSE":
            paymentOptions["PSE"]! += 1
            break
        case "Bold":
            paymentOptions["Bold"]! += 1
            break
        case "Credit/Card":
            paymentOptions["Credit/Card"]! += 1
            break
        default: //ONE QUESTION BY ITs OWN
            paymentOptions["Other"]! += 1
            break
        }
    }
}
