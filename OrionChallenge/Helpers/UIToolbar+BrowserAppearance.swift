//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

extension UIToolbar {

    func defaultAppearance() {
        let appearance = UIToolbarAppearance()
        appearance.configureWithDefaultBackground()

        standardAppearance = appearance
        compactAppearance = appearance

        if #available(iOS 15.0, *) {
            scrollEdgeAppearance = appearance
            compactScrollEdgeAppearance = appearance
        }
    }

    func browserAppearance() {
        let appearance = UIToolbarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()

        standardAppearance = appearance
        compactAppearance = appearance

        if #available(iOS 15.0, *) {
            scrollEdgeAppearance = appearance
            compactScrollEdgeAppearance = appearance
        }
    }

}
