//
//  GameRowView.swift
//  Example App
//
//  Created by Emmanuel Ramírez on 12/01/25.
//

import SwiftUI

struct GameRowView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let game: GamesModel
    private let searchText: String
    
    init(game: GamesModel, searchText: String) {
        self.game = game
        self.searchText = searchText
    }
    
    var body: some View {
        HStack(spacing: 5) {
            AsyncUrlImageView(game.thumbnail) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(width: 70, height: 70)
            } failResult: { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            VStack(alignment: .leading) {
                StyledText(verbatim: game.title)
                    .style(.highlight(color: .orange), ranges: {
                        [$0.lowercased().folding(options: .diacriticInsensitive, locale: .current)
                            .range(of: searchText.lowercased().folding(options: .diacriticInsensitive, locale: .current))]
                    })
                    .font(.headline)
                    .lineLimit(1)
                
                StyledText(verbatim: game.publisher)
                    .style(.highlight(color: .orange), ranges: {
                        [$0.lowercased().folding(options: .diacriticInsensitive, locale: .current)
                            .range(of: searchText.lowercased().folding(options: .diacriticInsensitive, locale: .current))]
                    })
                    .font(.subheadline)
                    .foregroundStyle(Color.primary)
                    .lineLimit(1)
                
                StyledText(verbatim: game.developer)
                    .style(.highlight(color: .orange), ranges: {
                        [$0.lowercased().folding(options: .diacriticInsensitive, locale: .current)
                            .range(of: searchText.lowercased().folding(options: .diacriticInsensitive, locale: .current))]
                    })
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(5)
        .background(CommonColors.surface.color(colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
}
