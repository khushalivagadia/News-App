//
//  BookmarkTabView.swift
//  News App
//
//  Created by Khushali Vagadia on 15/09/23.
//

import SwiftUI

struct BookmarkTabView: View {
    
    // Environment object for managing article bookmarks
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    
    // State for search text
    @State var searchText: String = ""
    
    var body: some View {
        let articles = self.articles
        
        // Navigation view to display bookmarked articles
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView(isEmpty: articles.isEmpty))
                .navigationTitle("Saved Articles")
        }
        
        // Enable searching and bind to searchText
        .searchable(text: $searchText)
    }
    
    // Filter and return bookmarked articles based on searchText
    private var articles: [Article] {
        if searchText.isEmpty {
            return articleBookmarkVM.bookmarks
        }
        return articleBookmarkVM.bookmarks
            .filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.descriptionText.lowercased().contains(searchText.lowercased())
            }
    }
    
    // View overlay to display when there are no saved articles
    @ViewBuilder
    func overlayView(isEmpty: Bool) -> some View {
        if isEmpty {
            EmptyPlaceholderView(text: "No saved articles", image: Image(systemName: "bookmark"))
        }
    }
}

struct BookmarkTabView_Previews: PreviewProvider {
    
    // StateObject for managing article bookmarks in previews
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        BookmarkTabView()
            .environmentObject(articleBookmarkVM)
    }
}
