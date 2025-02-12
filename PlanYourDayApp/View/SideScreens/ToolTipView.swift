import SwiftUI

struct ToolTipView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundStyle(Color.blue)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.blue, lineWidth: 1)
                    .background(Color("lightColor"))
            }
    }
}

#Preview {
    ToolTipView(text: "Hello, World!")
}
