import Foundation
import SwiftUI
struct Tabvar: View {
    var body: some View {
        TabView {
            NavigationView {
                MapView2()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            NavigationView {
                LoginView()
            }
            .tabItem {
                Image(systemName: "circle.grid.3x3.fill")
                Text("Services")
            }

            NavigationView {
                RegistrationView()
            }
            .tabItem {
                Image(systemName: "bolt.fill")
                Text("Activity")
            }

            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Account")
            }
        }
    }
}


#Preview {
    Tabvar()
}







