//
//  NewsAPIResponse.swift
//  News App
//
//  Created by Khushali Vagadia on 14/09/23.
//

import Foundation

struct NewsAPIResponse: Decodable {
    
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String? 
}
