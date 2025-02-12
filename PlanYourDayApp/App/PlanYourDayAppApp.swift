import SwiftUI
import SwiftData

@main
struct PlanYourDayAppApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(for: [Day.self, Thing.self])
        }
    }
}
