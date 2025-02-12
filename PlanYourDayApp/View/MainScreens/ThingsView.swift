import SwiftUI
import SwiftData

struct ThingsView: View {
    @Environment(\.modelContext) private var context
    
    @Query(filter: Day.currentDayPredicate(), sort: \.date) private var today: [Day]
    
    @Query(filter: #Predicate<Thing> { $0.isHidden == false }) private var things: [Thing]
    
    @State private var showAddView: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Things")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("It's time to add the things you want to achieve.")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if things.count == 0 {
               
            } else {
                List {
                    ForEach(things) { thing in
                        let today = getToday()
                        
                        HStack {
                            Text(thing.title)
                            
                            Spacer()
                            
                            Button {
                                if today.things.contains(thing) {
                                    today.things.removeAll { t in
                                        t == thing
                                    }
                                    
                                    try? context.save()
                                } else {
                                    today.things.append(thing)
                                }
                            } label: {
                                if today.things.contains(thing) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.gray)
                                } else {
                                    Image(systemName: "plus.circle")
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteThings)
                }
                .listStyle(.plain)
                
                Spacer()
            }
            
            Spacer()
            
            Button("Add Thing") {
                showAddView.toggle()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
        .sheet(isPresented: $showAddView) {
            AddThingView()
                .presentationDetents([.fraction(0.2)])
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
    
    func deleteThings(_ indexSet: IndexSet) {
        for index in indexSet {
            let thingToDelete = things[index]
            context.delete(thingToDelete)
        }
    }
}

#Preview {
    ThingsView()
}
