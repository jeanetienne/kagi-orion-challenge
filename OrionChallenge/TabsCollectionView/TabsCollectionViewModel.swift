//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

class TabsCollectionViewModel {

    private(set) var tabs: [BrowserTab] = []
    private(set) var lastSelectedTabIndex: Int?

    var lastSelectedTab: BrowserTab? {
        guard let lastSelectedTabIndex else { return tabs.last }
        return tabs[safe: lastSelectedTabIndex]
    }

    var shouldEnableDoneButton: Bool {
        return !tabs.isEmpty
    }

    init(tabs: [BrowserTab] = []) {
        self.tabs = tabs
    }

    func tab(at index: Int) -> BrowserTab? {
        return tabs[safe: index]
    }

    func index(of tab: BrowserTab) -> Int {
        return tabs.firstIndex(of: tab) ?? 0
    }

    func addAndSelectTab() {
        let tab = BrowserTab(title: "New Tab", image: UIImage(named: "empty_tab")!, url: nil)
        tabs.append(tab)
        selectTab(tab)
    }

    func selectTab(_ tab: BrowserTab) {
        lastSelectedTabIndex = tabs.firstIndex(of: tab)
    }

    func selectTab(at index: Int) {
        lastSelectedTabIndex = index
    }

    func deleteTab(at index: Int) {
        tabs.remove(at: index)
    }

    func update(tab: BrowserTab, withTitle title: String?, image: UIImage, url: URL?) {
        guard let url else { return }
        tab.update(title: title ?? url.absoluteString, image: image, url: url)
    }

}
