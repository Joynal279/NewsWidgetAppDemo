//
//  NewsWidget.swift
//  NewsWidget
//
//  Created by Joynal Abedin on 8/9/23.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    
    private let newsViewModel: NewsViewModel = NewsViewModel()
    
    func placeholder(in context: Context) -> NewsListEntry {
        NewsListEntry(date: Date(), state: .idle)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> NewsListEntry {
        NewsListEntry(date: Date(), state: .idle)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<NewsListEntry> {
        var entries: [NewsListEntry] = []
        newsViewModel.getDataIfNeeded{ result in
            switch result {
            case .success(let newsItems):
                let items = Array(newsItems.prefix(4))
                entries.append(NewsListEntry(date: Date(), state: .success(items)))
            case .failure:
                entries.append(NewsListEntry(date: Date(), state: .error))
                break
            }
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
    var entry: NewsListEntry

    var body: some View {
        GeometryReader { geometry in
            switch entry.state {
            case .idle:
                Text("No data yet, waiting")
                    .font(.system(size: 12))
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            case .error:
                Text("Oops something went wrong - please reconfigure")
                    .font(.system(size: 12))
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            case .success(let array):
                VStack {
                    Text("My News Widget")
                    Spacer()
                    ForEach(array) { array in
                        Text(array.title)
                            .frame(maxWidth: geometry.size.width, alignment: .leading)
                            .font(.system(size: 12))
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                }
            }
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
