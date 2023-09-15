//
//  SafariView.swift
//  News App
//
//  Created by Khushali Vagadia on 14/09/23.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    
    // MARK: - Properties
    
    let url: URL
    
    // MARK: - Make UIViewController
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        // Create and return an SFSafariViewController with the given URL
        SFSafariViewController(url: url)
    }
    
    // MARK: - Update UIViewController
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
