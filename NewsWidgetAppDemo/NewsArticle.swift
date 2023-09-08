//
//  NewsArticle.swift
//  NewsWidgetAppDemo
//
//  Created by Joynal Abedin on 8/9/23.
//

import Foundation

struct NewsArticle: Codable {
    var author: String?
    var title: String
    var description: String?
    var url: String?
    var urlToImage: String?
    var content: String?
    var publishedAt: String?
}
extension NewsArticle: Identifiable {
    var id: String {
        return title
    }
}
