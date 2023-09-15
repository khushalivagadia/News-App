//
//  SearchTabView.swift
//  News App
//
//  Created by Khushali Vagadia on 15/09/23.
//

import SwiftUI

struct SearchTabView: View {
    
    // StateObject for managing article search
    @StateObject var searchVM = ArticleSearchViewModel.shared
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .navigationTitle("Search")
        }
        
        // Enable searching and bind to searchVM's searchQuery
        .searchable(text: $searchVM.searchQuery) { suggestionsView }
        .onChange(of: searchVM.searchQuery) { newValue in
            if newValue.isEmpty {
                searchVM.phase = .empty
            }
        }
        // Handle search when the search button is pressed
        .onSubmit(of: .search, search)
    }
    
    // Computed property to get articles from searchVM's phase
    private var articles: [Article] {
        if case .success(let articles) = searchVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    // Overlay view to display based on searchVM's phase
    @ViewBuilder
    private var overlayView: some View {
        switch searchVM.phase {
        case .empty:
            if !searchVM.searchQuery.isEmpty {
                ProgressView()
            } else if !searchVM.history.isEmpty {
                SearchHistoryListView(searchVM: searchVM) { newValue in
                    // Need to be handled manually as it doesn't trigger default onSubmit modifier
                    searchVM.searchQuery = newValue
                    search()
                }
            } else {
                EmptyPlaceholderView(text: "Type your query to search from NewsAPI", image: Image(systemName: "magnifyingglass"))
            }
            
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No search results found", image: Image(systemName: "magnifyingglass"))
            
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: search)
            
        default: EmptyView()
            
        }
    }
    
    // Suggestions view for search queries
    @ViewBuilder
    private var suggestionsView: some View {
        ForEach(["Swift", "Covid-19", "BTC", "PS5", "iOS 15"], id: \.self) { text in
            Button {
                searchVM.searchQuery = text
            } label: {
                Text(text)
            }
        }
    }
    
    // Function to initiate the search task
    private func search() {
        let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchQuery.isEmpty {
            searchVM.addHistory(searchQuery)
        }
        
        Task {
            await searchVM.searchArticle()
        }
    }
}

struct SearchTabView_Previews: PreviewProvider {
    
    // StateObject for managing article bookmarks in previews
    @StateObject static var bookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        
        // Preview of SearchTabView with environment object
        SearchTabView()
            .environmentObject(bookmarkVM)
    }
}
