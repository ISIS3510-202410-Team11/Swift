//
//  SpeedViewModel.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import Foundation
import CoreMotion

struct DataModel: Identifiable{
    let id: String = UUID().uuidString
    let axis: String
    var value : [Double] //almacenar valores

    mutating func add(_ newValue: Double){
        self.value.append(newValue)
    }
}

final class SpeedViewModel: ObservableObject{
    private let motionManager = CMMotionManager()

    private var x: DataModel = .init(axis: "x", value: [])
    private var y: DataModel = .init(axis: "y", value: [])
    private var z: DataModel = .init(axis: "z", value: [])

    @Published var data: [DataModel] = [] //x,y,z van a data

    init() {
        startAccelerometer()
    }
    func startAccelerometer(){
        guard motionManager.isAccelerometerAvailable else{
            print("Acelerometer data not available on this device")
            return //nil?
        }
        motionManager.accelerometerUpdateInterval = 1/60 //intervalo de consulta
        motionManager.startAccelerometerUpdates(to: .main){ //actualizar
            accelerometerData, error in
            guard let error = error
            else{
                self.updateProperties(with: accelerometerData)
                return
            }
            print("Error \(error.localizedDescription)")
        }

    }
    private func updateProperties(with acelerometerData: CMAccelerometerData?){
        if let data = acelerometerData{
            let (x, y, z) = (data.acceleration.x, data.acceleration.y, data.acceleration.z) //extraer datos con tupla

            self.x.add(x) //añadir en array de cada eje
            self.y.add(y)
            self.z.add(z)

            self.data=[self.x, self.y, self.z] //añadir en data

            //print("Eje X \(self.x)")
            //print("Eje Y \(self.y)")
            //print("Eje Z \(self.z)")
        }
    }
    func removeData(){
        data.removeAll()
        x = .init(axis: "x", value: [])
        y = .init(axis: "y", value: [])
        z = .init(axis: "z", value: [])
    }
}
