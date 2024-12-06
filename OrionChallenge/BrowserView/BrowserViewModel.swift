//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

class BrowserViewModel {

    enum AddressBarSummary {
        case address(host: String)
        case search(query: String)
    }

    private let homeURL = URL(string: "https://kagi.com")!
    private let searchBaseURL = "https://kagi.com/search?q="

    func homePageURL() -> URL {
        return homeURL
    }

    func urlForInput(_ input: String) -> URL {
        if input.isLikelyURL, let url = URL(string: input.normaliseURL), UIApplication.shared.canOpenURL(url) {
            return url
        } else {
            let searchQuery = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return URL(string: "\(searchBaseURL)\(searchQuery)")!
        }
    }

    func addressSummaryForInput(_ input: String) -> AddressBarSummary {
        if input.isLikelyURL, let url = URL(string: input.normaliseURL), UIApplication.shared.canOpenURL(url) {
            return .address(host: url.host?.hideCommonSubdomain ?? "")
        } else {
            return .search(query: input)
        }
    }

}
