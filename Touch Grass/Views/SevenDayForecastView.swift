//
//  WeekView.swift
//  Touch Grass
//

import Foundation
import SwiftUI

// 7-Day Forecast View
struct SevenDayForecastView: View {
    @Environment(WeatherStore.self) private var store

    // The forecastPeriods contain entries for day and night.
    // We only want the daytime forecasts so we have to skip every other
    // index of the forecast periods.
    private var dayPeriods: [ForecastPeriod] {
        store.periods
            .enumerated()
            .filter { $0.offset % 2 == 0 }
            .map { $0.element }
            .prefix(7)
            .map { $0 }
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("7-Day Forecast")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, 20)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(dayPeriods, id: \.number) { period in
                        DayForecastRow(period: period)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DayForecastRow: View {
    let period: ForecastPeriod

    var body: some View {
        HStack {
            Text(period.name)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .frame(width: 120, alignment: .leading)

            Spacer()

            AsyncImage(url: URL(string: period.icon)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)

            Text("\(period.temperature)°\(period.temperatureUnit)")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .frame(width: 60, alignment: .trailing)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
