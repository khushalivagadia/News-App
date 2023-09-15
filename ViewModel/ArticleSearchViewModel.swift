//
//  ArticleSearchViewModel.swift
//  News App
//
//  Created by Khushali Vagadia on 15/09/23.
//

import SwiftUI

@MainActor
class ArticleSearchViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var phase: DataFetchPhase<[Article]> = .empty
    @Published var searchQuery = ""
    @Published var history = [String]()
    
    // MARK: - Private Properties
    
    private let historyDataStore = PlistDataStore<[String]>(filename: "histories")
    private let historyMaxLimit = 10
    private let newsAPI = NewsAPI.shared
    
    // MARK: - Computed Property
    
    private var trimmedSearchQuery: String {
        searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - Singleton Instance
    
    static let shared = ArticleSearchViewModel()
    
    private init() {
        load()
    }
    
    // MARK: - History Management
    
    func addHistory(_ text: String) {
        if let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) {
            history.remove(at: index)
        } else if history.count == historyMaxLimit {
            history.remove(at: history.count - 1)
        }
        
        history.insert(text, at: 0)
        historiesUpdated()
    }
    
    func removeHistory(_ text: String) {
        guard let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) else {
            return
        }
        history.remove(at: index)
        historiesUpdated()
    }
    
    func removeAllHistory() {
        history.removeAll()
        historiesUpdated()
    }
    
    // MARK: - Search Article
    
    func searchArticle() async {
        if Task.isCancelled { return }
        
        let searchQuery = trimmedSearchQuery
        phase = .empty
        
        if searchQuery.isEmpty {
            return
        }
        
        do {
            let articles = try await newsAPI.search(for: searchQuery)
            if Task.isCancelled { return }
            if searchQuery != trimmedSearchQuery {
                return
            }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            if searchQuery != trimmedSearchQuery {
                return
            }
            phase = .failure(error)
        }
    }
    
    // MARK: - Load History
    
    private func load() {
        Task {
            self.history = await historyDataStore.load() ?? []
        }
    }
    
    // MARK: - Save History
    
    private func historiesUpdated() {
        let history = self.history
        Task {
            await historyDataStore.save(history)
        }
    }
}
