//
//  Touch_GrassApp.swift
//  Touch Grass
//

import SwiftUI
import UserNotifications

@main
struct Touch_GrassApp: App {
    init() {
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            
            // Ask the user to allow notifications
            // We assign it to _ to tell the compiler that we are not using the result of this try.
            // We don't use the result because the NotificationService checks this value itself.
                .task {
                    _ = try? await UNUserNotificationCenter.current()
                        .requestAuthorization(options: [.alert, .sound, .badge])
                }
        }
    }
    
    // This class gives us the ability to intercept and customize notification behavior.
    // iOS, by default does not show notifications for the app you are currently using.
    // For testing/demos we want to see the notifications while the app is open, so this function
    // overrides the default settings to achieve this.
    class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
        static let shared = NotificationDelegate()
        
        // This is the function that the iOS calls right before its about to display a notification.
        // it only fires when you app is in the foreground.
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                     willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
            return [.banner, .sound]
        }
    }
}
