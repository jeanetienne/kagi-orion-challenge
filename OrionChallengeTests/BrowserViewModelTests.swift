//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import XCTest
@testable import OrionChallenge

final class BrowserViewModelTests: XCTestCase {

    var viewModel: BrowserViewModel!

    override func setUp() {
        super.setUp()
        viewModel = BrowserViewModel(tab: BrowserTab(image: UIImage()))
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func test_home_page_url_returns_correct_url() {
        let expectedURL = URL(string: "https://kagi.com")!
        XCTAssertEqual(viewModel.homePageURL(), expectedURL)
    }

    func test_url_for_input_returns_valid_url_for_likely_url() {
        let input = "https://example.com"
        let result = viewModel.urlForInput(input)
        XCTAssertEqual(result.absoluteString, "https://example.com")
    }

    func test_url_for_input_returns_search_url_for_non_url_input() {
        let input = "search query"
        let encodedQuery = "search%20query"
        let expectedURL = "https://kagi.com/search?q=\(encodedQuery)"
        let result = viewModel.urlForInput(input)
        XCTAssertEqual(result.absoluteString, expectedURL)
    }

    func test_summary_returns_address_when_input_is_valid_url() {
        let input = "https://example.com"
        let result = viewModel.addressSummaryForInput(input)
        if case .address(let host) = result {
            XCTAssertEqual(host, "example.com")
        } else {
            XCTFail("Expected .address, got \(result)")
        }
    }

    func test_summary_returns_truncated_address_when_input_is_url_with_superfluous_subdomain() {
        let input = "https://www.example.com"
        let result = viewModel.addressSummaryForInput(input)
        if case .address(let host) = result {
            XCTAssertEqual(host, "example.com")
        } else {
            XCTFail("Expected .address, got \(result)")
        }
    }

    func test_summary_returns_full_address_when_input_is_url_with_subdomain() {
        let input = "https://blog.example.com"
        let result = viewModel.addressSummaryForInput(input)
        if case .address(let host) = result {
            XCTAssertEqual(host, "blog.example.com")
        } else {
            XCTFail("Expected .address, got \(result)")
        }
    }

    func test_summary_returns_search_when_input_is_query() {
        let input = "search query"
        let result = viewModel.addressSummaryForInput(input)
        if case .search(let query) = result {
            XCTAssertEqual(query, "search query")
        } else {
            XCTFail("Expected .search, got \(result)")
        }
    }

}
