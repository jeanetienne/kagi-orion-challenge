//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

extension UIScrollView {

    func adjustBottomInsetsForKeyboard(ofSize keyboardSize: CGSize, additionalContentInset: CGFloat = 0.0) {
        setContentAndScrollInsets(bottom: keyboardSize.height, ignoringSafeAreaInsets: true, additionalContentInset: additionalContentInset)
    }

    func adjustBottomInsetsForHiddenKeyboard(additionalContentInset: CGFloat = 0.0) {
        setContentAndScrollInsets(bottom: 0.0, ignoringSafeAreaInsets: false, additionalContentInset: additionalContentInset)
    }

    private func setContentAndScrollInsets(bottom bottomInset: CGFloat, ignoringSafeAreaInsets: Bool, additionalContentInset: CGFloat = 0.0) {
        if ignoringSafeAreaInsets {
            contentInset.bottom = max((bottomInset + additionalContentInset) - safeAreaInsets.bottom, 0)
            verticalScrollIndicatorInsets.bottom = contentInset.bottom
        } else {
            contentInset.bottom = additionalContentInset
            verticalScrollIndicatorInsets.bottom = contentInset.bottom
        }
    }

}
