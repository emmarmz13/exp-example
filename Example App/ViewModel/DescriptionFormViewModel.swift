//
//  DescriptionFormViewModel.swift
//  Example App
//
//  Created by Emmanuel Ramírez on 14/01/25.
//

import Combine
import Foundation

class DescriptionFormViewModel: ObservableObject {
    
    private var cancellable: AnyCancellable?
    @Published var invalidMessage: String? = nil
    @Published var description: String = ""
    
    init() {
        cancellable = $description
            .debounce(for: 0.450, scheduler: RunLoop.main)
            .sink { [weak self] newValue in
                self?.validation()
            }
    }
    
    private func validation() {
        if validateDescription() {
            invalidMessage = nil
        } else {
            invalidMessage = "Characters invalid"
        }
    }
    
    func validateDescription() -> Bool {
        
        guard !description.isEmpty else { return true }
        
        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        
        return true
    }
    
}
