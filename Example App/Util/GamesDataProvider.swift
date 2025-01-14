//
//  GamesDataProvider.swift
//  Example App
//
//  Created by Emmanuel Ramírez on 13/01/25.
//

import Foundation
import SQLite3
import Combine
import UIKit

class DatabaseHelper {
    var db: OpaquePointer?
    
    deinit {
        sqlite3_close(db)
    }
    
    init() {
        openDatabase()
        createTable()
    }
    
    func openDatabase() {
        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("Games.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error data base")
        }
    }
    
    func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Games (
            id INTEGER PRIMARY KEY,
                        title TEXT NOT NULL,
                        thumbnail TEXT NOT NULL,
                        short_description TEXT,
                        game_url TEXT,
                        genre TEXT NOT NULL,
                        platform TEXT NOT NULL,
                        publisher TEXT NOT NULL,
                        developer TEXT NOT NULL,
                        release_date TEXT,
                        freetogame_profile_url TEXT
        );
        """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("Error create table: \(errorMessage)")
        }
    }
}

extension DatabaseHelper {
    
    func insertGame(game: GamesModel) {
        
        let game = game.bySQL()
        
        let insertQuery = """
        INSERT INTO Games (id, title, thumbnail, short_description, game_url, genre, platform, publisher, developer, release_date, freetogame_profile_url)
        VALUES ('\(game.id)', '\(game.title)', '\(game.thumbnail)', '\(game.short_description ?? "")', '\(game.game_url ?? "")', '\(game.genre)', '\(game.platform)', '\(game.publisher)', '\(game.developer)', '\(game.release_date ?? "")', '\(game.freetogame_profile_url ?? "")');
        """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Insert Succes.")
            } else {
                print("Insert Fail.")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("Error to preparing query: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
    }
    
    func fetchGames() -> [GamesModel] {
        let selectQuery = "SELECT * FROM Games;"
        var statement: OpaquePointer?
        var games: [GamesModel] = []
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String(cString: sqlite3_column_text(statement, 1))
                let thumbnail = String(cString: sqlite3_column_text(statement, 2))
                let shortDescription = String(cString: sqlite3_column_text(statement, 3))
                let gameUrl = String(cString: sqlite3_column_text(statement, 4))
                let genre = String(cString: sqlite3_column_text(statement, 5))
                let platform = String(cString: sqlite3_column_text(statement, 6))
                let publisher = String(cString: sqlite3_column_text(statement, 7))
                let developer = String(cString: sqlite3_column_text(statement, 8))
                let releaseDate = String(cString: sqlite3_column_text(statement, 9))
                let freetogameProfileUrl = String(cString: sqlite3_column_text(statement, 10))
                
                let game = GamesModel(
                    id: id,
                    title: title,
                    thumbnail: thumbnail,
                    short_description: shortDescription.isEmpty ? nil : shortDescription,
                    game_url: gameUrl.isEmpty ? nil : gameUrl,
                    genre: genre,
                    platform: platform,
                    publisher: publisher,
                    developer: developer,
                    release_date: releaseDate.isEmpty ? nil : releaseDate,
                    freetogame_profile_url: freetogameProfileUrl.isEmpty ? nil : freetogameProfileUrl
                )
                games.append(game)
            }
        }
        
        sqlite3_finalize(statement)
        
        return games
    }
    
    func updateGame(_ game: GamesModel) {
        let description = (game.short_description ?? "")
            .replacingOccurrences(of: "'", with: "''")
        
        let updateQuery = """
            UPDATE Games
            SET short_description = '\(description)'
            WHERE id = \(game.id);
            """
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Update Succes.")
            } else {
                print("Update Failed.")
            }
        }
        
        sqlite3_finalize(statement)
    }
    
    func deleteAllGames() {
        let deleteAllQuery = "DELETE FROM Games;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteAllQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("All Delete Succes")
            } else {
                print("All Delete Fail")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("Error query: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
    }
    
    func deleteGame(withId id: Int) {
        let deleteQuery = "DELETE FROM Games WHERE id = \(id);"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Deleted succes.")
            } else {
                print("Deleted failed.")
            }
        }
        
        sqlite3_finalize(statement)
    }
    
}
