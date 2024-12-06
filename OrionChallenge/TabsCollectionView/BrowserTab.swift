//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

class BrowserTab {

    private let identifier: UUID = UUID()
    private(set) var title: String = ""
    private(set) var image: UIImage
    private(set) var url: URL?

    internal init(title: String = "", image: UIImage, url: URL? = nil) {
        self.title = title
        self.image = image
        self.url = url
    }

    func update(title: String, image: UIImage, url: URL) {
        self.title = title
        self.image = image
        self.url = url
    }

}

extension BrowserTab: Equatable {

    static func == (lhs: BrowserTab, rhs: BrowserTab) -> Bool {
        lhs.identifier == rhs.identifier
    }

}
