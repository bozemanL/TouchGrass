//
//  SettingsView.swift
//  Touch Grass
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @State private var notificationsEnabled = true
    
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
                    // Appearance Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Appearance")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        SettingsRow(
                            icon: "moon.fill",
                            title: "Dark Mode",
                            iconColor: .indigo
                        ) {
                            Toggle("", isOn: $isDarkMode)
                                .labelsHidden()
                        }
                    }
                    
                    // Notifications Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Notifications")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        SettingsRow(
                            icon: "bell.fill",
                            title: "Weather Alerts",
                            iconColor: .orange
                        ) {
                            Toggle("", isOn: $notificationsEnabled)
                                .labelsHidden()
                        }
                    }
                    
                    // About Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        SettingsRow(
                            icon: "info.circle.fill",
                            title: "Version",
                            iconColor: .blue
                        ) {
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
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor)
                    .frame(width: 35, height: 35)
                
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            
            // Title
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Custom trailing content
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
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor)
                    .frame(width: 35, height: 35)
                
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            
            // Title
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Chevron
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
