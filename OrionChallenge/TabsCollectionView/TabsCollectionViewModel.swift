//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

struct BrowserTab {
    let title: String
    let image: UIImage
}

class TabsCollectionViewModel {

    private(set) var tabs: [BrowserTab] = []
    private var lastSelectedTab: BrowserTab?

    var shouldEnableDoneButton: Bool {
        return !tabs.isEmpty
    }

    init(tabs: [BrowserTab] = []) {
        self.tabs = tabs
    }

    func tab(at index: Int) -> BrowserTab {
        tabs[index]
    }

    func getLastSelectedTab() -> BrowserTab? {
        return lastSelectedTab ?? tabs.first
    }

    func addAndSelectTab() {
        let tab = BrowserTab(title: "New Tab", image: UIImage(named: "empty_tab")!)
        tabs.append(tab)
        lastSelectedTab = tab
    }

    func deleteTab(at index: Int) {
        tabs.remove(at: index)
    }

}

extension BrowserTab: Equatable {}
