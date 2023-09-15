//
//  Article.swift
//  News App
//
//  Created by Khushali Vagadia on 14/09/23.
//

import Foundation

// MARK: - Relative Date Formatter

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

// MARK: - Article Model

struct Article {
    let source: Source
    
    let title: String
    let url: String
    let publishedAt: Date
    
    let author: String?
    let description: String?
    let urlToImage: String?
    
    var authorText: String {
        author ?? ""
    }
    
    var descriptionText: String {
        description ?? ""
    }
    
    var captionText: String {
        "\(source.name) · \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
    
    var articleURL: URL {
        URL(string: url)!
    }
    
    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)
    }
}

// MARK: - Codable and Equatable Conformance for Article

extension Article: Codable {}
extension Article: Equatable {}
extension Article: Identifiable {
    var id: String { url }
}

// MARK: - Preview Data

extension Article {
    
    static var previewData: [Article] {
        let previewDataURL = Bundle.main.url(forResource: "news", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        let apiResponse = try! jsonDecoder.decode(NewsAPIResponse.self, from: data)
        return apiResponse.articles ?? []
    }
}

// MARK: - Source Model

struct Source {
    let name: String
}

// MARK: - Codable and Equatable Conformance for Source

extension Source: Codable {}
extension Source: Equatable {}
