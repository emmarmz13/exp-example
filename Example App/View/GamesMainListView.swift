//
//  GamesMainListView.swift
//  Example App
//
//  Created by Emmanuel Ramírez on 12/01/25.
//

import SwiftUI

struct GamesMainListView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject private var viewModel: GamesMainListViewModel = GamesMainListViewModel()
    
    var body: some View {
        VStack {
            List(viewModel.searchGames, id: \.id) { game in
                Button {
                    viewModel.selectGame(game: game)
                } label: {
                    GameRowView(game: game, searchText: viewModel.searchText)
                }
                .listRowInsets(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.searchText, isPresented: $viewModel.isSearching)
        }
        .background(CommonColors.background.color(colorScheme))
        .overlay(alignment: .center) {
            if viewModel.showLoading {
                ProgressView()
            }
        }
        .navigationDestination(isPresented: $viewModel.showDetails) {
            NavigationStack {
                if let gameSelected = viewModel.gameSelected {
                    GamesDetailView(game: gameSelected, listViewModel: viewModel)
                }
            }
        }
        .navigationTitle("Videogames")
        .onAppear {
            viewModel.setUp()
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("Error occurred"),
                  message: Text(viewModel.errorMessage ?? ""),
                  dismissButton: .default(Text("Accept"), action: {
                viewModel.errorMessage = nil
            }))
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Do you want to update the elements?"),
                  message: Text("The elements will be reset"),
                  primaryButton: .default(Text("Accept"), action: {
                viewModel.refreshList()
            }), secondaryButton: .cancel())
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    viewModel.showAlert.toggle()
                } label: {
                    Image(systemName: "icloud.and.arrow.down")
                }
                .foregroundStyle(Color.blue)
                Button {
                    viewModel.isSearching.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
    }
}
