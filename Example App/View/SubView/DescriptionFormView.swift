//
//  DescriptionFormView.swift
//  Example App
//
//  Created by Emmanuel Ramírez on 14/01/25.
//

import SwiftUI
import Combine

struct DescriptionFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject private var viewModel: DescriptionFormViewModel = DescriptionFormViewModel()
    
    private let description: String
    private let submit: (String) -> Void
    
    init(description: String, submit: @escaping (String) -> Void) {
        self.description = description
        self.submit = submit
    }
    
    var body: some View {
        Form {
            Section {
                TextEditor(text: $viewModel.description)
                    .frame(height: 200)
            } footer: {
                if let message = viewModel.invalidMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(Color.red)
                }
            }
        }
        .background(CommonColors.background.color(colorScheme))
        .navigationTitle("Description")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.description = description
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Accept") {
                    if viewModel.validateDescription() {
                        submit(viewModel.description.trimmingCharacters(in: .whitespacesAndNewlines))
                        dismiss()
                    }
                }
            }
        }
    }
    
}
