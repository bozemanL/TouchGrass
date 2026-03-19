//
//  Touch_GrassApp.swift
//  Touch Grass
//

import SwiftUI
import UserNotifications

@main
struct Touch_GrassApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
            
            // Ask the user to allow notifications
            // We assign it to _ to tell the compiler that we are not using the result of this try.
            // We don't use the result because the NotificationService checks this value itself.
                .task {
                    _ = try? await UNUserNotificationCenter.current()
                        .requestAuthorization(options: [.alert, .sound, .badge])
                }
        }
    }
}
