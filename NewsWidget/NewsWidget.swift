//
//  NewsWidget.swift
//  NewsWidget
//
//  Created by Joynal Abedin on 8/9/23.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> NewsListEntry {
        NewsListEntry(date: Date(), state: .idle)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> NewsListEntry {
        NewsListEntry(date: Date(), state: .idle)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<NewsListEntry> {
        var entries: [NewsListEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = NewsListEntry(date: entryDate, state: .idle)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct NewsListEntry: TimelineEntry {
    enum State{
        case idle
        case error
        case success([NewsArticle])
    }
    let date: Date
    let state: State
}

struct NewsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            //Text(entry.configuration.favoriteEmoji)
        }
    }
}

struct NewsWidget: Widget {
    let kind: String = "NewsWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            NewsWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    NewsWidget()
} timeline: {
    NewsListEntry(date: .now, state: .idle)
    NewsListEntry(date: .now, state: .idle)
}
