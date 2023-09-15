//
//  News_AppApp.swift
//  News App
//
//  Created by Khushali Vagadia on 14/09/23.
//

import SwiftUI

@main
struct News_AppApp: App {
    
    @StateObject var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(articleBookmarkVM)
        }
    }
}
