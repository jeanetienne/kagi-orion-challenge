//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import Foundation

extension String {

    var isLikelyURL: Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let range = NSRange(location: 0, length: trimmed.utf16.count)
            let matches = detector.matches(in: trimmed, options: [], range: range)
            return matches.contains { $0.range.length == trimmed.utf16.count }
        } catch {
            return false
        }
    }

    var normaliseURL: String {
        if hasPrefix("http") {
            return self
        } else {
            return "http://\(self)"
        }
    }

    var hideCommonSubdomain: String {
        if self.hasPrefix("www.") {
            return String(self.dropFirst(4))
        }
        return self
    }

}
