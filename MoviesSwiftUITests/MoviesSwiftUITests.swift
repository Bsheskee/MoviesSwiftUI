//
//  MoviesSwiftUITests.swift
//  MoviesSwiftUITests
//
//  Created by bartek on 12/01/2024.
//

import XCTest
import Combine
@testable import MoviesSwiftUI

final class MoviesSwiftUITests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
//integration test, because we are testing the API request
    func testFetchMovies() throws {
        let httpClient = HTTPClient()
        let expectation = XCTestExpectation(description: "Received movies")
        
        httpClient.fetchMovies(search: "Batman")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Request failed with error \(error)")
                }
            } receiveValue: { movies in
                XCTAssertTrue(movies.count > 0)
                expectation.fulfill()
            }.store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }

    

}
