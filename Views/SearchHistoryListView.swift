//
//  SearchHistoryListView.swift
//  News App
//
//  Created by Khushali Vagadia on 15/09/23.
//

import SwiftUI

struct SearchHistoryListView: View {
    
    // ObservedObject for managing article search
    @ObservedObject var searchVM: ArticleSearchViewModel
    
    // Closure to handle search when a history item is selected
    let onSubmit: (String) -> ()
    
    var body: some View {
        List {
            HStack {
                Text("Recently Searched")
                Spacer()
                Button("Clear") {
                    searchVM.removeAllHistory()
                }
                .foregroundColor(.accentColor)
            }
            .listRowSeparator(.hidden)
            
            // Loop through search history and display items
            ForEach(searchVM.history, id: \.self) { history in
                Button(history) {
                    onSubmit(history)
                }
                
                // Swipe action to delete a history item
                .swipeActions {
                    Button(role: .destructive) {
                        searchVM.removeHistory(history)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

struct SearchHistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Preview of SearchHistoryListView with shared ArticleSearchViewModel
        SearchHistoryListView(searchVM: ArticleSearchViewModel.shared) { _ in
            
        }
    }
}
