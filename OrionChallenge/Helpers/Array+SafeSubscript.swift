//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import Foundation

extension Array {

    subscript (safe index: Int) -> Array.Element? {
        return indices ~= index ? self[index] : nil
    }

}
