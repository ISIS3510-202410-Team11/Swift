//
//  SpeedView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI
import Charts

struct SpeedView: View {
    @StateObject var vm_speed = SpeedViewModel()
    var body: some View {
        VStack{
            Label("Acelerometro del iPhone", systemImage: "sensor.fill")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Label("Funcionalidad extra implementada como sensor", systemImage: "sensor.fill")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Label("Se debe probar sobre algún dispositivo físico", systemImage: "sensor.fill")
                .font(.system(size: 20, weight: .bold, design: .rounded))
        }

        Chart(vm_speed.data){data in
            ForEach(Array(data.value.enumerated()), id: \.offset){
                index, element in
                LineMark(x: .value("Index", index),
                         y: .value("Index", element))
                }
            .foregroundStyle(by: .value("Axis", data.axis))
        }
        .frame(height: 400)
        Button("Reset"){
            ClickCounter.shared.incrementCount()
            vm_speed.removeData()
        }
    }
}


#Preview {
    SpeedView()
}
