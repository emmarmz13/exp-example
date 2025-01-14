//
//  GameListProtocol.swift
//  Example App
//
//  Created by Emmanuel Ramírez on 13/01/25.
//

protocol GameListProtocol {
    
    func removeGame(game: GamesModel) -> Void
    
    func updateGame(game: GamesModel) -> Void
    
}
