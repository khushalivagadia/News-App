//
//  ArticleNewsViewModel.swift
//  News App
//
//  Created by Khushali Vagadia on 14/09/23.
//

import SwiftUI

// Enum to represent the different phases of data fetching.
enum DataFetchPhase<T> {
    
    case empty
    case success(T)
    case failure(Error)
}

// Struct to represent a token for fetching data based on category and time.
struct FetchTaskToken: Equatable {
    var category: Category
    var token: Date
}

@MainActor
class ArticleNewsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var phase = DataFetchPhase<[Article]>.empty
    @Published var fetchTaskToken: FetchTaskToken
    
    // MARK: - Private Properties
    
    private let newsAPI = NewsAPI.shared
    
    // MARK: - Initialization
    
    init(articles: [Article]? = nil, selectedCategory: Category = .general) {
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
    }
    
    // MARK: - Load Articles
    
    func loadArticles() async {
        
        if Task.isCancelled { return }
        phase = .empty
        do {
            let articles = try await newsAPI.fetch(from: fetchTaskToken.category)
            if Task.isCancelled { return }
            phase = .success(articles)
        }
        catch {
            if Task.isCancelled { return }
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
}
