import SwiftUI
import SwiftData
import UserNotifications

struct RemindersView: View {
    @AppStorage("ReminderTime") private var reminderTime: Double = Date().timeIntervalSince1970
    @AppStorage("RemindersOn") private var isRemindersOn = false
    
    @State private var selectedDate = Date().addingTimeInterval(86400)
    @State private var isSettingsDialogShowing = false
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Reminders")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("You can grant access to notifications for regular reminders every day.")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Toggle(isOn: $isRemindersOn) {
                Text("Reminder notifications:")
            }
            
            if isRemindersOn {
                HStack {
                    Text("What time every day?")
                    
                    Spacer()
                    
                    DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(Image(systemName: "bell.and.waves.left.and.right"))
                    
                    Text("You will receive your reminders as notifications every day at \(formattedTime).")
                }
                .foregroundStyle(Color.blue)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.blue, lineWidth: 1)
                        .background(Color("light-blue"))
                }
                
            } else {
                ToolTipView(text: "You can turn on the reminders above to remind yourself to make each day better.")
            }
            
            Spacer()
        }
        .padding(.trailing, 2)
        .onAppear(perform: {
            selectedDate = Date(timeIntervalSince1970: reminderTime)
        })
        .onChange(of: isRemindersOn) { oldValue, newValue in
            let notificationCenter = UNUserNotificationCenter.current()
            
            notificationCenter.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    print("Notifications are authorized.")
                    
                    scheduleNotifications()
                case .denied:
                    print("Notifications are denied.")
                    
                    isRemindersOn = false
                    
                    isSettingsDialogShowing = true
                case .notDetermined:
                    print("Notification permission has not been asked yet.")
                    
                    requestNotificationPermission()
                default:
                    break
                }
            }
        }
        .onChange(of: selectedDate) { oldValue, newValue in
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removeAllPendingNotificationRequests()
            
            scheduleNotifications()
            
            reminderTime = selectedDate.timeIntervalSince1970
        }
        .alert(isPresented: $isSettingsDialogShowing) {
            Alert(title: Text("Notification Disabled"),
                  message: Text("Reminders won't be sent unless Notifications are allowed. Please allow them in settings."),
                  primaryButton: .default(Text("Go to Settings"), action: {
                gotoSettings()
            }),
                  secondaryButton: .cancel()
            )
        }
    }
    
    func gotoSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
    func requestNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted.")
                
                scheduleNotifications()
            } else {
                print("Permission denied.")
                
                isRemindersOn = false
                
                isSettingsDialogShowing = true
            }
            
            if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Better Day"
        content.body = "Don't forget to do something for yourself today!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.autoupdatingCurrent.component(.hour, from: selectedDate)
        dateComponents.minute = Calendar.autoupdatingCurrent.component(.minute, from: selectedDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Daily notification scheduled.")
            }
        }
    }
}

#Preview {
    RemindersView()
}
