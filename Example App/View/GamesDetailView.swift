//
//  GamesDetailView.swift
//  Example App
//
//  Created by Emmanuel Ramírez on 13/01/25.
//

import SwiftUI

struct GamesDetailView: View {
    
    @Environment(\.openURL) private var openURL
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: GamesDetailViewModel = .init()
    
    private let game: GamesModel
    private weak var listViewModel: GamesMainListViewModel?
    
    init(game: GamesModel, listViewModel: GamesMainListViewModel? = nil) {
        self.game = game
        self.listViewModel = listViewModel
    }
    
    var body: some View {
        List {
            AsyncUrlImageView(game.thumbnail) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
            } failResult: { failImage in
                failImage
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
            }
            .listRowBackground(Color.clear)
            .edgesIgnoringSafeArea(.all)
            
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    if let short_description = viewModel.game?.short_description, !short_description.isEmpty {
                        detailsField(title: "Description", data: short_description)
                    }
                    detailsField(title: "Platform", data: game.platform)
                    detailsField(title: "Publisher", data: game.publisher)
                    detailsField(title: "Genre", data: game.genre)
                    detailsField(title: "Developer", data: game.developer)
                    detailsField(title: "Release Date", data: game.release_date ?? "")
                }
            } header: {
                Text("Game Details")
            }
            .listRowBackground(CommonColors.surface.color(colorScheme))
            .listRowSeparator(.hidden)
            
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    linkField(title: "Game", urlText: game.game_url ?? "")
                    linkField(title: "Freetogame Profile", urlText: game.freetogame_profile_url ?? "")
                }
            } header: {
                Text("Links")
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .onChange(of: viewModel.shouldDismiss) { dismiss() }
        .onAppear {
            viewModel.setUp(game: game, listViewModel: listViewModel)
        }
        .sheet(isPresented: $viewModel.openFormulary) {
            NavigationStack {
                DescriptionFormView(description: viewModel.game?.short_description ?? "") { newDescription in
                    viewModel.didUpdateDescription(newDescription: newDescription)
                }
            }
            .presentationDetents([.large, .medium])
        }
        .listStyle(.plain)
        .background(CommonColors.background.color(colorScheme))
        .navigationTitle(game.title)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    viewModel.openFormulary.toggle()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                .foregroundStyle(Color.blue)
                Button {
                    viewModel.showDeleteAlert.toggle()
                } label: {
                    Image(systemName: "trash")
                }
                .foregroundStyle(Color.red)
            }
        }
        .alert(isPresented: $viewModel.showDeleteAlert) {
            Alert(title: Text("Do you want to delete the element?"),
                  message: Text("The element will be delete"),
                  primaryButton: .destructive(Text("Accept"), action: {
                viewModel.deleteElement()
            }), secondaryButton: .cancel())
        }
    }
    
    @ViewBuilder
    private func linkField(title: String, urlText: String) -> some View {
        if let url = URL(string: urlText) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
                Button(urlText) {
                    openURL.callAsFunction(url)
                }
                .font(.subheadline)
                .foregroundStyle(Color.blue)
                .buttonStyle(.plain)
                .underline(true, color: .blue)
            }
        }
    }
    
    @ViewBuilder
    private func detailsField(title: String, data: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.footnote)
                .foregroundStyle(Color.secondary)
            Text(data)
                .font(.subheadline)
                .foregroundStyle(Color.primary)
        }
    }
}

fileprivate class GamesDetailViewModel: ObservableObject {
    
    @Published private(set) var game: GamesModel? = nil
    @Published var openFormulary: Bool = false
    @Published var showDeleteAlert: Bool = false
    @Published private(set) var shouldDismiss: Bool = false
    private weak var listViewModel: GamesMainListViewModel?
    
    func setUp(game: GamesModel, listViewModel: GamesMainListViewModel?) {
        self.game = game
        self.listViewModel = listViewModel
    }
    
    func didUpdateDescription(newDescription: String) {
        self.game?.short_description = newDescription
        if let game = game {
            self.listViewModel?.updateGame(game: game)
        }
    }
    
    func deleteElement() {
        guard let game = game else { return }
        listViewModel?.removeGame(game: game)
        shouldDismiss.toggle()
    }
    
}
