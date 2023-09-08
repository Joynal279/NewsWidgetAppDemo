//
//  NewsArticleList.swift
//  NewsWidgetAppDemo
//
//  Created by Joynal Abedin on 8/9/23.
//

import Foundation

struct NewsArticleList: Codable {
    var status: String
    var totalResults: Int
    var articles: [NewsArticle]
}
