//
//  Example_AppTests.swift
//  Example AppTests
//
//  Created by Emmanuel Ramírez on 12/01/25.
//

import Combine
@testable import Example_App
import XCTest

class AppTest: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetGamesFromApi() throws {
        let publisher = GamesRepository.repo.getGamesList()
      
        var games: [GamesModel] = []
        
        publisher
            .sink { completion in
                if case .finished = completion {
                    XCTAssert(!games.isEmpty)
                }
            } receiveValue: { gamesList in
                games = gamesList
            }
            .store(in: &cancellables)
    }
    
    func testInvalidShortDescription() throws {
        let invalid = " \n"
        
        let viewModel = DescriptionFormViewModel()
        viewModel.description = invalid
        
        XCTAssert(!viewModel.validateDescription())
    }
    
    func testValidShortDescription() throws {
        let invalid = "Example of test"
        
        let viewModel = DescriptionFormViewModel()
        viewModel.description = invalid
        
        XCTAssert(viewModel.validateDescription())
    }
    
}
