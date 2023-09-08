//
//  NewsViewModel.swift
//  NewsWidgetAppDemo
//
//  Created by Joynal Abedin on 8/9/23.
//

import Foundation
import Combine

final class NewsViewModel: ObservableObject {

    // MARK: - Constants
    private enum Constants {
      static let endpointString = "https://newsapi.org/v2/top-headlines?country=us&sortBy=publishedAt"
      static let apiKey = "09510d0f4f3641258f6f703aa2ef9612"
    }

    enum Category: String {
       case general
       case business
       case entertainment
       case health
       case science
       case sports
       case technology
   }

    // MARK: - state
    enum ResultState {
        case loading
        case error(Error)
        case success([NewsArticle])
    }

    // MARK: - properties
    private var cancelables: Set<AnyCancellable> = Set<AnyCancellable>()
    private let apiService: APIService

    @Published var state: ResultState = .loading

    init(apiService: APIService = APIService() ) {
        self.apiService = apiService
    }

    func getDataIfNeeded(category: Category = .general) {
         guard let url = getUrlForCategory(category: category) else {
             //completion?(.failure(APIService.APIError.unknownError))
             return
         }

         state = .loading
         apiService.getObject(object: NewsArticleList.self, url: url)
             .subscribe(on: DispatchQueue.global(qos: .background))
             .receive(on: DispatchQueue.main)
             .sink { [weak self] result in
                 switch result {
                 case .failure(let error):
                     self?.state = .error(error)
                     //completion?(.failure(error))
                 default: break
                 }

             } receiveValue: { [weak self] list in
                 self?.state = .success(list.articles)
             }.store(in: &cancelables)
     }

     private func getUrlForCategory(category: Category = .general) -> URL? {
          var urlComponents = URLComponents(string: Constants.endpointString)
          var queryItems = urlComponents?.queryItems
          queryItems?.append(URLQueryItem(name: "category", value: category.rawValue))
          queryItems?.append(URLQueryItem(name: "apiKey", value: Constants.apiKey))
          urlComponents?.queryItems = queryItems

          return urlComponents?.url
     }

}
