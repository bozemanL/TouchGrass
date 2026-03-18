//
//  ContentView.swift
//  Touch Grass
//
//  Created by Lily Bozeman on 2/17/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Header section
            VStack {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.orange)
                
                Text("Touch Grass")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(.top, 40)
            
            Spacer()
            
            // Weather info placeholder
            VStack(spacing: 10) {
                Text("Today's Forecast")
                    .font(.headline)
                
                Text("72°F")
                    .font(.system(size: 48, weight: .light))
                
                Text("Partly Cloudy")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
            
            Spacer()
            
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
