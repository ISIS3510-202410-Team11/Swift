import Foundation
import SwiftUI

enum Tab: Hashable {
    case home
    case services
    case activity
    case account
}

struct Tabvar: View {
    @State private var selectedTab: Tab

    init(startingTab: Tab = .home) {
        _selectedTab = State(initialValue: startingTab)
        UITabBar.appearance().barTintColor = UIColor.white // Set the tab bar's background color to white

    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                MapView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(Tab.home) // Tag this view with the corresponding enum value

            NavigationView {
                Text("Services")
            }
            .tabItem {
                Image(systemName: "circle.grid.3x3.fill")
                Text("Services")
            }
            .tag(Tab.services)

            NavigationView {
                Text("Activity")
            }
            .tabItem {
                Image(systemName: "bolt.fill")
                Text("Activity")
            }
            .tag(Tab.activity)

            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Account")
            }
            .tag(Tab.account)
        }
        .accentColor(.green)
        
    }
}

// Preview with a specific starting tab
struct Tabvar_Previews: PreviewProvider {
    static var previews: some View {
        Tabvar(startingTab: .account)
    }
}
