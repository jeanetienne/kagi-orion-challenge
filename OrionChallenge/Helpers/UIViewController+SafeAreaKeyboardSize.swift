//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

extension UIViewController {

    func heightWithinSafeArea(forKeyboardSize keyboardSize: CGSize) -> CGFloat {
        return keyboardSize.height - view.safeAreaInsets.bottom
    }

}
