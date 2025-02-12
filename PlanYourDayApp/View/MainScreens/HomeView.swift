import SwiftUI

struct HomeView: View {
    @State var selectedTab: Tab = Tab.today
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView(selectedTab: $selectedTab)
                .tabItem {
                    Text("Today")
                    Image(systemName: "calendar")
                }
                .tag(Tab.today)
            
            ThingsView()
                .tabItem {
                    Text("Things")
                    Image(systemName: "heart")
                }
                .tag(Tab.things)
            
            RemindersView()
                .tabItem {
                    Text("Reminders")
                    Image(systemName: "bell")
                }
                .tag(Tab.reminders)
            
            SettingsView()
                .tabItem {
                    Text("Settings")
                    Image(systemName: "gear")
                }
                .tag(Tab.settings)
        }
        .padding()
    }
}

enum Tab: Int {
    case today = 0
    case things = 1
    case reminders = 2
    case settings = 3
}

#Preview {
    HomeView()
}
