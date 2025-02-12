import SwiftUI
import SwiftData

struct AddThingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var thingTitle = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("What would you like to add?", text: $thingTitle)
                .textFieldStyle(.roundedBorder)
            
            Text("For example, 'Go shopping'")
                .foregroundColor(.gray)
                .font(.caption)
                
            Button("Add") {
                addThing()
                
                thingTitle = ""
                
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .disabled(thingTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
    }
    
    func addThing() {
        let cleanedTitle = thingTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        context.insert(Thing(title: cleanedTitle))
        
        try? context.save()
    }
}

#Preview {
    AddThingView()
}
