//
//  ContentView.swift
//  News App
//
//  Created by Khushali Vagadia on 14/09/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            // NewsTabView for displaying news articles.
            NewsTabView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            // SearchTabView for searching and displaying search results.
            SearchTabView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            // BookmarkTabView for displaying saved articles.
            BookmarkTabView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
