//
//  ContentView.swift
//  NewsWidgetAppDemo
//
//  Created by Joynal Abedin on 8/9/23.
//

import SwiftUI
import Combine


struct ContentView: View {

    @ObservedObject var newsViewModel = NewsViewModel()

    var body: some View {
        GeometryReader { geometry in

            switch newsViewModel.state {
            case .loading:
                Text("Loading...")
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            case .success(let result):
                List(result) { item in
                    Text(item.title)
                }
            case .error:
                Text("Error occured!")
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }

            }.onAppear {
                newsViewModel.getDataIfNeeded()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
