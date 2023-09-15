//
//  ArticleBookmarkViewModel.swift
//  News App
//
//  Created by Khushali Vagadia on 14/09/23.
//

import SwiftUI

@MainActor
class ArticleBookmarkViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var bookmarks: [Article] = []
    
    // MARK: - Private Properties
    
    private let bookmarkStore = PlistDataStore<[Article]>(filename: "bookmarks")
    
    // MARK: - Singleton Instance
    
    static let shared = ArticleBookmarkViewModel()
    
    private init() {
        async {
            await load()
        }
    }
    
    // MARK: - Load Bookmarks
    
    private func load() async {
        bookmarks = await bookmarkStore.load() ?? []
    }
    
    // MARK: - Bookmark Management
    
    func isBookmarked(for article: Article) -> Bool {
        bookmarks.first { article.id == $0.id } != nil
    }
    
    func addBookmark(for article: Article) {
        guard !isBookmarked(for: article) else {
            return
        }
        
        bookmarks.insert(article, at: 0)
        bookmarkUpdated()
    }
    
    func removeBookmark(for article: Article) {
        guard let index = bookmarks.firstIndex(where: { $0.id == article.id }) else {
            return
        }
        
        bookmarks.remove(at: index)
        bookmarkUpdated()
    }
    
    // MARK: - Save Bookmarks
    
    private func bookmarkUpdated() {
        let bookmarks = self.bookmarks
        async {
            await bookmarkStore.save(bookmarks)
        }
    }
}
