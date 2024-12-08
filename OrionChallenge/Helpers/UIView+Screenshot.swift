//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

extension UIView {

    func screenshot(trimTop: CGFloat = 0.0) -> UIImage {
        let trimmedBounds = bounds.insetBy(dx: 0, dy: trimTop)
        let origin = CGPoint(x: 0, y: -trimTop)
        return UIGraphicsImageRenderer(size: trimmedBounds.size).image { _ in
            drawHierarchy(in: CGRect(origin: origin, size: bounds.size), afterScreenUpdates: false)
        }
    }

}
