//
//  GamesMainListViewModel.swift
//  Example App
//
//  Created by Emmanuel Ramírez on 12/01/25.
//

import Foundation
import SwiftUI
import Combine

final class GamesMainListViewModel: ObservableObject, GameListProtocol {
    
    @Published private(set) var gamesList: [GamesModel] = []
    @Published private(set) var showLoading: Bool = false
    @Published private(set) var gameSelected: GamesModel? = nil
    @Published var isSearching: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var showAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var showDetails: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private var didSetup: Bool = false
    private let dbHelper = DatabaseHelper()
    
    var searchGames: [GamesModel] {
        guard !searchText.isEmpty else { return gamesList }
        return gamesList.filter { $0.found(searchText) }
    }
    
    func setUp() {
        guard !didSetup else { return }
        getGamesFromData()
        if gamesList.isEmpty {
            getGamesFromApi()
        }
        didSetup.toggle()
    }
    
    private func getGamesFromApi() {
        
        let publisher = GamesRepository.repo.getGamesList()
        
        showLoading = true
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.showLoading = false
                if case .failure(let error) = completion {
                    print(error)
                    self?.errorMessage = error.localizedDescription
                    self?.showErrorAlert.toggle()
                } else {
                    if self?.gamesList.isEmpty == true {
                        self?.errorMessage = "Empty List"
                        self?.showErrorAlert.toggle()
                    }
                }
            } receiveValue: { [weak self] gamesList in
                let sortedGames = gamesList.sorted { $0.title < $1.title }
                self?.gamesList = sortedGames
                self?.resetGames()
                self?.isertGames(games: sortedGames)
            }
            .store(in: &cancellables)
    }
    
    func removeGame(id: Int) {
        gamesList.removeAll(where: { $0.id == id })
    }
    
    func selectGame(game: GamesModel) {
        self.gameSelected = game
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.showDetails.toggle()
        }
    }
    
    func refreshList() {
        gamesList.removeAll()
        getGamesFromApi()
    }
    
    private func getGamesFromData() {
        self.gamesList = dbHelper.fetchGames()
            .sorted { $0.title < $1.title }
    }
    
    func updateGame(game: GamesModel) {
        guard let index = gamesList.firstIndex(where: { $0.id == game.id }) else {
            return
        }
        self.gamesList[index] = game
        dbHelper.updateGame(game)
    }
    
    func removeGame(game: GamesModel) {
        self.gamesList.removeAll(where: { $0.id == game.id })
        dbHelper.deleteGame(withId: game.id)
    }
    
    private func isertGames(games: [GamesModel]) {
        games.forEach { game in
            dbHelper.insertGame(game: game)
        }
    }
    
    private func resetGames() {
        dbHelper.deleteAllGames()
    }
}
