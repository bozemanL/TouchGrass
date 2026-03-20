//
//  CalendarView.swift
//  Touch Grass
//

import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()
    @State private var displayedMonth = Date()
    
    // Get calendar data
    private var calendar: Calendar {
        Calendar.current
    }
    
    // Get current month name
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayedMonth)
    }
    
    // Check if we're viewing the current month
    private var isCurrentMonth: Bool {
        calendar.isDate(displayedMonth, equalTo: Date(), toGranularity: .month)
    }
    
    // Get all days in current month
    private var daysInMonth: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        var days: [Date?] = []
        var currentDay = monthFirstWeek.start
        
        // Generate 6 weeks worth of days (42 days total)
        for _ in 0..<42 {
            // Check if this day is in the displayed month
            if calendar.isDate(currentDay, equalTo: displayedMonth, toGranularity: .month) {
                days.append(currentDay)
            } else {
                days.append(nil)
            }
            currentDay = calendar.date(byAdding: .day, value: 1, to: currentDay)!
        }
        
        return days
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Calendar")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            // Month navigation
            HStack {
                // Previous month button (only show if not on current month)
                Button(action: {
                    withAnimation {
                        displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                }
                .opacity(isCurrentMonth ? 0 : 1)
                .disabled(isCurrentMonth)
                
                Spacer()
                
                // Month and year display
                Text(monthYearString)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Next month button
                Button(action: {
                    withAnimation {
                        displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                }
                
                // Back to current month button (only show if not on current month)
                if !isCurrentMonth {
                    Button(action: {
                        withAnimation {
                            displayedMonth = Date()
                        }
                    }) {
                        Text("Today")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                    .padding(.leading, 8)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            // Calendar grid
            VStack(spacing: 10) {
                // Day of week headers
                HStack(spacing: 0) {
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                // Calendar days in grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                    ForEach(0..<daysInMonth.count, id: \.self) { index in
                        if let date = daysInMonth[index] {
                            CalendarDayCell(date: date, currentDate: currentDate)
                        } else {
                            // Empty cell for days outside current month
                            Color.clear
                                .frame(height: 80)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Individual calendar day cell
struct CalendarDayCell: View {
    let date: Date
    let currentDate: Date
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    // Check if this is today
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    // Check if this date is within the 14-day forecast range (today + 13 days)
    private var isInForecastRange: Bool {
        let today = calendar.startOfDay(for: Date())
        let cellDay = calendar.startOfDay(for: date)
        
        // Calculate days from today
        if let daysDifference = calendar.dateComponents([.day], from: today, to: cellDay).day {
            return daysDifference >= 0 && daysDifference <= 13
        }
        return false
    }
    
    // Get day number
    private var dayNumber: String {
        let day = calendar.component(.day, from: date)
        return "\(day)"
    }
    
    var body: some View {
        VStack(spacing: 4) {
            // Day number
            Text(dayNumber)
                .font(.body)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isToday ? .white : .primary)
            
            if isInForecastRange {
                // Weather icon placeholder (only for 14-day forecast range)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "cloud.sun.fill")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    )
                
                // Temperature placeholder
                Text("--°")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            } else {
                // Empty space for days outside forecast range
                Spacer()
                    .frame(height: 38)
            }
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isToday ? Color.blue : Color(uiColor: .secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isToday ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    NavigationStack {
        CalendarView()
    }
}
