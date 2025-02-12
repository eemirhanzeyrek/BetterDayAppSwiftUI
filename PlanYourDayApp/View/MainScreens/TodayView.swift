import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var context
    
    @Binding var selectedTab: Tab
    
    @Query(filter: Day.currentDayPredicate(), sort: \.date) private var today: [Day]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Today")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Let's take a look at the goals you completed today.")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if getToday().things.count > 0 {
                List(getToday().things) { thing in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.blue)
                        
                        Text(thing.title)
                    }
                }
                .listStyle(.plain)
                
                Spacer()
            } else {
                Spacer()
                
            }
        }
    }
    
    func getToday() -> Day {
        if today.count > 0 {
            return today.first!
        } else {
            let today = Day()
            context.insert(today)
            
            try? context.save()
            
            return today
        }
    }
}

#Preview {
    TodayView(selectedTab: Binding.constant(Tab.today))
}
