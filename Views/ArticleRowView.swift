//
//  ArticleRowView.swift
//  News App
//
//  Created by Khushali Vagadia on 14/09/23.
//

import SwiftUI

struct ArticleRowView: View {
    
    // EnvironmentObject for managing article bookmarks
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    
    // Article data passed to the view
    let article: Article
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Async image loading
            AsyncImage(url: article.imageURL) { phase in
                switch phase {
                case .empty:
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                case .failure:
                    HStack {
                        Spacer()
                        Image(systemName: "photo")
                            .imageScale(.large)
                        Spacer()
                    }
                    
                    
                @unknown default:
                    fatalError()
                }
            }
            .frame(minHeight: 200, maxHeight: 300)
            .background(Color.gray.opacity(0.3))
            .clipped()
            
            // Display article details
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(2)
                
                HStack {
                    Text(article.captionText)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Spacer()
                    
                    // Button for bookmarking/unbookmarking
                    Button {
                        toggleBookmark(for: article)
                    } label: {
                        Image(systemName: articleBookmarkVM.isBookmarked(for: article) ? "bookmark.fill" : "bookmark")
                    }
                    .buttonStyle(.bordered)
                    
                    // Button for sharing
                    Button {
                        presentShareSheet(url: article.articleURL)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding([.horizontal, .bottom])
            
        }
    }
    
    // Function to toggle article bookmark status
    private func toggleBookmark(for article: Article) {
        if articleBookmarkVM.isBookmarked(for: article) {
            articleBookmarkVM.removeBookmark(for: article)
        } else {
            articleBookmarkVM.addBookmark(for: article)
        }
    }
}

// Extension for presenting a share sheet
extension View {
    
    func presentShareSheet(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?
            .rootViewController?
            .present(activityVC, animated: true)
    }
    
}

struct ArticleRowView_Previews: PreviewProvider {
    
    // StateObject for managing article bookmarks in previews
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        NavigationView {
            List {
                // Preview of ArticleRowView with sample data
                ArticleRowView(article: .previewData[0])
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
        }
        .environmentObject(articleBookmarkVM)
    }
}
