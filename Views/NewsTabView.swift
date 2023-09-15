//
//  NewsTabView.swift
//  News App
//
//  Created by Khushali Vagadia on 14/09/23.
//

import SwiftUI

struct NewsTabView: View {
    
    // MARK: - State Object
    
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    
    var body: some View {
        
        // Navigation view to display articles
        
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .task(id: articleNewsVM.fetchTaskToken, loadTask)
                .refreshable(action: refreshTask)
                .navigationTitle(articleNewsVM.fetchTaskToken.category.text)
                .navigationBarItems(trailing: menu)
        }
    }
    
    // MARK: - Overlay View
    
    @ViewBuilder
    private var overlayView: some View {
        
        switch articleNewsVM.phase {
        case .empty:
            ProgressView()        // Display a progress view during loading.
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No Articles", image: nil)  // Show an empty placeholder if there are no articles.
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: refreshTask)
        default: EmptyView()     // Default case, no overlay.
        }
    }
    
    // MARK: - Articles
    
    private var articles: [Article] {
        if case let .success(articles) = articleNewsVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    // MARK: - Load Task
    
    @Sendable
    private func loadTask() async {
        await articleNewsVM.loadArticles()
    }
    
    // MARK: - Refresh Task
    
    private func refreshTask() {
        DispatchQueue.main.async {
            
            // Update the fetchTaskToken to trigger a refresh.
            articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
        }
    }
    
    // MARK: - Menu
    
    private var menu: some View {
        
        // Display a category picker in a menu.
        Menu {
            Picker("Category", selection: $articleNewsVM.fetchTaskToken.category) {
                ForEach(Category.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "fiberchannel")
                .imageScale(.large)
        }
    }
}

struct NewsTabView_Previews: PreviewProvider {
    
    // MARK: - State Object
    
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        
        // Preview of NewsTabView with sample data
        NewsTabView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData))
            .environmentObject(articleBookmarkVM)
    }
}
