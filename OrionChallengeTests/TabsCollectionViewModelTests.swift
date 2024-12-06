//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import XCTest
@testable import OrionChallenge

class TabsCollectionViewModelTests: XCTestCase {

    func test_init_with_empty_tabs_creates_empty_tabs_array() {
        let viewModel = TabsCollectionViewModel()
        XCTAssertTrue(viewModel.tabs.isEmpty)
    }

    func test_init_with_tabs_creates_tabs_array() {
        let tab = BrowserTab(title: "Tab 1", image: UIImage())
        let viewModel = TabsCollectionViewModel(tabs: [tab])
        XCTAssertEqual(viewModel.tabs.count, 1)
    }

    func test_shouldEnableDoneButton_is_false_when_tabs_empty() {
        let viewModel = TabsCollectionViewModel()
        XCTAssertFalse(viewModel.shouldEnableDoneButton)
    }

    func test_shouldEnableDoneButton_is_true_when_tabs_not_empty() {
        let tab = BrowserTab(title: "Tab 1", image: UIImage())
        let viewModel = TabsCollectionViewModel(tabs: [tab])
        XCTAssertTrue(viewModel.shouldEnableDoneButton)
    }

    func test_tab_at_returns_correct_tab() {
        let tab = BrowserTab(title: "Tab 1", image: UIImage())
        let viewModel = TabsCollectionViewModel(tabs: [tab])
        XCTAssertEqual(viewModel.tab(at: 0), tab)
    }

    func test_getLastSelectedTab_returns_last_selected_when_set() {
        let tab = BrowserTab(title: "Last Selected", image: UIImage())
        let viewModel = TabsCollectionViewModel(tabs: [tab])
        viewModel.addAndSelectTab()
        XCTAssertEqual(viewModel.getLastSelectedTab()?.title, "New Tab")
    }

    func test_getLastSelectedTab_returns_first_tab_when_last_not_set() {
        let tab = BrowserTab(title: "First Tab", image: UIImage())
        let viewModel = TabsCollectionViewModel(tabs: [tab])
        XCTAssertEqual(viewModel.getLastSelectedTab(), tab)
    }

    func test_addAndSelectTab_adds_new_tab() {
        let viewModel = TabsCollectionViewModel()
        viewModel.addAndSelectTab()
        XCTAssertEqual(viewModel.tabs.count, 1)
    }

    func test_addAndSelectTab_sets_last_selected_tab() {
        let viewModel = TabsCollectionViewModel()
        viewModel.addAndSelectTab()
        XCTAssertEqual(viewModel.getLastSelectedTab()?.title, "New Tab")
    }

    func test_deleteTab_removes_tab_at_index() {
        let tab1 = BrowserTab(title: "Tab 1", image: UIImage())
        let tab2 = BrowserTab(title: "Tab 2", image: UIImage())
        let viewModel = TabsCollectionViewModel(tabs: [tab1, tab2])
        viewModel.deleteTab(at: 0)
        XCTAssertEqual(viewModel.tabs.first, tab2)
    }

    func test_deleteTab_reduces_tab_count() {
        let tab = BrowserTab(title: "Tab 1", image: UIImage())
        let viewModel = TabsCollectionViewModel(tabs: [tab])
        viewModel.deleteTab(at: 0)
        XCTAssertTrue(viewModel.tabs.isEmpty)
    }

}
