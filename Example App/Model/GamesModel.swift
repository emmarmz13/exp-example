//
//  GamesModel.swift
//  Example App
//
//  Created by Emmanuel Ramírez on 12/01/25.
//

import Foundation
import SwiftUI

struct GamesModel: Decodable {
    let id: Int
    let title: String
    let thumbnail: String
    var short_description: String?
    let game_url: String?
    let genre: String
    let platform: String
    let publisher: String
    let developer: String
    let release_date: String?
    let freetogame_profile_url: String?
}

extension GamesModel {
    
    func found(_ searchText: String) -> Bool {
        
        let searchText = searchText.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        
        if title.lowercased().folding(options: .diacriticInsensitive, locale: .current).contains(searchText.lowercased()) {
            return true
        }
        
        if publisher.lowercased().folding(options: .diacriticInsensitive, locale: .current).contains(searchText) {
            return true
        }
        
        if developer.lowercased().folding(options: .diacriticInsensitive, locale: .current).contains(searchText) {
            return true
        }
        
        return false
    }
    
    func bySQL() -> Self {
        .init(id: id,
              title: title.replacingOccurrences(of: "'", with: "''"),
              thumbnail: thumbnail.replacingOccurrences(of: "'", with: "''"),
              short_description: short_description?.replacingOccurrences(of: "'", with: "''") ?? nil,
              game_url: game_url?.replacingOccurrences(of: "'", with: "''") ?? nil,
              genre: genre.replacingOccurrences(of: "'", with: "''"),
              platform: platform.replacingOccurrences(of: "'", with: "''"),
              publisher: publisher.replacingOccurrences(of: "'", with: "''"),
              developer: developer.replacingOccurrences(of: "'", with: "''"),
              release_date: release_date?.replacingOccurrences(of: "'", with: "''") ?? nil,
              freetogame_profile_url: freetogame_profile_url?.replacingOccurrences(of: "'", with: "''") ?? nil)
    }
}
