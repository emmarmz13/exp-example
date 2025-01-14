//
//  GamesRepository.swift
//  Example App
//
//  Created by Emmanuel Ramírez on 12/01/25.
//

import Foundation
import Combine

class GamesRepository {
    
    public static let repo = GamesRepository()
    
    private init() {}
    
    func getGamesList() -> AnyPublisher<[GamesModel], Error> {
        guard let url = URL(string: "https://www.freetogame.com/api/games") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            
        return publisher
            .tryMap { response in
                if response.data.isEmpty {
                    throw URLError(.unknown)
                }
                return response.data
            }
            .decode(type: [GamesModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
