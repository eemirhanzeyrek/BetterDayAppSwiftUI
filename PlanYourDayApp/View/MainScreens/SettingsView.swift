import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.largeTitle)
                .bold()
            
            List {
                let reviewUrl = URL(string: "https://www.apple.com/tr/")!
                
                Link(destination: reviewUrl, label: {
                    HStack {
                        Image(systemName: "star.bubble")
                        
                        Text("Rate the app")
                    }
                })
                
                let shareUrl = URL(string: "https://www.apple.com/tr/")!
                
                ShareLink(item: shareUrl) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.right")
                        
                        Text("Recommend the app")
                    }
                }
                
                Button {
                    let mailUrl = createMailUrl()
                    
                    if let mailUrl = mailUrl, UIApplication.shared.canOpenURL(mailUrl) {
                        UIApplication.shared.open(mailUrl)
                    } else {
                        print("Couldn't open mail client")
                    }
                } label: {
                    HStack {
                        Image(systemName: "quote.bubble")
                        
                        Text("Submit feedback")
                    }
                }
                
                let privacyUrl = URL(string: "https://www.apple.com/tr/")!
                
                Link(destination: privacyUrl, label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        
                        Text("Privacy Policy")
                    }
                })
            }
            .listRowSeparator(.hidden)
            .listStyle(.plain)
            .tint(.black)
        }
    }
    
    func createMailUrl() -> URL? {
        var mailUrlComponents = URLComponents()
        
        mailUrlComponents.scheme = "mailto"
        mailUrlComponents.path = "mail@mail.com"
        mailUrlComponents.queryItems = [
            URLQueryItem(name: "subject", value: "Feedback for app")
        ]
        
        return mailUrlComponents.url
    }
}

#Preview {
    SettingsView()
}
