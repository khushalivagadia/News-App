//
//  ArticleListView.swift
//  News App
//
//  Created by Khushali Vagadia on 14/09/23.
//

import SwiftUI

struct ArticleListView: View {
    
    // MARK: - Properties
    
    let articles: [Article]
    @State private var selectedArticle: Article?
    
    var body: some View {
        
        // MARK: - List of Articles
        
        List {
            ForEach(articles) { article in
                ArticleRowView(article: article)
                    .onTapGesture {
                        selectedArticle = article
                    }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .sheet(item: $selectedArticle) {
            SafariView(url: $0.articleURL)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    
    // StateObject for managing article bookmarks in previews
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        NavigationView {
            ArticleListView(articles: Article.previewData)
                .environmentObject(articleBookmarkVM)
        }
    }
}
