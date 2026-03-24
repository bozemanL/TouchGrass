//
//  SettingsView.swift
//  Touch Grass
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("notifyOnSunny") private var notifyOnSunny = true
    @AppStorage("notifyOnCloudy") private var notifyOnCloudy = false
    @AppStorage("notifyOnRainy") private var notifyOnRainy = false
    @AppStorage("notifyOnSnowy") private var notifyOnSnowy = false
    @AppStorage("notificationIntervalMinutes") private var notificationIntervalMinutes = 60
    
    // Available frequency options: label + value in minutes
    private let frequencyOptions: [(label: String, minutes: Int)] = [
        ("Every minute", 1),
        ("Every 15 minutes", 15),
        ("Every 30 minutes", 30),
        ("Every hour", 60),
        ("Every 3 hours", 180),
        ("Every 6 hours", 360),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            // Settings list
            ScrollView {
                VStack(spacing: 12) {
                    
                    // MARK: - Appearance Section
                    SectionHeader(title: "Appearance")
                    
                    SettingsRow(icon: "moon.fill", title: "Dark Mode", iconColor: .indigo) {
                        Toggle("", isOn: $isDarkMode)
                            .labelsHidden()
                    }
                    
                    // MARK: - Notifications Section
                    SectionHeader(title: "Notifications")
                    
                    // Master toggle — wires to AppStorage and reschedules/cancels accordingly
                    SettingsRow(icon: "bell.fill", title: "Weather Alerts", iconColor: .orange) {
                        Toggle("", isOn: $notificationsEnabled)
                            .labelsHidden()
                            .onChange(of: notificationsEnabled) { _, enabled in
                                if !enabled {
                                    UNUserNotificationCenter.current()
                                        .removePendingNotificationRequests(withIdentifiers: ["weather-notification"])
                                }
                                // Re-scheduling when turned back on is handled by WeatherStore.load()
                                // which fires whenever location updates. Trigger a manual refresh:
                                NotificationCenter.default.post(name: .notificationSettingsChanged, object: nil)
                            }
                    }
                    
                    // Only show sub-options when notifications are enabled
                    if notificationsEnabled {
                        
                        // MARK: Weather Type Preferences
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notify me when it's…")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 4)
                            
                            WeatherTypeToggleRow(
                                icon: "sun.max.fill",
                                label: "Sunny / Clear",
                                iconColor: .yellow,
                                isOn: $notifyOnSunny
                            )
                            WeatherTypeToggleRow(
                                icon: "cloud.fill",
                                label: "Cloudy",
                                iconColor: .gray,
                                isOn: $notifyOnCloudy
                            )
                            WeatherTypeToggleRow(
                                icon: "cloud.rain.fill",
                                label: "Rainy",
                                iconColor: .blue,
                                isOn: $notifyOnRainy
                            )
                            WeatherTypeToggleRow(
                                icon: "snowflake",
                                label: "Snowy",
                                iconColor: .cyan,
                                isOn: $notifyOnSnowy
                            )
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(12)
                        .onChange(of: notifyOnSunny)  { _, _ in postSettingsChanged() }
                        .onChange(of: notifyOnCloudy) { _, _ in postSettingsChanged() }
                        .onChange(of: notifyOnRainy)  { _, _ in postSettingsChanged() }
                        .onChange(of: notifyOnSnowy)  { _, _ in postSettingsChanged() }
                        
                        // MARK: Frequency Picker
                        SettingsRow(icon: "clock.fill", title: "Frequency", iconColor: .green) {
                            Picker("Frequency", selection: $notificationIntervalMinutes) {
                                ForEach(frequencyOptions, id: \.minutes) { option in
                                    Text(option.label).tag(option.minutes)
                                }
                            }
                            .pickerStyle(.menu)
                            .onChange(of: notificationIntervalMinutes) { _, _ in postSettingsChanged() }
                        }
                    }

                    
                    // MARK: - About Section
                    SectionHeader(title: "About")
                    
                    SettingsRow(icon: "info.circle.fill", title: "Version", iconColor: .blue) {
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    
                    NavigationLink(destination: Text("About Touch Grass")
                        .font(.largeTitle)
                        .navigationBarTitleDisplayMode(.inline)) {
                        SettingsRowContent(
                            icon: "heart.fill",
                            title: "About Touch Grass",
                            iconColor: .red
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func postSettingsChanged() {
        NotificationCenter.default.post(name: .notificationSettingsChanged, object: nil)
    }
}

// MARK: - Notification name extension
extension Notification.Name {
    static let notificationSettingsChanged = Notification.Name("notificationSettingsChanged")
}

// MARK: - Subviews

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 4)
            .padding(.top, 6)
    }
}

struct WeatherTypeToggleRow: View {
    let icon: String
    let label: String
    let iconColor: Color
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.system(size: 18))
                .frame(width: 24)
            
            Text(label)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}

// Settings row component with custom trailing content
struct SettingsRow<Content: View>: View {
    let icon: String
    let title: String
    let iconColor: Color
    @ViewBuilder let trailingContent: Content
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor)
                    .frame(width: 35, height: 35)
                
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            trailingContent
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// Settings row content for NavigationLinks
struct SettingsRowContent: View {
    let icon: String
    let title: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor)
                    .frame(width: 35, height: 35)
                
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
