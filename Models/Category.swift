//
//  Category.swift
//  News App
//
//  Created by Khushali Vagadia on 14/09/23.
//

import Foundation

enum Category: String, CaseIterable {
case general
case business
case technology
case entertainment
case sports
case science
case health
    
    var text: String {
        if self == .general {
            return "HeadLines"
        }
        return rawValue.capitalized
    }
}

extension Category: Identifiable {
    var id: Self { self }
}
